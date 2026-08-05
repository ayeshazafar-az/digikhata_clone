import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminStats {
  final int totalUsers;
  final int totalBusinesses;
  final int totalLedgerEntries;

  AdminStats({
    required this.totalUsers,
    required this.totalBusinesses,
    required this.totalLedgerEntries,
  });
}

final adminStatsProvider =
    StateNotifierProvider<AdminStatsNotifier, AsyncValue<AdminStats>>((ref) {
  return AdminStatsNotifier();
});

class AdminStatsNotifier extends StateNotifier<AsyncValue<AdminStats>> {
  AdminStatsNotifier() : super(const AsyncValue.loading()) {
    loadStats();
  }

  Future<void> loadStats() async {
    try {
      state = const AsyncValue.loading();
      final supabase = Supabase.instance.client;

      final businessesRes = await supabase
          .from('businesses')
          .select('id')
          .count(CountOption.exact);

      final usersRes = await supabase
          .from('profiles')
          .select('id')
          .count(CountOption.exact)
          .catchError((_) => supabase
              .from('businesses')
              .select('id')
              .count(CountOption.exact));

      final entriesRes = await supabase
          .from('ledger_entries')
          .select('id')
          .count(CountOption.exact);

      state = AsyncValue.data(AdminStats(
        totalUsers: usersRes.count,
        totalBusinesses: businessesRes.count,
        totalLedgerEntries: entriesRes.count,
      ));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void decrementBusiness() {
    if (state is AsyncData) {
      final current = state.value!;
      state = AsyncValue.data(AdminStats(
        totalUsers: current.totalUsers,
        totalBusinesses:
            current.totalBusinesses - 1 >= 0 ? current.totalBusinesses - 1 : 0,
        totalLedgerEntries: current.totalLedgerEntries,
      ));
    }
  }
}
