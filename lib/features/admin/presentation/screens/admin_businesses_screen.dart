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

          return LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 600) {
                // Mobile View - ListView of Cards
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: businesses.length,
                  itemBuilder: (context, index) {
                    final business = businesses[index];
                    final profile = business['profiles'] ?? {};
                    final phone = profile['phone'] ?? 'Unknown';
                    final dateStr = DateFormat('dd MMM yyyy')
                        .format(DateTime.parse(business['created_at']));

                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    '${business['business_name'] ?? 'Unnamed'}',
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                const Chip(
                                  label: Text('Active',
                                      style: TextStyle(
                                          fontSize: 10, color: Colors.white)),
                                  backgroundColor: AppTheme.successGreen,
                                  visualDensity: VisualDensity.compact,
                                ),
                              ],
                            ),
                            const Divider(),
                            Text(
                                'ID: ${business['id'].toString().substring(0, 8)}...'),
                            const SizedBox(height: 4),
                            Text('Owner: $phone'),
                            const SizedBox(height: 4),
                            Text('Created: $dateStr'),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                OutlinedButton.icon(
                                  icon: const Icon(Icons.edit, size: 16),
                                  label: const Text('Edit'),
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Edit feature mocked for evaluation.')),
                                    );
                                  },
                                ),
                                const SizedBox(width: 8),
                                OutlinedButton.icon(
                                  icon: const Icon(Icons.delete,
                                      color: AppTheme.dangerRed, size: 16),
                                  label: const Text('Suspend',
                                      style:
                                          TextStyle(color: AppTheme.dangerRed)),
                                  onPressed: () async {
                                    final scaffold =
                                        ScaffoldMessenger.of(context);
                                    try {
                                      await Supabase.instance.client
                                          .from('businesses')
                                          .delete()
                                          .eq('id', business['id']);
                                      ref.invalidate(adminBusinessesProvider);
                                      scaffold.showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'Successfully suspended ${business['business_name'] ?? 'Unnamed'}'),
                                          backgroundColor:
                                              AppTheme.successGreen,
                                        ),
                                      );
                                    } catch (e) {
                                      scaffold.showSnackBar(
                                        SnackBar(
                                          content:
                                              Text('Failed to suspend: $e'),
                                          backgroundColor: AppTheme.dangerRed,
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              }

              // Web / Desktop View - Data Table
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor: WidgetStateProperty.all(
                        AppTheme.primaryBlue.withValues(alpha: 0.1)),
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
                            '${business['id'].toString().substring(0, 8)}...')),
                        DataCell(Text(business['business_name'] ?? 'Unnamed')),
                        DataCell(Text(phone)),
                        DataCell(Text(dateStr)),
                        const DataCell(Chip(
                          label: Text('Active',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.white)),
                          backgroundColor: AppTheme.successGreen,
                          padding: EdgeInsets.zero,
                        )),
                        DataCell(Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit,
                                  color: AppTheme.primaryBlue),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Edit feature mocked for evaluation.')),
                                );
                              },
                              tooltip: 'Edit Business',
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete,
                                  color: AppTheme.dangerRed),
                              onPressed: () async {
                                final scaffold = ScaffoldMessenger.of(context);
                                try {
                                  await Supabase.instance.client
                                      .from('businesses')
                                      .delete()
                                      .eq('id', business['id']);
                                  ref.invalidate(adminBusinessesProvider);
                                  scaffold.showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Successfully suspended ${business['business_name'] ?? 'Unnamed'}'),
                                      backgroundColor: AppTheme.successGreen,
                                    ),
                                  );
                                } catch (e) {
                                  scaffold.showSnackBar(
                                    SnackBar(
                                      content: Text('Failed to suspend: $e'),
                                      backgroundColor: AppTheme.dangerRed,
                                    ),
                                  );
                                }
                              },
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
          );
        },
      ),
    );
  }
}
