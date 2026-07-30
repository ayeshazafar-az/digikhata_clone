import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/ledger_entry_model.dart';
import '../../../../core/database/local_db.dart';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';

final ledgerEntriesProvider = StateNotifierProvider.family<
    LedgerEntriesNotifier,
    AsyncValue<List<LedgerEntryModel>>,
    String>((ref, partyId) {
  return LedgerEntriesNotifier(partyId);
});

class LedgerEntriesNotifier
    extends StateNotifier<AsyncValue<List<LedgerEntryModel>>> {
  final String partyId;
  final _supabase = Supabase.instance.client;

  LedgerEntriesNotifier(this.partyId) : super(const AsyncValue.loading()) {
    loadEntries();
  }

  Future<void> loadEntries() async {
    try {
      state = const AsyncValue.loading();

      // Load from Isar first
      if (!kIsWeb && LocalDb.isar != null) {
        final localEntries = await LocalDb.isar!.ledgerEntryModels
            .where()
            .remotePartyIdEqualTo(partyId)
            .sortByEntryDateDesc()
            .findAll();
        if (localEntries.isNotEmpty) {
          state = AsyncValue.data(localEntries);
        }
      }

      // Fetch from Supabase
      final response = await _supabase
          .from('ledger_entries')
          .select()
          .eq('party_id', partyId)
          .order('entry_date', ascending: false);

      final entries = (response as List).map((e) {
        return LedgerEntryModel()
          ..remoteId = e['id']
          ..remotePartyId = e['party_id']
          ..amount = (e['amount'] as num).toDouble()
          ..entryType = e['entry_type']
          ..description = e['description']
          ..entryDate = DateTime.parse(e['entry_date'])
          ..createdAt = DateTime.parse(e['created_at'])
          ..syncStatus = e['sync_status'] ?? 'synced';
      }).toList();

      // Save to local Isar
      if (!kIsWeb && LocalDb.isar != null) {
        await LocalDb.isar!.writeTxn(() async {
          for (var entry in entries) {
            await LocalDb.isar!.ledgerEntryModels.putByRemoteId(entry);
          }
        });
      }

      state = AsyncValue.data(entries);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addEntry(double amount, String type, String description) async {
    try {
      await _supabase
          .from('ledger_entries')
          .insert({
            'party_id': partyId,
            'amount': amount,
            'entry_type': type,
            'description': description,
          })
          .select()
          .single();

      await loadEntries();
    } catch (e) {
      rethrow;
    }
  }
}
