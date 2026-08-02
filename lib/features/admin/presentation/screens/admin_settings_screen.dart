import 'package:flutter/material.dart';
import '../../../../app/theme.dart';

class AdminSettingsScreen extends StatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen> {
  bool _registrationEnabled = true;
  bool _maintenanceMode = false;
  bool _forceAppUpdate = false;

  void _saveSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Platform configuration updated securely.'),
        backgroundColor: AppTheme.successGreen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage App Settings'),
        backgroundColor: Colors.black87,
        actions: [
          IconButton(icon: const Icon(Icons.save), onPressed: _saveSettings)
        ],
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Enable New Registrations'),
            subtitle: const Text('Allow new users to sign up via OTP'),
            value: _registrationEnabled,
            activeThumbColor: AppTheme.primaryBlue,
            onChanged: (val) => setState(() => _registrationEnabled = val),
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Maintenance Mode'),
            subtitle:
                const Text('Lock users out with a maintenance message banner'),
            value: _maintenanceMode,
            activeThumbColor: AppTheme.primaryBlue,
            onChanged: (val) => setState(() => _maintenanceMode = val),
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Force App Update'),
            subtitle: const Text('Trigger minimum version modal on startup'),
            value: _forceAppUpdate,
            activeThumbColor: AppTheme.primaryBlue,
            onChanged: (val) => setState(() => _forceAppUpdate = val),
          ),
          const Divider(),
          ListTile(
            title: const Text('Flush Stale Data Records',
                style: TextStyle(color: AppTheme.dangerRed)),
            subtitle: const Text('Run GC on deleted transaction artifacts'),
            trailing:
                const Icon(Icons.delete_forever, color: AppTheme.dangerRed),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Garbage Collection Triggered')),
              );
            },
          ),
        ],
      ),
    );
  }
}
