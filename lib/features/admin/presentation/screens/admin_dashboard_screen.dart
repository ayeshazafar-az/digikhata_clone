import 'package:flutter/material.dart';
import '../../../../app/theme.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../providers/admin_stats_provider.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(adminStatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Super Admin'),
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.black87),
              child: Text('Admin Portal',
                  style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              onTap: () => context.pop(),
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Manage Users'),
              onTap: () {
                context.pop();
                context.push('/admin_users');
              },
            ),
            ListTile(
              leading: const Icon(Icons.store),
              title: const Text('Manage Businesses'),
              onTap: () {
                context.pop();
                context.push('/admin_businesses');
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Push Notifications & Banners'),
              onTap: () {
                context.pop();
                context.push('/admin_announcements');
              },
            ),
            ListTile(
              leading: const Icon(Icons.receipt_long),
              title: const Text('Global Transactions'),
              onTap: () {
                context.pop();
                context.push('/admin_transactions');
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Platform Settings'),
              onTap: () {
                context.pop();
                context.push('/admin_settings');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: AppTheme.dangerRed),
              title: const Text('Sign Out',
                  style: TextStyle(color: AppTheme.dangerRed)),
              onTap: () async {
                await Supabase.instance.client.auth.signOut();
                if (context.mounted) {
                  context.go('/language');
                }
              },
            ),
          ],
        ),
      ),
      body: statsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error loading stats: $err')),
        data: (stats) {
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Platform Overview',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                        child: _StatCard('Total Users',
                            stats.totalUsers.toString(), Icons.people_outline)),
                    const SizedBox(width: 16),
                    Expanded(
                        child: _StatCard(
                            'Active Businesses',
                            stats.totalBusinesses.toString(),
                            Icons.store_mall_directory)),
                    const SizedBox(width: 16),
                    Expanded(
                        child: _StatCard(
                            'Total Entries',
                            stats.totalLedgerEntries.toString(),
                            Icons.receipt)),
                  ],
                ),
                const SizedBox(height: 48),
                const Text('Quick Actions',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        context.push('/admin_announcements');
                      },
                      icon: const Icon(Icons.campaign),
                      label: const Text('Send Broadcast Notification'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.secondaryBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 16),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.push('/admin_analytics');
                      },
                      icon: const Icon(Icons.analytics_outlined),
                      label: const Text('View Advanced Analytics'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.warningOrange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 16),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _StatCard(this.title, this.value, this.icon);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Icon(icon, size: 48, color: AppTheme.primaryBlue),
            const SizedBox(height: 16),
            Text(value,
                style:
                    const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
