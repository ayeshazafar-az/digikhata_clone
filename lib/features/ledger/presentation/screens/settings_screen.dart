import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme_provider.dart';
import '../../../../app/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final currencyProvider = StateProvider<String>((ref) => 'PKR');

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _quickEntryEnabled = false;

  Widget _buildTopLevelTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
          leading: Icon(icon, color: AppTheme.primaryBlue, size: 28),
          title: Text(title,
              style: const TextStyle(fontSize: 16, color: Colors.black87)),
          trailing: const Icon(Icons.chevron_right,
              color: Color(0xFF60A5FA), size: 24),
          onTap: onTap,
        ),
        const Divider(
            height: 1, indent: 24, endIndent: 24, color: Colors.black12),
      ],
    );
  }

  Widget _buildSubTile({
    required Widget leading,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 64, right: 24),
      leading: leading,
      title: Text(title,
          style: const TextStyle(fontSize: 15, color: Colors.black87)),
      trailing: trailing ??
          const Icon(Icons.chevron_right, color: Colors.black26, size: 20),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final isDarkMode = themeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: AppTheme.primaryBlue, // Matches gradient start
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Colors.white, size: 20),
          onPressed: () => context.pop(),
        ),
        title: const Text('More',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20)),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
                color: Colors.white, shape: BoxShape.circle),
            child: const Icon(Icons.workspace_premium,
                color: Color(0xFFD4AF37), size: 20),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
                color: Colors.white, shape: BoxShape.circle),
            child: const Icon(Icons.notifications,
                color: Color(0xFFD4AF37), size: 20),
          ),
          const SizedBox(width: 8)
        ],
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 8, left: 16, right: 16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          child: ListView(
            padding: const EdgeInsets.only(top: 8, bottom: 40),
            children: [
              _buildTopLevelTile(
                icon: Icons.assignment_ind_outlined,
                title: 'KYC',
                onTap: () => context.push('/kyc_status'),
              ),
              _buildTopLevelTile(
                icon: Icons.vpn_key_outlined,
                title: 'Change Login PIN',
                onTap: () => context.push('/change_pin'),
              ),
              Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  iconColor: AppTheme.primaryBlue,
                  collapsedIconColor: AppTheme.primaryBlue,
                  tilePadding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                  leading: const Icon(Icons.settings_outlined,
                      color: Color(0xFF60A5FA), size: 28),
                  title: const Text('Settings',
                      style: TextStyle(fontSize: 16, color: Color(0xFF60A5FA))),
                  initiallyExpanded: true,
                  children: [
                    _buildSubTile(
                      leading: const Icon(Icons.notifications_active_outlined,
                          color: Color(0xFF60A5FA), size: 20),
                      title: 'Quick entry from notification',
                      trailing: Switch(
                        value: _quickEntryEnabled,
                        onChanged: (val) =>
                            setState(() => _quickEntryEnabled = val),
                        activeColor: AppTheme.primaryBlue,
                      ),
                    ),
                    _buildSubTile(
                      leading: const Icon(Icons.dark_mode_outlined,
                          color: Color(0xFF60A5FA), size: 20),
                      title: 'Dark Mode',
                      trailing: Switch(
                        value: isDarkMode,
                        onChanged: (val) {
                          ref
                              .read(themeModeProvider.notifier)
                              .setTheme(val ? ThemeMode.dark : ThemeMode.light);
                        },
                        activeColor: AppTheme.primaryBlue,
                      ),
                    ),
                    _buildSubTile(
                      leading: const Icon(Icons.lock_outline,
                          color: Color(0xFF60A5FA), size: 20),
                      title: 'App Lock',
                      onTap: () {},
                    ),
                    _buildSubTile(
                      leading: const Icon(Icons.g_translate_outlined,
                          color: Color(0xFF60A5FA), size: 20),
                      title: 'Language',
                      onTap: () => context.push('/language'),
                    ),
                    _buildSubTile(
                      leading: const Icon(Icons.monetization_on_outlined,
                          color: Color(0xFF60A5FA), size: 20),
                      title: 'Business Currency:',
                      trailing: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: ref.watch(currencyProvider),
                          icon: const Icon(Icons.keyboard_arrow_down,
                              color: Colors.black26),
                          style: const TextStyle(
                              color: Colors.black87, fontSize: 14),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              ref.read(currencyProvider.notifier).state =
                                  newValue;
                            }
                          },
                          items: <String>['PKR', 'USD', 'EUR', 'GBP', 'INR']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                            );
                          }).toList(),
                        ),
                      ),
                      onTap: () {},
                    ),
                    _buildSubTile(
                      leading: const Icon(Icons.delete_outline,
                          color: Color(0xFF60A5FA), size: 20),
                      title: 'Delete Business',
                      onTap: () {},
                    ),
                    _buildSubTile(
                      leading: const Icon(Icons.delete_outline,
                          color: Color(0xFF60A5FA), size: 20),
                      title: 'Delete DigiKhata Account',
                      onTap: () async {
                        await Supabase.instance.client.auth.signOut();
                        if (mounted) context.go('/language');
                      },
                    ),
                  ],
                ),
              ),
              const Divider(
                  height: 1, indent: 24, endIndent: 24, color: Colors.black12),
              _buildTopLevelTile(
                icon: Icons.help_outline,
                title: 'Help & Support',
                onTap: () => context.push('/faqs'),
              ),
              _buildTopLevelTile(
                icon: Icons.info_outline,
                title: 'About us',
                onTap: () {},
              )
            ],
          ),
        ),
      ),
    );
  }
}
