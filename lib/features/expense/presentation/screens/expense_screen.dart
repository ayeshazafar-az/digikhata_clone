import 'package:flutter/material.dart';
import '../../../../app/theme.dart';
import '../../../../core/providers/currency_provider.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

final expensesProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  try {
    final supabase = Supabase.instance.client;
    final profileRes =
        await supabase.from('profiles').select('active_business_id').single();
    final activeBusinessId = profileRes['active_business_id'];

    if (activeBusinessId == null) return [];

    final res = await supabase
        .from('expense_entries')
        .select()
        .eq('business_id', activeBusinessId)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(res);
  } catch (e) {
    return [];
  }
});

class ExpenseScreen extends ConsumerWidget {
  const ExpenseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expensesAsync = ref.watch(expensesProvider);

    final currency = ref.watch(currencyProvider);

    return Scaffold(
      backgroundColor:
          Theme.of(context).scaffoldBackgroundColor, // Dark mode background
      appBar: AppBar(
        title: const Text('Expense Book',
            style: TextStyle(color: Colors.white, fontSize: 20)),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: expensesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
            child: Text('Error: $err',
                style: const TextStyle(color: Colors.black87))),
        data: (entries) {
          double totalMonthExpense = 0;
          final today = DateTime.now();

          for (var e in entries) {
            final entryDate = DateTime.parse(e['created_at']);
            if (entryDate.year == today.year &&
                entryDate.month == today.month) {
              totalMonthExpense += double.parse(e['amount'].toString());
            }
          }

          return Stack(
            children: [
              Column(
                children: [
                  _buildStatsHeader(
                      totalMonthExpense, entries.length, currency),
                  if (entries.isEmpty)
                    Expanded(child: _buildEmptyState())
                  else
                    Expanded(
                      child: ListView.separated(
                        itemCount: entries.length,
                        separatorBuilder: (_, __) =>
                            Divider(height: 1, color: Colors.grey.shade800),
                        itemBuilder: (context, index) {
                          final e = entries[index];
                          final date = DateFormat('dd MMM yyyy, hh:mm a')
                              .format(DateTime.parse(e['created_at']));
                          return Dismissible(
                            key: Key(e['id'].toString()),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              child:
                                  const Icon(Icons.delete, color: Colors.white),
                            ),
                            confirmDismiss: (direction) async {
                              return await showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Delete Expense'),
                                  content: const Text(
                                      'Are you sure you want to delete this expense?'),
                                  actions: [
                                    TextButton(
                                        onPressed: () =>
                                            Navigator.pop(ctx, false),
                                        child: const Text('Cancel')),
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx, true),
                                      child: const Text('Delete',
                                          style: TextStyle(color: Colors.red)),
                                    ),
                                  ],
                                ),
                              );
                            },
                            onDismissed: (direction) async {
                              try {
                                await Supabase.instance.client
                                    .from('expense_entries')
                                    .delete()
                                    .eq('id', e['id']);
                                ref.invalidate(expensesProvider);
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Expense deleted')));
                                }
                              } catch (err) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text('Failed to delete: $err')));
                                }
                              }
                            },
                            child: ListTile(
                              onTap: () {
                                _showAddExpenseModal(context, ref, currency,
                                    existingEntry: e);
                              },
                              leading: CircleAvatar(
                                backgroundColor:
                                    Colors.orange.withValues(alpha: 0.2),
                                child: const Icon(Icons.receipt,
                                    color: Colors.orange),
                              ),
                              title: Text(e['category'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87)),
                              subtitle: Text(
                                  '${e['remark'] ?? 'No remark'} \n$date',
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 12)),
                              isThreeLine: true,
                              trailing: Text(
                                '- $currency ${e['amount']}',
                                style: const TextStyle(
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 80),
                ],
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddExpenseModal(context, ref, currency),
        backgroundColor: AppTheme.primaryBlue,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('ADD EXPENSE',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }

  Widget _buildStatsHeader(double total, int count, String currency) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Expenses (This Month)',
                  style: TextStyle(color: Colors.black87, fontSize: 14)),
              Text('$currency $total',
                  style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          const LinearProgressIndicator(
            value: 0.0,
            backgroundColor: Color(0xFF151515),
            valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$count items',
                  style: const TextStyle(color: Colors.grey, fontSize: 12)),
              const Text('Budget Limit: Not Set',
                  style: TextStyle(color: Colors.green, fontSize: 12)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.payments_outlined, size: 100, color: Colors.grey.shade800),
          const SizedBox(height: 16),
          const Text('No Expenses Yet',
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Tap + to log your daily business expenses.',
              style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  void _showAddExpenseModal(
      BuildContext context, WidgetRef ref, String currency,
      {Map<String, dynamic>? existingEntry}) {
    final amountController = TextEditingController(
        text: existingEntry != null ? existingEntry['amount'].toString() : '');
    final categoryController =
        TextEditingController(text: existingEntry?['category'] ?? '');
    final remarkController =
        TextEditingController(text: existingEntry?['remark'] ?? '');

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
            Text(existingEntry != null ? 'Edit Expense' : 'Add Expense',
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87)),
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
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black87)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: categoryController,
              style: const TextStyle(color: Colors.black87),
              decoration: const InputDecoration(
                labelText: 'Category (e.g. Fuel, Rent)',
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black87)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: remarkController,
              style: const TextStyle(color: Colors.black87),
              decoration: const InputDecoration(
                labelText: 'Remarks',
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
                if (amountController.text.isEmpty ||
                    categoryController.text.isEmpty) {
                  return;
                }
                try {
                  final supabase = Supabase.instance.client;
                  final pRes = await supabase
                      .from('profiles')
                      .select('active_business_id')
                      .single();
                  final bId = pRes['active_business_id'];
                  if (bId != null) {
                    if (existingEntry != null) {
                      await supabase.from('expense_entries').update({
                        'category': categoryController.text,
                        'amount': double.parse(amountController.text),
                        'remark': remarkController.text,
                      }).eq('id', existingEntry['id']);
                    } else {
                      await supabase.from('expense_entries').insert({
                        'business_id': bId,
                        'category': categoryController.text,
                        'amount': double.parse(amountController.text),
                        'remark': remarkController.text,
                      });
                    }
                    ref.invalidate(expensesProvider);
                    if (context.mounted) Navigator.pop(ctx);
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Error saving expense')));
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 54),
                backgroundColor: AppTheme.primaryBlue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('SAVE EXPENSE',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 16)),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
