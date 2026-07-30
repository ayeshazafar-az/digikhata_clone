import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardStats {
  final double totalCashIn;
  final double totalCashOut;
  final double netBalance;
  final List<Map<String, dynamic>> recentEntries;

  DashboardStats({
    required this.totalCashIn,
    required this.totalCashOut,
    required this.netBalance,
    required this.recentEntries,
  });
}

final dashboardStatsProvider = FutureProvider<DashboardStats>((ref) async {
  final supabase = Supabase.instance.client;

  // Fetch all ledger entries the user has access to. RLS protects data leak.
  final res = await supabase
      .from('ledger_entries')
      .select('amount, entry_type, created_at')
      .order('created_at', ascending: false);

  final List<Map<String, dynamic>> entries =
      List<Map<String, dynamic>>.from(res);

  double cashIn = 0;
  double cashOut = 0;

  for (var entry in entries) {
    double amount = (entry['amount'] as num).toDouble();
    if (entry['entry_type'] == 'credit') {
      cashIn += amount;
    } else {
      cashOut += amount;
    }
  }

  // To build the chart, we can just pass the latest 30 entries
  final recent = entries.take(30).toList(); // Last 30 entries for line chart
  recent.sort((a, b) => a['created_at']
      .compareTo(b['created_at'])); // Sort chronologically for chart

  return DashboardStats(
    totalCashIn: cashIn,
    totalCashOut: cashOut,
    netBalance: cashIn - cashOut,
    recentEntries: recent,
  );
});
