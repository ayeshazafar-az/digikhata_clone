import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/party_model.dart';
import '../../../../core/database/local_db.dart';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';

// Provides the active business ID. For now, we take the first business the user owns.
final activeBusinessProvider = FutureProvider<String?>((ref) async {
  final user = Supabase.instance.client.auth.currentUser;
  if (user == null) return null;
  final data = await Supabase.instance.client
      .from('businesses')
      .select('id')
      .eq('owner_id', user.id)
      .limit(1)
      .single();
  return data['id'] as String?;
});

final partiesProvider =
    StateNotifierProvider<PartiesNotifier, AsyncValue<List<PartyModel>>>((ref) {
  final businessId = ref.watch(activeBusinessProvider).value;
  return PartiesNotifier(businessId);
});

class PartiesNotifier extends StateNotifier<AsyncValue<List<PartyModel>>> {
  final String? businessId;
  final _supabase = Supabase.instance.client;

  PartiesNotifier(this.businessId) : super(const AsyncValue.loading()) {
    if (businessId != null) {
      loadParties();
    } else {
      state = const AsyncValue.data([]);
    }
  }

  Future<void> loadParties() async {
    try {
      state = const AsyncValue.loading();

      // Attempt to load from offline Isar first
      if (!kIsWeb && LocalDb.isar != null) {
        final localParties = await LocalDb.isar!.partyModels
            .where()
            .remoteBusinessIdEqualTo(businessId)
            .findAll();
        if (localParties.isNotEmpty) {
          state = AsyncValue.data(localParties);
        }
      }

      // Fetch from Supabase
      final response = await _supabase
          .from('parties')
          .select()
          .eq('business_id', businessId!);

      final parties = (response as List).map((e) {
        return PartyModel()
          ..remoteId = e['id']
          ..remoteBusinessId = e['business_id']
          ..name = e['name']
          ..phone = e['phone']
          ..type = e['type'] ?? 'customer'
          ..createdAt = DateTime.parse(e['created_at'])
          ..isSynced = true;
      }).toList();

      // Save to local Isar
      if (!kIsWeb && LocalDb.isar != null) {
        await LocalDb.isar!.writeTxn(() async {
          for (var p in parties) {
            await LocalDb.isar!.partyModels.putByRemoteId(p);
          }
        });
      }

      state = AsyncValue.data(parties);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addParty(String name, String phone, String type) async {
    if (businessId == null) return;

    try {
      // Optimistic offline insert logic here depending on network
      await _supabase
          .from('parties')
          .insert({
            'business_id': businessId!,
            'name': name,
            'phone': phone,
            'type': type,
          })
          .select()
          .single();

      // Refresh list
      await loadParties();
    } catch (e) {
      rethrow;
    }
  }
}
