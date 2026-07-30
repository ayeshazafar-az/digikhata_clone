import 'package:flutter/material.dart';
import '../../../../app/theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

final adminBusinessesProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = Supabase.instance.client;
  // Fetch all businesses with owner details if possible
  final res = await supabase.from('businesses').select('''
    *,
    profiles:owner_id(phone, role)
  ''').order('created_at', ascending: false);

  return List<Map<String, dynamic>>.from(res);
});

class AdminBusinessesScreen extends ConsumerWidget {
  const AdminBusinessesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final businessesAsync = ref.watch(adminBusinessesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Businesses'),
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
      ),
      body: businessesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (businesses) {
          if (businesses.isEmpty) {
            return const Center(child: Text('No businesses registered yet.'));
          }

          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: MaterialStateProperty.all(
                    AppTheme.primaryBlue.withOpacity(0.1)),
                columns: const [
                  DataColumn(
                      label: Text('ID',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Business Name',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Owner Phone',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Created At',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Status',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Actions',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                ],
                rows: businesses.map((business) {
                  final profile = business['profiles'] ?? {};
                  final phone = profile['phone'] ?? 'Unknown';
                  final dateStr = DateFormat('dd MMM yyyy')
                      .format(DateTime.parse(business['created_at']));

                  return DataRow(cells: [
                    DataCell(Text(
                        business['id'].toString().substring(0, 8) + '...')),
                    DataCell(Text(business['business_name'] ?? 'Unnamed')),
                    DataCell(Text(phone)),
                    DataCell(Text(dateStr)),
                    const DataCell(Chip(
                      label: Text('Active',
                          style: TextStyle(fontSize: 12, color: Colors.white)),
                      backgroundColor: AppTheme.successGreen,
                      padding: EdgeInsets.zero,
                    )),
                    DataCell(Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit,
                              color: AppTheme.primaryBlue),
                          onPressed: () {},
                          tooltip: 'Edit Business',
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete,
                              color: AppTheme.dangerRed),
                          onPressed: () {},
                          tooltip: 'Suspend Business',
                        ),
                      ],
                    )),
                  ]);
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}
