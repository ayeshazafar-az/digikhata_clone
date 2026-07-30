import 'package:flutter/material.dart';
import '../../../../app/theme.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('More Settings'),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.qr_code_2, color: AppTheme.primaryBlue),
            title: const Text('My QR Code'),
            subtitle: const Text('Share your business QR to receive payments'),
            onTap: () {
              context.push('/qr_code');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.backup, color: AppTheme.primaryBlue),
            title: const Text('Backup & Restore'),
            subtitle: const Text('Sync your local data to the cloud'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Auto-sync is already enabled!')),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: AppTheme.dangerRed),
            title: const Text('Logout',
                style: TextStyle(color: AppTheme.dangerRed)),
            onTap: () async {
              await Supabase.instance.client.auth.signOut();
              if (context.mounted) {
                context.go('/login');
              }
            },
          ),
        ],
      ),
    );
  }
}
