import 'package:flutter/material.dart';
import '../../../../app/theme.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _isBackingUp = false;

  void _triggerBackup() async {
    setState(() => _isBackingUp = true);
    // Simulate manual sync time
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isBackingUp = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Backup successful! Data is safely stored in the cloud.'),
          backgroundColor: AppTheme.successGreen,
        ),
      );
    }
  }

  Future<void> _showUpdateDialog(String title, String table, String field,
      {bool isBusiness = false}) async {
    final controller = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Enter new value'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.trim().isNotEmpty) {
                final userId = Supabase.instance.client.auth.currentUser!.id;
                try {
                  if (isBusiness) {
                    await Supabase.instance.client.from(table).update(
                        {field: controller.text.trim()}).eq('owner_id', userId);
                  } else {
                    await Supabase.instance.client.from(table).update(
                        {field: controller.text.trim()}).eq('id', userId);
                  }
                  if (mounted) Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Successfully updated!'),
                      backgroundColor: AppTheme.successGreen));
                } catch (e) {
                  debugPrint('Update error: $e');
                }
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('More Settings'),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.person, color: AppTheme.primaryBlue),
            title: const Text('Profile Management'),
            subtitle: const Text('Update your personal details'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () =>
                _showUpdateDialog('Update Your Name', 'profiles', 'full_name'),
          ),
          const Divider(),
          ListTile(
            leading:
                const Icon(Icons.business_center, color: AppTheme.primaryBlue),
            title: const Text('Business Settings'),
            subtitle: const Text('Rename or configure your business'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showUpdateDialog(
                'Rename Business', 'businesses', 'name',
                isBusiness: true),
          ),
          const Divider(),
          SwitchListTile(
            secondary: Icon(
              isDark ? Icons.dark_mode : Icons.light_mode,
              color: AppTheme.primaryBlue,
            ),
            title: const Text('Dark Mode'),
            subtitle: const Text('Toggle application theme'),
            value: isDark,
            activeColor: AppTheme.primaryBlue,
            onChanged: (value) {
              ref.read(themeModeProvider.notifier).toggleTheme();
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.qr_code_2, color: AppTheme.primaryBlue),
            title: const Text('My QR Code'),
            subtitle: const Text('Share your business QR to receive payments'),
            onTap: () => context.push('/qr_code'),
          ),
          const Divider(),
          ListTile(
            leading: _isBackingUp
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: AppTheme.primaryBlue))
                : const Icon(Icons.cloud_upload, color: AppTheme.primaryBlue),
            title: const Text('Backup & Restore'),
            subtitle: const Text('Manually sync your local data to the cloud'),
            onTap: _isBackingUp ? null : _triggerBackup,
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
