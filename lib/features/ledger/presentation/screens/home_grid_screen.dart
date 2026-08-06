import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme.dart';
import '../widgets/app_drawer_menu.dart';
import 'dashboard_screen.dart'; // To access dashboardIndexProvider

class HomeGridScreen extends ConsumerWidget {
  final bool isRoot;
  const HomeGridScreen({super.key, this.isRoot = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      drawer: const AppDrawerMenu(),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: isRoot
            ? null
            : Builder(
                builder: (ctx) => IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(ctx).openDrawer(),
                ),
              ),
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.shield_moon, color: AppTheme.primaryBlue, size: 24),
              SizedBox(width: 8),
              Text("DigiKhata",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87)),
              SizedBox(width: 4),
              Icon(Icons.keyboard_arrow_down, size: 20),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.workspace_premium,
                color: AppTheme.primaryBlue),
            onPressed: () {
              if (context.mounted)
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Feature coming soon...')));
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications, color: AppTheme.primaryBlue),
            onPressed: () {
              context.push('/notifications');
            },
          ),
          Builder(
            builder: (ctx) => IconButton(
              icon: const Icon(Icons.grid_view, color: AppTheme.primaryBlue),
              onPressed: () {
                context.push('/settings');
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroBanner(context),
            const SizedBox(height: 24),
            _buildSectionHeader('KHATA',
                actionText: 'View Dashboard',
                onActionTap: () => context.push('/business_dashboard')),
            const SizedBox(height: 16),
            _buildKhataGrid(context),
            const SizedBox(height: 32),
            _buildSectionHeader('PAYMENTS'),
            const SizedBox(height: 16),
            _buildPaymentsGrid(context, ref),
            const SizedBox(height: 32),
            _buildSectionHeader('MORE'),
            const SizedBox(height: 16),
            _buildMoreGrid(context),
            const SizedBox(height: 40),
            Center(
              child: Text(
                'Powered by Zenvyro Labs',
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  letterSpacing: 1.1,
                ),
              ),
            ),
            const SizedBox(height: 80), // Padding for FAB/BottomNav
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/digi_ai');
        },
        backgroundColor:
            AppTheme.primaryBlue, // Forced Blue Theme for strict compliance
        shape: const CircleBorder(),
        child: const Icon(Icons.auto_awesome, color: Colors.white, size: 32),
      ),
    );
  }

  Widget _buildHeroBanner(BuildContext context) {
    final banners = [
      {
        'title': 'Staff Management',
        'subtitle': 'Manage your team & salaries',
        'button': 'Manage Staff',
        'route': '/staff_book',
        'color1': AppTheme.primaryBlue,
        'color2': AppTheme.secondaryBlue,
      },
      {
        'title': 'Track Inventory',
        'subtitle': 'Keep track of all products easily',
        'button': 'View Stock',
        'route': '/stock_book',
        'color1': AppTheme.primaryBlue,
        'color2': Colors.orange.shade800,
      },
      {
        'title': 'Digital Cashbook',
        'subtitle': 'Maintain exact cash drawer balances',
        'button': 'Cashbook',
        'route': '/cashbook',
        'color1': AppTheme.successGreen,
        'color2': Colors.green.shade800,
      },
      {
        'title': 'Professional Invoices',
        'subtitle': 'Generate and share fast PDF bills',
        'button': 'Create Bill',
        'route': '/bill_book',
        'color1': Colors.indigo.shade400,
        'color2': Colors.indigo.shade700,
      },
    ];

    return SizedBox(
      height: 180,
      child: PageView.builder(
        itemCount: banners.length,
        itemBuilder: (context, index) {
          final banner = banners[index];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  banner['color1'] as Color,
                  banner['color2'] as Color,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(banner['title'] as String,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(banner['subtitle'] as String,
                    style:
                        const TextStyle(color: Colors.white70, fontSize: 13)),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton(
                    onPressed: () {
                      context.push(banner['route'] as String);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: banner['color1'] as Color,
                      minimumSize: const Size(120, 36),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    child: Text(banner['button'] as String,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title,
      {String? actionText, VoidCallback? onActionTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade600,
            letterSpacing: 2,
          ),
        ),
        if (actionText != null)
          GestureDetector(
            onTap: onActionTap,
            child: Row(
              children: [
                const Icon(Icons.bar_chart,
                    color: AppTheme.primaryBlue, size: 18),
                const SizedBox(width: 4),
                Text(
                  actionText,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: AppTheme.primaryBlue),
                ),
              ],
            ),
          )
      ],
    );
  }

  Widget _buildKhataGrid(BuildContext context) {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 3,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 0.9,
      children: [
        // Using Navigator.push fallback where context.push depends on deeper nav rules if needed.
        // For now, this is a placeholder UI structure that triggers the tab change via the parent or routes.
        _buildGridItem(
            Icons.person, 'Party', () => context.push('/customer_list')),
        _buildGridItem(Icons.account_balance_wallet, 'Cash',
            () => context.push('/cashbook')),
        _buildGridItem(
            Icons.inventory_2, 'Stock', () => context.push('/stock_book')),
        _buildGridItem(
            Icons.receipt_long, 'Bills', () => context.push('/bill_book')),
        _buildGridItem(Icons.badge, 'Staff', () => context.push('/staff_book')),
        _buildGridItem(
            Icons.payments, 'Expense', () => context.push('/expense')),
      ],
    );
  }

  Widget _buildPaymentsGrid(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: _buildGradientCard(
            Icons.point_of_sale,
            'POS',
            'Accept card\npayments on your\nphone.',
            Colors.indigo.shade400,
            Colors.indigo.shade700,
            onTap: () {
              ref.read(dashboardIndexProvider.notifier).state =
                  2; // DigiPOS index
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildGradientCard(
            Icons.qr_code_2,
            'QR',
            'Share your qr and get\npaid',
            AppTheme.primaryBlue,
            AppTheme.secondaryBlue,
            onTap: () => context.push('/qr_code'),
          ),
        )
      ],
    );
  }

  Widget _buildMoreGrid(BuildContext context) {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 3,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 0.9,
      children: [
        _buildGridItem(Icons.devices, 'Multi Devices',
            () => context.push('/multi_devices')),
        _buildGridItem(Icons.badge_outlined, 'Business Card',
            () => context.push('/business_card')),
        _buildGridItem(
            Icons.calculate, 'Calculator', () => context.push('/calculator')),
        _buildGridItem(
            Icons.verified_user, 'Tasdeeq', () => context.push('/tasdeeq')),
        _buildGridItem(
            Icons.delete, 'Recycle Bin', () => context.push('/recycle_bin')),
        _buildGridItem(Icons.local_shipping, 'Distributor',
            () => context.push('/distributor')),
      ],
    );
  }

  Widget _buildGridItem(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: AppTheme.primaryBlue.withValues(alpha: 0.2), width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: AppTheme.primaryBlue),
            const SizedBox(height: 12),
            Text(label,
                style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: Colors.black87)),
          ],
        ),
      ),
    );
  }

  Widget _buildGradientCard(IconData icon, String title, String subtitle,
      Color colorStart, Color colorEnd,
      {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [colorStart, colorEnd],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: Colors.white, size: 32),
                const Icon(Icons.arrow_forward_ios,
                    color: Colors.white, size: 16),
              ],
            ),
            const SizedBox(height: 24),
            Text(title,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18)),
            const SizedBox(height: 4),
            Text(subtitle,
                style: const TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
