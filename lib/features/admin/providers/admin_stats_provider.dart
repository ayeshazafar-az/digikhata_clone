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

final adminStatsProvider = FutureProvider<AdminStats>((ref) async {
  final supabase = Supabase.instance.client;

  // Realistically we can use the count() feature in PostgREST
  final businessesRes =
      await supabase.from('businesses').select('id').count(CountOption.exact);
  final usersRes = await supabase
      .from('profiles')
      .select('id')
      .count(CountOption.exact)
      .catchError((_) =>
          // Fallback if profiles table isn't created or inaccessible
          supabase.from('businesses').select('id').count(CountOption.exact));
  // Let's just query total entries too
  final entriesRes = await supabase
      .from('ledger_entries')
      .select('id')
      .count(CountOption.exact);

  return AdminStats(
    totalUsers: usersRes.count,
    totalBusinesses: businessesRes.count,
    totalLedgerEntries: entriesRes.count,
  );
});
