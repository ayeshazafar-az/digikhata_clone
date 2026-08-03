import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../app/theme.dart';

class AppDrawerMenu extends StatelessWidget {
  const AppDrawerMenu({super.key});

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.black54,
          fontSize: 12,
          letterSpacing: 2,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
      BuildContext context, IconData icon, String title, VoidCallback onTap,
      {Color? textColor}) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.secondaryOrange),
      title: Text(
        title,
        style: TextStyle(
          color: textColor ?? Colors.black87,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: () {
        Navigator.pop(context); // close drawer first
        onTap();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey.shade50,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Header
          DrawerHeader(
            decoration: const BoxDecoration(color: AppTheme.primaryBlue),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    const Icon(Icons.book, size: 40, color: Colors.white),
                    const SizedBox(width: 12),
                    const Text('DigiKhata',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 8),
                const Text('Version: 9.6.0',
                    style: TextStyle(color: Colors.white70, fontSize: 13)),
              ],
            ),
          ),

          _buildSectionHeader('K H A T A'),
          _buildDrawerItem(
              context, Icons.people, 'Party', () => context.go('/dashboard')),
          _buildDrawerItem(context, Icons.account_balance_wallet, 'Cash',
              () => context.push('/cashbook')),
          _buildDrawerItem(context, Icons.inventory, 'Stock',
              () => context.push('/stock_book')),
          _buildDrawerItem(context, Icons.receipt_long, 'Bills',
              () => context.push('/bill_book')),
          _buildDrawerItem(
              context, Icons.badge, 'Staff', () => context.push('/staff_book')),
          _buildDrawerItem(context, Icons.money_off, 'Expense',
              () => context.push('/expense')),
          _buildDrawerItem(context, Icons.cloud_upload, 'Backup',
              () => context.push('/admin_settings')),
          const Divider(),

          _buildSectionHeader('P A Y M E N T S'),
          _buildDrawerItem(context, Icons.point_of_sale, 'POS',
              () => context.push('/bill_book')),
          _buildDrawerItem(
              context, Icons.qr_code_2, 'QR', () => context.push('/qr_code')),
          _buildDrawerItem(
              context, Icons.verified_user, 'KYC', () => context.push('/kyc')),
          const Divider(),

          _buildSectionHeader('M O R E'),
          _buildDrawerItem(context, Icons.devices, 'Multi Devices',
              () => context.push('/multi_devices')),
          _buildDrawerItem(context, Icons.badge_outlined, 'Business Card',
              () => context.push('/business_card')),
          _buildDrawerItem(context, Icons.calculate, 'Calculator',
              () => context.push('/calculator')),
          _buildDrawerItem(context, Icons.verified_user, 'Tasdeeq',
              () => context.push('/tasdeeq')),
          _buildDrawerItem(context, Icons.local_shipping, 'Distributor',
              () => context.push('/distributor')),
          _buildDrawerItem(context, Icons.delete, 'Recycle Bin',
              () => context.push('/recycle_bin')),

          const Divider(),
          _buildDrawerItem(
            context,
            Icons.logout,
            'Logout',
            () async {
              await Supabase.instance.client.auth.signOut();
              context.go('/login');
            },
            textColor: Colors.red.shade600,
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
