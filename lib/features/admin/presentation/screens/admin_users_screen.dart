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
                    DataCell(Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.block,
                              color: AppTheme.dangerRed),
                          onPressed: () {},
                          tooltip: 'Block User',
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
