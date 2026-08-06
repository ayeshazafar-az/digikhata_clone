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
  try {
    final res = await supabase
        .from('profiles')
        .select()
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(res);
  } catch (e) {
    if (e.toString().contains('RLS') ||
        e.toString().contains('row-level security')) {
      throw Exception(
          'Supabase RLS Policy violation: Please run the supabase_admin_rls_policies.sql script to grant super_admin privileges.');
    }
    rethrow;
  }
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

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              final dateStr = DateFormat('dd MMM yyyy')
                  .format(DateTime.parse(user['created_at']));
              final isVerified = user['kyc_status'] == 'verified';
              final isBlocked = user['role'] == 'blocked';

              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: isBlocked
                                    ? AppTheme.dangerRed.withValues(alpha: 0.1)
                                    : AppTheme.primaryBlue
                                        .withValues(alpha: 0.1),
                                child: Icon(
                                  isBlocked
                                      ? Icons.block
                                      : Icons.person_outline,
                                  color: isBlocked
                                      ? AppTheme.dangerRed
                                      : AppTheme.primaryBlue,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user['phone'] ?? 'Unknown User',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  Text(
                                      'ID: ${user['id'].toString().substring(0, 8)}',
                                      style: const TextStyle(
                                          color: Colors.grey, fontSize: 12)),
                                ],
                              ),
                            ],
                          ),
                          Chip(
                            label: Text(
                              (user['kyc_status'] ?? 'pending').toUpperCase(),
                              style: const TextStyle(
                                  fontSize: 10, color: Colors.white),
                            ),
                            backgroundColor: isVerified
                                ? AppTheme.successGreen
                                : (user['kyc_status'] == 'rejected'
                                    ? AppTheme.dangerRed
                                    : AppTheme.warningOrange),
                            visualDensity: VisualDensity.compact,
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Joined: $dateStr',
                              style: const TextStyle(color: Colors.black54)),
                          Row(
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
                              OutlinedButton.icon(
                                icon: Icon(
                                  isBlocked ? Icons.check_circle : Icons.block,
                                  size: 16,
                                  color: isBlocked
                                      ? AppTheme.successGreen
                                      : AppTheme.dangerRed,
                                ),
                                label: Text(
                                  isBlocked ? 'Unblock' : 'Suspend',
                                  style: TextStyle(
                                      color: isBlocked
                                          ? AppTheme.successGreen
                                          : AppTheme.dangerRed),
                                ),
                                onPressed: () async {
                                  final newRole =
                                      isBlocked ? 'user' : 'blocked';
                                  try {
                                    await Supabase.instance.client
                                        .from('profiles')
                                        .update({'role': newRole}).eq(
                                            'id', user['id']);
                                    ref.invalidate(adminUsersProvider);
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'User ${newRole.toUpperCase()} successfully')),
                                      );
                                    }
                                  } catch (e) {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(content: Text('Error: $e')),
                                      );
                                    }
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
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
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.verified_user,
                          color: AppTheme.primaryBlue, size: 28),
                      const SizedBox(width: 8),
                      Text(
                        'KYC Request',
                        style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryBlue),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    user['phone'] ?? 'Unknown Number',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                  ),
                  const Divider(height: 32),
                  const Text('Live Selfie Verification',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),
                  Container(
                    height: 140,
                    width: 140,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        shape: BoxShape.circle,
                        border:
                            Border.all(color: AppTheme.secondaryBlue, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color:
                                AppTheme.secondaryBlue.withValues(alpha: 0.2),
                            blurRadius: 10,
                            spreadRadius: 2,
                          )
                        ]),
                    child: user['kyc_selfie_url'] != null
                        ? ClipOval(
                            child: Image.network(user['kyc_selfie_url'],
                                fit: BoxFit.cover))
                        : const Icon(Icons.face, size: 50, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  const Text('CNIC Front',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),
                  Container(
                    height: 140,
                    width: 240,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300, width: 2),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: user['kyc_cnic_front_url'] != null
                        ? Image.network(user['kyc_cnic_front_url'],
                            fit: BoxFit.cover)
                        : const Icon(Icons.badge, size: 50, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  const Text('CNIC Back',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),
                  Container(
                    height: 140,
                    width: 240,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300, width: 2),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: user['kyc_cnic_back_url'] != null
                        ? Image.network(user['kyc_cnic_back_url'],
                            fit: BoxFit.cover)
                        : const Icon(Icons.qr_code_2,
                            size: 50, color: Colors.grey),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppTheme.dangerRed,
                            side: const BorderSide(color: AppTheme.dangerRed),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12))),
                        onPressed: () async {
                          await Supabase.instance.client
                              .from('profiles')
                              .update({'kyc_status': 'rejected'}).eq(
                                  'id', user['id']);
                          ref.invalidate(adminUsersProvider);
                          if (context.mounted) Navigator.pop(context);
                        },
                        icon: const Icon(Icons.close),
                        label: const Text('Reject KYC',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.successGreen,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12))),
                        onPressed: () async {
                          await Supabase.instance.client
                              .from('profiles')
                              .update({'kyc_status': 'verified'}).eq(
                                  'id', user['id']);
                          ref.invalidate(adminUsersProvider);
                          if (context.mounted) Navigator.pop(context);
                        },
                        icon: const Icon(Icons.check),
                        label: const Text('Approve KYC',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
