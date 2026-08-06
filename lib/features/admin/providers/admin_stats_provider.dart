import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class AdminStats {
  final int totalUsers;
  final int totalBusinesses;
  final int totalLedgerEntries;
  final Map<String, int> monthlyGrowth;

  AdminStats({
    required this.totalUsers,
    required this.totalBusinesses,
    required this.totalLedgerEntries,
    required this.monthlyGrowth,
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

      // Fetch profiles with created_at for authentic growth data
      final profilesRes = await supabase
          .from('profiles')
          .select('id, created_at')
          .catchError((_) => []);

      int totalUsers = (profilesRes as List).isEmpty ? 0 : profilesRes.length;

      // Map created_at into monthly buckets for the last 6 months
      final Map<String, int> growth = {};
      final now = DateTime.now();
      for (int i = 5; i >= 0; i--) {
        final monthDate = DateTime(now.year, now.month - i, 1);
        final monthKey = DateFormat('MMM').format(monthDate);
        growth[monthKey] = 0;
      }

      for (var profile in (profilesRes as List)) {
        if (profile['created_at'] != null) {
          final dt = DateTime.tryParse(profile['created_at']);
          if (dt != null) {
            final mk = DateFormat('MMM').format(dt);
            if (growth.containsKey(mk)) {
              growth[mk] = growth[mk]! + 1;
            }
          }
        }
      }

      // If no valid users were found, fallback to business count as user proxy (since RLS might block profiles)
      if (totalUsers == 0) {
        totalUsers = businessesRes.count;
      }

      final entriesRes = await supabase
          .from('ledger_entries')
          .select('id')
          .count(CountOption.exact);

      state = AsyncValue.data(AdminStats(
        totalUsers: totalUsers,
        totalBusinesses: businessesRes.count,
        totalLedgerEntries: entriesRes.count,
        monthlyGrowth: growth,
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
        monthlyGrowth: current.monthlyGrowth,
      ));
    }
  }
}
