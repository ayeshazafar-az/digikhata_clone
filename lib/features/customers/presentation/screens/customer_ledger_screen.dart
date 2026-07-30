import 'package:flutter/material.dart';
import '../../../../app/theme.dart';
import 'package:go_router/go_router.dart';

class CustomerLedgerScreen extends StatefulWidget {
  final String customerId;
  const CustomerLedgerScreen({super.key, required this.customerId});

  @override
  State<CustomerLedgerScreen> createState() => _CustomerLedgerScreenState();
}

class _CustomerLedgerScreenState extends State<CustomerLedgerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Ledger'),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Balance:',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const Text('Rs. 5,000',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.dangerRed)),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 3,
              itemBuilder: (context, index) {
                // Mock entries
                final isCredit = index % 2 == 0;
                return ListTile(
                  title: Text(isCredit ? 'Cash In' : 'Cash Out'),
                  subtitle: Text('Note $index • 12/08/2026'),
                  trailing: Text(
                    isCredit ? 'Rs. 2,000' : 'Rs. 1,000',
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
}
