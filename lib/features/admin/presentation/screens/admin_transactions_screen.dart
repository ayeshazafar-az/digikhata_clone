import 'package:flutter/material.dart';
import '../../../../app/theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class AdminTransactionsScreen extends StatelessWidget {
  const AdminTransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Global Transactions'),
        backgroundColor: Colors.black87,
      ),
      body: FutureBuilder(
        future: _fetchAllTransactions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final entries = snapshot.data as List;
          if (entries.isEmpty) {
            return const Center(
                child: Text('No transactions exist in the system yet.'));
          }

          return ListView.separated(
            itemCount: entries.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final e = entries[index];
              final isCredit = e['entry_type'] == 'credit';
              final amount = e['amount'].toString();
              return ListTile(
                leading: Icon(
                  isCredit ? Icons.arrow_downward : Icons.arrow_upward,
                  color: isCredit ? AppTheme.successGreen : AppTheme.dangerRed,
                ),
                title: Text('Business ID: ${e['business_id']}'),
                subtitle:
                    Text('Details: ${e['description'] ?? 'No description'}'),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Rs. $amount',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isCredit
                            ? AppTheme.successGreen
                            : AppTheme.dangerRed,
                      ),
                    ),
                    Text(
                      DateFormat('MM/dd/yyyy')
                          .format(DateTime.parse(e['created_at'])),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<List<dynamic>> _fetchAllTransactions() async {
    return await Supabase.instance.client
        .from('ledger_entries')
        .select()
        .order('created_at', ascending: false)
        .limit(100);
  }
}
