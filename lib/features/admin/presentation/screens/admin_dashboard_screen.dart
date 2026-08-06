import 'package:flutter/material.dart';
import 'dart:ui';
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
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppTheme.primaryBlue, AppTheme.secondaryBlue],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        title: const Text('Super Admin',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.primaryBlue, AppTheme.secondaryBlue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
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
                        child: _StatCard(
                            'Total\nUsers',
                            stats.totalUsers.toString(),
                            Icons.people_outline,
                            Colors.blue.shade50,
                            Colors.blue.shade700)),
                    const SizedBox(width: 12),
                    Expanded(
                        child: _StatCard(
                            'Active\nShops',
                            stats.totalBusinesses.toString(),
                            Icons.store_mall_directory,
                            Colors.orange.shade50,
                            Colors.orange.shade700)),
                    const SizedBox(width: 12),
                    Expanded(
                        child: _StatCard(
                            'Total\nEntries',
                            stats.totalLedgerEntries.toString(),
                            Icons.receipt_long,
                            Colors.green.shade50,
                            Colors.green.shade700)),
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
  final Color bg;
  final Color iconColor;

  const _StatCard(this.title, this.value, this.icon, this.bg, this.iconColor);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: iconColor.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            color: bg.withValues(alpha: 0.7),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 32, color: iconColor),
                const SizedBox(height: 12),
                Text(
                  value,
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: iconColor),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: iconColor.withValues(alpha: 0.8),
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
