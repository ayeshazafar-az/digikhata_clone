import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme_provider.dart';
import '../../../../app/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
          leading: Icon(icon, color: const Color(0xFFE94326), size: 28),
          title: Text(title,
              style: const TextStyle(fontSize: 16, color: Colors.black87)),
          trailing: const Icon(Icons.chevron_right,
              color: Color(0xFFE94326), size: 24),
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
      backgroundColor: const Color(0xFFF3752A), // Matches gradient start
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFF3752A), Color(0xFFE94326)],
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
                  iconColor: const Color(0xFFE94326),
                  collapsedIconColor: const Color(0xFFE94326),
                  tilePadding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                  leading: const Icon(Icons.settings_outlined,
                      color: Color(0xFFE94326), size: 28),
                  title: const Text('Settings',
                      style: TextStyle(fontSize: 16, color: Color(0xFFE94326))),
                  initiallyExpanded: true,
                  children: [
                    _buildSubTile(
                      leading: const Icon(Icons.notifications_active_outlined,
                          color: Color(0xFFE94326), size: 20),
                      title: 'Quick entry from notification',
                      trailing: Switch(
                        value: _quickEntryEnabled,
                        onChanged: (val) =>
                            setState(() => _quickEntryEnabled = val),
                        activeColor: const Color(0xFFE94326),
                      ),
                    ),
                    _buildSubTile(
                      leading: const Icon(Icons.dark_mode_outlined,
                          color: Color(0xFFE94326), size: 20),
                      title: 'Dark Mode',
                      trailing: Switch(
                        value: isDarkMode,
                        onChanged: (val) {
                          ref
                              .read(themeModeProvider.notifier)
                              .setTheme(val ? ThemeMode.dark : ThemeMode.light);
                        },
                        activeColor: const Color(0xFFE94326),
                      ),
                    ),
                    _buildSubTile(
                      leading: const Icon(Icons.lock_outline,
                          color: Color(0xFFE94326), size: 20),
                      title: 'App Lock',
                      onTap: () {},
                    ),
                    _buildSubTile(
                      leading: const Icon(Icons.g_translate_outlined,
                          color: Color(0xFFE94326), size: 20),
                      title: 'Language',
                      onTap: () => context.push('/language'),
                    ),
                    _buildSubTile(
                      leading: const Icon(Icons.currency_rupee,
                          color: Color(0xFFE94326), size: 20),
                      title: 'Business Currency:',
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 24,
                            height: 16,
                            color: Colors.green.shade700,
                            child: const Center(
                                child: Icon(Icons.star,
                                    color: Colors.white, size: 8)), // Fake flag
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.chevron_right,
                              color: Colors.black26, size: 20),
                        ],
                      ),
                      onTap: () {},
                    ),
                    _buildSubTile(
                      leading: const Icon(Icons.delete_outline,
                          color: Color(0xFFE94326), size: 20),
                      title: 'Delete Business',
                      onTap: () {},
                    ),
                    _buildSubTile(
                      leading: const Icon(Icons.delete_outline,
                          color: Color(0xFFE94326), size: 20),
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
