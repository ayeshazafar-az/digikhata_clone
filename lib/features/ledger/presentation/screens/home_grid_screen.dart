import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme.dart';

class HomeGridScreen extends StatelessWidget {
  const HomeGridScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: const Icon(Icons.menu),
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
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications, color: AppTheme.primaryBlue),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.apps, color: AppTheme.primaryBlue),
            onPressed: () {},
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
            _buildSectionHeader('KHATA', actionText: 'View Dashboard'),
            const SizedBox(height: 16),
            _buildKhataGrid(context),
            const SizedBox(height: 32),
            _buildSectionHeader('PAYMENTS'),
            const SizedBox(height: 16),
            _buildPaymentsGrid(context),
            const SizedBox(height: 32),
            _buildSectionHeader('MORE'),
            const SizedBox(height: 16),
            _buildMoreGrid(context),
            const SizedBox(height: 80), // Padding for FAB/BottomNav
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/digi_ai');
        },
        backgroundColor: Colors.deepOrange,
        shape: const CircleBorder(),
        child: const Icon(Icons.auto_awesome, color: Colors.white, size: 32),
      ),
    );
  }

  Widget _buildHeroBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.primaryBlue,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryBlue.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.inventory_2, color: Colors.white, size: 40),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Keep track of inventory and stock updates.',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.push('/home'); // Will trigger stock soon
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppTheme.primaryBlue,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Stock Book',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 4),
                Icon(Icons.arrow_forward, size: 16),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, {String? actionText}) {
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
          Row(
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

  Widget _buildPaymentsGrid(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildGradientCard(
            Icons.point_of_sale,
            'POS',
            'Accept card payments on your phone.',
            AppTheme.primaryBlue,
            const Color(0xFF003399),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildGradientCard(
            Icons.qr_code_2,
            'QR',
            'Share your qr and get paid',
            AppTheme.dangerRed,
            Colors.redAccent.shade400,
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
        _buildGridItem(Icons.devices, 'Multi Devices', () {}),
        _buildGridItem(Icons.badge_outlined, 'Business Card', () {}),
        _buildGridItem(Icons.calculate, 'Calculator', () {}),
        _buildGridItem(Icons.verified_user, 'Tasdeeq', () {}),
        _buildGridItem(Icons.delete, 'Recycle Bin', () {}),
        _buildGridItem(Icons.local_shipping, 'Distributor', () {}),
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
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 5,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: AppTheme.primaryBlue),
            const SizedBox(height: 12),
            Text(label,
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
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
