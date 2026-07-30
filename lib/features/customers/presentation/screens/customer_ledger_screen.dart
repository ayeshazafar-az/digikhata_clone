import 'package:flutter/material.dart';
import '../../../../app/theme.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../ledger/providers/ledger_entries_provider.dart';
import 'package:intl/intl.dart';
import '../../providers/parties_provider.dart';
import '../../../../core/utils/pdf_service.dart';

class CustomerLedgerScreen extends ConsumerWidget {
  final String customerId; // Technically remotePartyId
  const CustomerLedgerScreen({super.key, required this.customerId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // If customerId is empty because we haven't properly passed the remoteId,
    // handle it safely
    if (customerId.isEmpty || customerId.startsWith('cust_')) {
      return Scaffold(
        appBar: AppBar(title: const Text('Customer Ledger')),
        body: const Center(child: Text('Invalid customer ID')),
      );
    }

    final entriesState = ref.watch(ledgerEntriesProvider(customerId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Ledger'),
      ),
      body: entriesState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (entries) {
          // Find party details securely from state
          final parties = ref.read(partiesProvider).value ?? [];
          final party = parties.firstWhere(
            (p) => p.remoteId == customerId,
            orElse: () => parties.first,
          );

          // Calculate running balance
          double totalBalance = 0;
          for (var entry in entries) {
            if (entry.entryType == 'credit') {
              totalBalance += entry.amount; // You got money
            } else {
              totalBalance -= entry.amount; // You gave money
            }
          }

          final formatter =
              NumberFormat.currency(locale: 'en_IN', symbol: 'Rs. ');

          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Balance:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(
                      formatter.format(totalBalance.abs()),
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: totalBalance >= 0
                              ? AppTheme.successGreen
                              : AppTheme.dangerRed),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: Colors.grey.shade100,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    if (entries.isEmpty) return;

                    final mappedEntries = entries
                        .map((e) => {
                              'created_at': e.entryDate.toIso8601String(),
                              'details': e.description,
                              'entry_type': e.entryType,
                              'amount': e.amount,
                            })
                        .toList();

                    await PdfService.generateAndPrintLedger(
                      partyName: party.name,
                      partyPhone: party.phone ?? 'N/A',
                      entries: mappedEntries,
                      totalBalance: totalBalance,
                    );
                  },
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text('Export PDF Ledger'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: entries.isEmpty
                    ? const Center(child: Text('No transactions yet'))
                    : ListView.builder(
                        itemCount: entries.length,
                        itemBuilder: (context, index) {
                          final entry = entries[index];
                          final isCredit = entry.entryType == 'credit';
                          final dateStr = DateFormat('dd/MM/yyyy hh:mm a')
                              .format(entry.entryDate);

                          return ListTile(
                            title: Text(isCredit
                                ? 'Cash In (You Got)'
                                : 'Cash Out (You Gave)'),
                            subtitle: Text(
                                '${entry.description ?? 'No note'} • $dateStr'),
                            trailing: Text(
                              formatter.format(entry.amount),
                              style: TextStyle(
                                  color: isCredit
                                      ? AppTheme.successGreen
                                      : AppTheme.dangerRed,
                                  fontWeight: FontWeight.bold),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.push('/cash_entry',
                        extra: {'customerId': customerId, 'type': 'debit'});
                  },
                  icon: const Icon(Icons.remove_circle_outline),
                  label: const Text('YOU GAVE'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.dangerRed,
                      minimumSize: const Size(0, 56)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.push('/cash_entry',
                        extra: {'customerId': customerId, 'type': 'credit'});
                  },
                  icon: const Icon(Icons.add_circle_outline),
                  label: const Text('YOU GOT'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.successGreen,
                      minimumSize: const Size(0, 56)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
