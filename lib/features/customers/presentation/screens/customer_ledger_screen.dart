import 'package:flutter/material.dart';
import '../../../../app/theme.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../ledger/providers/ledger_entries_provider.dart';
import '../../../ledger/models/ledger_entry_model.dart';
import 'package:intl/intl.dart';
import '../../providers/parties_provider.dart';
import '../../../../core/utils/pdf_service.dart';
import '../../../../core/utils/excel_service.dart';
import 'package:url_launcher/url_launcher_string.dart';

class CustomerLedgerScreen extends ConsumerStatefulWidget {
  final String customerId; // Technically remotePartyId
  const CustomerLedgerScreen({super.key, required this.customerId});

  @override
  ConsumerState<CustomerLedgerScreen> createState() =>
      _CustomerLedgerScreenState();
}

class _CustomerLedgerScreenState extends ConsumerState<CustomerLedgerScreen> {
  String _searchQuery = '';
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    // If customerId is empty because we haven't properly passed the remoteId,
    // handle it safely
    if (widget.customerId.isEmpty || widget.customerId.startsWith('cust_')) {
      return Scaffold(
        appBar: AppBar(title: const Text('Customer Ledger')),
        body: const Center(child: Text('Invalid customer ID')),
      );
    }

    final entriesState = ref.watch(ledgerEntriesProvider(widget.customerId));

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search transactions...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.white70),
                ),
                style: const TextStyle(color: Colors.white, fontSize: 18),
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val.toLowerCase();
                  });
                },
              )
            : const Text('Customer Ledger'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                if (_isSearching) _searchQuery = '';
                _isSearching = !_isSearching;
              });
            },
          )
        ],
      ),
      body: entriesState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (entries) {
          // Find party details securely from state
          final parties = ref.read(partiesProvider).value ?? [];
          final party = parties.firstWhere(
            (p) => p.remoteId == widget.customerId,
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
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // PDF EXPORT
                      ElevatedButton.icon(
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
                        label: const Text('PDF'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryBlue,
                          foregroundColor: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),

                      // EXCEL EXPORT
                      ElevatedButton.icon(
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

                          await ExcelService.generateAndExportExcel(
                            partyName: party.name,
                            partyPhone: party.phone ?? 'N/A',
                            entries: mappedEntries,
                            totalBalance: totalBalance,
                          );
                        },
                        icon: const Icon(Icons.table_view),
                        label: const Text('Excel'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade700,
                          foregroundColor: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),

                      // REMINDER INTENT
                      ElevatedButton.icon(
                        onPressed: () async {
                          if (party.phone == null || party.phone!.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'No phone number saved for this customer!')),
                            );
                            return;
                          }

                          // We only remind them if they OWE money (totalBalance < 0)
                          final message = totalBalance < 0
                              ? 'Hello ${party.name}, this is a gentle reminder that you have a pending due of Rs. ${totalBalance.abs().toStringAsFixed(0)}. Please clear it at your earliest convenience. Thank you!'
                              : 'Hello ${party.name}, generating a custom reminder for your ledger.';

                          // First try WhatsApp, fallback to SMS
                          final encodedMessage = Uri.encodeComponent(message);
                          final whatsappUrl =
                              'whatsapp://send?phone=${party.phone}&text=$encodedMessage';

                          try {
                            if (await canLaunchUrlString(whatsappUrl)) {
                              await launchUrlString(whatsappUrl);
                            } else {
                              final smsUrl =
                                  'sms:${party.phone}?body=$encodedMessage';
                              await launchUrlString(smsUrl);
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Could not launch messaging app: $e')),
                            );
                          }
                        },
                        icon: const Icon(Icons.notifications_active),
                        label: const Text('Remind'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.warningOrange,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: entries.isEmpty
                    ? const Center(child: Text('No transactions yet'))
                    : ListView.builder(
                        itemCount: entries.length,
                        itemBuilder: (context, index) {
                          // Filter here
                          final entry = entries[index];
                          final matchesSearch = entry.description != null &&
                              entry.description!
                                  .toLowerCase()
                                  .contains(_searchQuery);
                          final amountMatches =
                              entry.amount.toString().contains(_searchQuery);

                          if (_searchQuery.isNotEmpty &&
                              !matchesSearch &&
                              !amountMatches) {
                            return const SizedBox.shrink();
                          }

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
                            onLongPress: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (ctx) => SafeArea(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ListTile(
                                        leading: const Icon(Icons.edit,
                                            color: AppTheme.primaryBlue),
                                        title: const Text('Edit Transaction'),
                                        onTap: () {
                                          Navigator.pop(ctx);
                                          _showEditTransactionDialog(
                                            context,
                                            ref,
                                            entry,
                                          );
                                        },
                                      ),
                                      ListTile(
                                        leading: const Icon(Icons.delete,
                                            color: AppTheme.dangerRed),
                                        title: const Text('Delete Transaction',
                                            style: TextStyle(
                                                color: AppTheme.dangerRed)),
                                        onTap: () async {
                                          Navigator.pop(ctx);
                                          if (entry.remoteId != null) {
                                            await ref
                                                .read(ledgerEntriesProvider(
                                                        widget.customerId)
                                                    .notifier)
                                                .deleteEntry(entry.remoteId!);
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
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
                    context.push('/cash_entry', extra: {
                      'customerId': widget.customerId,
                      'type': 'debit'
                    });
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
                    context.push('/cash_entry', extra: {
                      'customerId': widget.customerId,
                      'type': 'credit'
                    });
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

  void _showEditTransactionDialog(
    BuildContext context,
    WidgetRef ref,
    LedgerEntryModel entry,
  ) {
    final amountController =
        TextEditingController(text: entry.amount.toStringAsFixed(0));
    final descController = TextEditingController(text: entry.description ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Transaction'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount (Rs)',
                prefixText: 'Rs. ',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descController,
              decoration: const InputDecoration(
                labelText: 'Description / Note',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () async {
              final newAmount = double.tryParse(amountController.text);
              if (newAmount == null || newAmount <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Enter a valid amount')),
                );
                return;
              }
              if (entry.remoteId != null) {
                try {
                  await ref
                      .read(ledgerEntriesProvider(widget.customerId).notifier)
                      .editEntry(
                        entry.remoteId!,
                        newAmount,
                        descController.text,
                      );
                  if (ctx.mounted) Navigator.pop(ctx);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Transaction updated successfully'),
                        backgroundColor: AppTheme.successGreen,
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryBlue,
              foregroundColor: Colors.white,
            ),
            child: const Text('SAVE'),
          ),
        ],
      ),
    );
  }
}
