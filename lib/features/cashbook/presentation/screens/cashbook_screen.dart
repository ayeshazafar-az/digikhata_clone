import 'package:flutter/material.dart';
import '../../../../app/theme.dart';
import '../../../../core/providers/currency_provider.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

final cashbookProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  try {
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
  } catch (e) {
    return [];
  }
});

class CashBookScreen extends ConsumerWidget {
  final bool isRoot;
  const CashBookScreen({super.key, this.isRoot = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cashAsync = ref.watch(cashbookProvider);
    final currency = ref.watch(currencyProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Cash Book',
            style: TextStyle(color: Colors.white, fontSize: 20)),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: isRoot
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back_ios,
                    color: Colors.white, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
      ),
      body: cashAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
            child: Text('Error: $err',
                style: const TextStyle(color: Colors.black87))),
        data: (entries) {
          double totalCashInHand = 0;
          double todayBalance = 0;
          final today = DateTime.now();

          for (var e in entries) {
            final amt = double.parse(e['amount'].toString());
            final isCashIn = e['entry_type'] == 'cash_in';
            if (isCashIn) {
              totalCashInHand += amt;
            } else {
              totalCashInHand -= amt;
            }

            final entryDate = DateTime.parse(e['created_at']);
            if (entryDate.year == today.year &&
                entryDate.month == today.month &&
                entryDate.day == today.day) {
              if (isCashIn) {
                todayBalance += amt;
              } else {
                todayBalance -= amt;
              }
            }
          }

          return Stack(
            children: [
              Column(
                children: [
                  _buildHeader(totalCashInHand, todayBalance, currency),
                  if (entries.isEmpty)
                    Expanded(child: _buildEmptyState(context))
                  else
                    Expanded(
                      child: ListView.separated(
                        itemCount: entries.length,
                        separatorBuilder: (_, __) =>
                            Divider(height: 1, color: Colors.grey.shade800),
                        itemBuilder: (context, index) {
                          final e = entries[index];
                          final isCashIn = e['entry_type'] == 'cash_in';
                          final date = DateFormat('dd MMM yyyy, hh:mm a')
                              .format(DateTime.parse(e['created_at']));
                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 4),
                            leading: CircleAvatar(
                              backgroundColor: isCashIn
                                  ? Colors.green.withValues(alpha: 0.1)
                                  : Colors.red.withValues(alpha: 0.1),
                              child: Icon(
                                isCashIn
                                    ? Icons.arrow_downward
                                    : Icons.arrow_upward,
                                color: isCashIn ? Colors.green : Colors.red,
                              ),
                            ),
                            title: Text(
                                e['remark'] ??
                                    (isCashIn ? 'Cash In' : 'Cash Out'),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87)),
                            subtitle: Text(date,
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey)),
                            trailing: Text(
                              '${isCashIn ? '+' : '-'} $currency ${e['amount']}',
                              style: TextStyle(
                                color: isCashIn ? Colors.green : Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 100), // padding for FAB
                ],
              ),
              Positioned(
                bottom: 24,
                left: 16,
                right: 16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.arrow_downward,
                        color: Colors.red, size: 28),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () => _showAddEntryModal(
                              context, ref, 'cash_out', currency),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade900,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24)),
                          ),
                          child: const Text('CASH OUT',
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () => _showAddEntryModal(
                              context, ref, 'cash_in', currency),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24)),
                          ),
                          child: const Text('CASH IN',
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(double total, double todayBal, String currency) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Column(
              children: [
                Text('$currency ${total.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                const SizedBox(height: 4),
                const Text('Cash in Hand',
                    style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          Container(width: 1, height: 40, color: Colors.grey.shade800),
          Expanded(
            child: Column(
              children: [
                Text('$currency ${todayBal.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                const SizedBox(height: 4),
                const Text('Today Balance',
                    style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          Container(width: 1, height: 40, color: Colors.grey.shade800),
          const Expanded(
            child: Column(
              children: [
                Icon(Icons.history, color: Colors.white, size: 20),
                SizedBox(height: 4),
                Text('History',
                    style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final todayStr = DateFormat('E, dd MMM yyyy').format(DateTime.now());
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 80,
            backgroundColor: Colors.brown.withValues(alpha: 0.3),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(Icons.calendar_month,
                    size: 90, color: Colors.black87),
                Positioned(
                  top: 20,
                  left: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.green),
                    child:
                        const Icon(Icons.lock, color: Colors.black87, size: 16),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Text(todayStr,
              style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          const Text("Lets make today's cash entries",
              style: TextStyle(color: Colors.grey, fontSize: 16)),
        ],
      ),
    );
  }

  void _showAddEntryModal(
      BuildContext context, WidgetRef ref, String type, String currency) {
    final amountController = TextEditingController();
    final remarkController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
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
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: type == 'cash_in' ? Colors.green : Colors.red)),
            const SizedBox(height: 24),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
              decoration: InputDecoration(
                prefixText: '$currency ',
                prefixStyle:
                    const TextStyle(color: Colors.black87, fontSize: 24),
                labelText: 'Amount',
                labelStyle: const TextStyle(color: Colors.grey),
                enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black87)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: remarkController,
              style: const TextStyle(color: Colors.black87),
              decoration: const InputDecoration(
                labelText: 'Remark / Description',
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black87)),
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
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Error: Database error.')));
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 54),
                backgroundColor: type == 'cash_in' ? Colors.green : Colors.red,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('SAVE ENTRY',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontSize: 16)),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
