import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import '../../../../app/theme.dart';

final cashbookProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = Supabase.instance.client;
  final profileRes =
      await supabase.from('profiles').select('active_business_id').single();
  final activeBusinessId = profileRes['active_business_id'];

  if (activeBusinessId == null) return [];

  final res = await supabase
      .from('cashbook_entries')
      .select()
      .eq('business_id', activeBusinessId)
      .order('created_at', ascending: false);

  return List<Map<String, dynamic>>.from(res);
});

class CashBookScreen extends ConsumerWidget {
  const CashBookScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cashAsync = ref.watch(cashbookProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cashbook (Cash In Hand)',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
      ),
      body: cashAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => _buildEmptyState(context, ref),
        data: (entries) {
          if (entries.isEmpty) return _buildEmptyState(context, ref);

          double totalCashInHand = 0;
          for (var e in entries) {
            final amt = double.parse(e['amount'].toString());
            if (e['entry_type'] == 'cash_in')
              totalCashInHand += amt;
            else
              totalCashInHand -= amt;
          }

          return Column(
            children: [
              _buildHeader(totalCashInHand),
              Expanded(
                child: ListView.separated(
                  itemCount: entries.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final e = entries[index];
                    final isCashIn = e['entry_type'] == 'cash_in';
                    final date = DateFormat('dd MMM yyyy, hh:mm a')
                        .format(DateTime.parse(e['created_at']));
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: isCashIn
                            ? AppTheme.successGreen.withOpacity(0.2)
                            : AppTheme.dangerRed.withOpacity(0.2),
                        child: Icon(
                          isCashIn ? Icons.arrow_downward : Icons.arrow_upward,
                          color: isCashIn
                              ? AppTheme.successGreen
                              : AppTheme.dangerRed,
                        ),
                      ),
                      title: Text(
                          e['remark'] ?? (isCashIn ? 'Cash In' : 'Cash Out'),
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle:
                          Text(date, style: const TextStyle(fontSize: 12)),
                      trailing: Text(
                        '${isCashIn ? '+' : '-'} Rs. ${e['amount']}',
                        style: TextStyle(
                          color: isCashIn
                              ? AppTheme.successGreen
                              : AppTheme.dangerRed,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton.extended(
              heroTag: 'cash_out_btn',
              onPressed: () => _showAddEntryModal(context, ref, 'cash_out'),
              backgroundColor: AppTheme.dangerRed,
              icon: const Icon(Icons.remove, color: Colors.white),
              label:
                  const Text('Cash Out', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(width: 16),
            FloatingActionButton.extended(
              heroTag: 'cash_in_btn',
              onPressed: () => _showAddEntryModal(context, ref, 'cash_in'),
              backgroundColor: AppTheme.successGreen,
              icon: const Icon(Icons.add, color: Colors.white),
              label:
                  const Text('Cash In', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(double total) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: total >= 0
            ? AppTheme.successGreen.withOpacity(0.1)
            : AppTheme.dangerRed.withOpacity(0.1),
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Total Cash in Hand',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text(
            'Rs. $total',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: total >= 0 ? AppTheme.successGreen : AppTheme.dangerRed,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.account_balance_wallet_outlined,
              size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text('No Cashbook Entries Yet',
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Track your physical drawer cash separately from Khata.',
              style: TextStyle(color: Colors.grey.shade500)),
        ],
      ),
    );
  }

  void _showAddEntryModal(BuildContext context, WidgetRef ref, String type) {
    final amountController = TextEditingController();
    final remarkController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
          left: 24,
          right: 24,
          top: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(type == 'cash_in' ? 'Add Cash In' : 'Add Cash Out',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: type == 'cash_in'
                        ? AppTheme.successGreen
                        : AppTheme.dangerRed)),
            const SizedBox(height: 24),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                prefixText: 'Rs. ',
                labelText: 'Amount',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: remarkController,
              decoration: const InputDecoration(
                labelText: 'Remark / Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                if (amountController.text.isEmpty) return;

                final supabase = Supabase.instance.client;
                final profileRes = await supabase
                    .from('profiles')
                    .select('active_business_id')
                    .single();
                final activeBusinessId = profileRes['active_business_id'];

                if (activeBusinessId != null) {
                  try {
                    await supabase.from('cashbook_entries').insert({
                      'business_id': activeBusinessId,
                      'entry_type': type,
                      'amount': double.parse(amountController.text),
                      'remark': remarkController.text,
                    });
                    ref.invalidate(cashbookProvider); // Refresh list
                    Navigator.pop(ctx);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content:
                            Text('Error: Database tables not created yet!')));
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: type == 'cash_in'
                    ? AppTheme.successGreen
                    : AppTheme.dangerRed,
                foregroundColor: Colors.white,
              ),
              child: const Text('SAVE ENTRY',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
