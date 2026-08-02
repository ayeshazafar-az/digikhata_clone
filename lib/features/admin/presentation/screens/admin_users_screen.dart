import 'package:flutter/material.dart';
import '../../../../app/theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

// Depending on Supabase setup, public.profiles might be readable by admins.
final adminUsersProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = Supabase.instance.client;
  // Fetch from the profiles table or standard users table
  // Sometimes querying auth.users from client is blocked, so we use public.profiles
  final res = await supabase
      .from('profiles')
      .select()
      .order('created_at', ascending: false)
      .catchError((_) => []);

  return List<Map<String, dynamic>>.from(res);
});

class AdminUsersScreen extends ConsumerWidget {
  const AdminUsersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(adminUsersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Users'),
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
      ),
      body: usersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (users) {
          if (users.isEmpty) {
            return const Center(
                child: Text(
                    'No user profiles found. (Make sure public.profiles has RLS allowing admins to select)'));
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
                      label: Text('Phone',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Role',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Join Date',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('KYC Status',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Actions',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                ],
                rows: users.map((user) {
                  final dateStr = DateFormat('dd MMM yyyy')
                      .format(DateTime.parse(user['created_at']));

                  return DataRow(cells: [
                    DataCell(
                        Text(user['id'].toString().substring(0, 8) + '...')),
                    DataCell(Text(user['phone'] ?? 'Unknown')),
                    DataCell(Chip(
                      label: Text((user['role'] ?? 'user').toUpperCase(),
                          style: const TextStyle(
                              fontSize: 12, color: Colors.white)),
                      backgroundColor: user['role'] == 'super_admin'
                          ? AppTheme.warningOrange
                          : AppTheme.secondaryBlue,
                      padding: EdgeInsets.zero,
                    )),
                    DataCell(Text(dateStr)),
                    DataCell(Chip(
                      label: Text(
                        (user['kyc_status'] ?? 'pending').toUpperCase(),
                        style:
                            const TextStyle(fontSize: 10, color: Colors.white),
                      ),
                      backgroundColor: user['kyc_status'] == 'verified'
                          ? AppTheme.successGreen
                          : (user['kyc_status'] == 'rejected'
                              ? AppTheme.dangerRed
                              : AppTheme.warningOrange),
                      padding: EdgeInsets.zero,
                    )),
                    DataCell(Row(
                      children: [
                        if (user['kyc_status'] == 'pending')
                          IconButton(
                            icon: const Icon(Icons.assignment_ind,
                                color: AppTheme.primaryBlue),
                            tooltip: 'Review KYC Documents',
                            onPressed: () {
                              _showKycReviewDialog(context, ref, user);
                            },
                          ),
                        IconButton(
                          icon: Icon(
                            user['role'] == 'blocked'
                                ? Icons.check_circle
                                : Icons.block,
                            color: user['role'] == 'blocked'
                                ? AppTheme.successGreen
                                : AppTheme.dangerRed,
                          ),
                          onPressed: () async {
                            final newRole =
                                user['role'] == 'blocked' ? 'user' : 'blocked';
                            try {
                              await Supabase.instance.client
                                  .from('profiles')
                                  .update({'role': newRole}).eq(
                                      'id', user['id']);

                              ref.invalidate(adminUsersProvider);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'User ${newRole.toUpperCase()}')),
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: $e')),
                                );
                              }
                            }
                          },
                          tooltip: user['role'] == 'blocked'
                              ? 'Unblock User'
                              : 'Block User',
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

  void _showKycReviewDialog(
      BuildContext context, WidgetRef ref, Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('KYC Review: ${user['phone']}'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Live Selfie',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    shape: BoxShape.circle,
                  ),
                  child: user['kyc_selfie_url'] != null
                      ? Image.network(user['kyc_selfie_url'], fit: BoxFit.cover)
                      : const Icon(Icons.face, size: 50, color: Colors.grey),
                ),
                const SizedBox(height: 24),
                const Text('CNIC Front',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Container(
                  height: 120,
                  width: 220,
                  color: Colors.grey.shade200,
                  child: user['kyc_cnic_front_url'] != null
                      ? Image.network(user['kyc_cnic_front_url'],
                          fit: BoxFit.cover)
                      : const Icon(Icons.badge, size: 50, color: Colors.grey),
                ),
                const SizedBox(height: 24),
                const Text('CNIC Back',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Container(
                  height: 120,
                  width: 220,
                  color: Colors.grey.shade200,
                  child: user['kyc_cnic_back_url'] != null
                      ? Image.network(user['kyc_cnic_back_url'],
                          fit: BoxFit.cover)
                      : const Icon(Icons.qr_code_2,
                          size: 50, color: Colors.grey),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await Supabase.instance.client
                    .from('profiles')
                    .update({'kyc_status': 'rejected'}).eq('id', user['id']);
                ref.invalidate(adminUsersProvider);
                if (context.mounted) Navigator.pop(context);
              },
              style: TextButton.styleFrom(foregroundColor: AppTheme.dangerRed),
              child: const Text('REJECT'),
            ),
            ElevatedButton(
              onPressed: () async {
                await Supabase.instance.client
                    .from('profiles')
                    .update({'kyc_status': 'verified'}).eq('id', user['id']);
                ref.invalidate(adminUsersProvider);
                if (context.mounted) Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.successGreen,
                  foregroundColor: Colors.white),
              child: const Text('APPROVE'),
            ),
          ],
        );
      },
    );
  }
}
