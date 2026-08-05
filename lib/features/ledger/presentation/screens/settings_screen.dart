import 'package:flutter/material.dart';
import '../../../../app/theme.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

  Future<void> _handleLogout() async {
    await Supabase.instance.client.auth.signOut();
    if (mounted) context.go('/language');
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 60,
            floating: true,
            pinned: true,
            flexibleSpace: Container(
              decoration: BoxDecoration(
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
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.workspace_premium,
                      color: Color(0xFFD4AF37), size: 22),
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 8),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.notifications,
                      color: Color(0xFFD4AF37), size: 22),
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // BACKUP CARD
                  Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      children: [
                        ListTile(
                          onTap: _isBackingUp ? null : _triggerBackup,
                          leading: _isBackingUp
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppTheme.primaryBlue))
                              : const Icon(Icons.cloud_done_outlined,
                                  color: AppTheme.primaryBlue),
                          title: RichText(
                            text: TextSpan(
                              text: _isBackingUp ? 'Backing up... ' : 'Backup ',
                              style: const TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                              children: [
                                if (!_isBackingUp)
                                  const TextSpan(
                                      text: '(Successful)',
                                      style: TextStyle(
                                          color: AppTheme.successGreen))
                              ],
                            ),
                          ),
                          trailing: const Icon(Icons.chevron_right,
                              color: Color(0xFFE94326)),
                        ),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryBlue.withValues(alpha: 0.05),
                            borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12)),
                          ),
                          child: Row(
                            children: [
                              FaIcon(FontAwesomeIcons.googleDrive,
                                  color: Colors.blue.shade600, size: 30),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Text(
                                  "We're excited to offer Google Drive backup! This fantastic feature helps you securely save your data.",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.black54),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // UTILITIES ROW
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildUtilityBox('BUSINESS\nCARD', Icons.badge_outlined,
                          () {
                        context.push('/business_card');
                      }),
                      _buildUtilityBox('RECYCLE\nBIN', Icons.delete_outline,
                          () {
                        context.push('/recycle_bin');
                      }),
                      _buildUtilityBox('MULTI\nDEVICES', Icons.devices, () {
                        context.push('/multi_devices');
                      }),
                      _buildUtilityBox('CALCULATOR', Icons.calculate_outlined,
                          () {
                        context.push('/calculator');
                      }),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // MAIN LIST MENU
                  Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      children: [
                        _buildMenuTile('KYC', Icons.badge_outlined, () {
                          context
                              .push('/kyc_status'); // Changed to new KYC route
                        }),
                        const Divider(height: 1, indent: 50),
                        _buildMenuTile(
                            'Change Login PIN', Icons.vpn_key_outlined, () {
                          context.push('/change_pin');
                        }),
                        const Divider(height: 1, indent: 50),

                        // Expandable Settings
                        Theme(
                          data: Theme.of(context)
                              .copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            leading: const Icon(Icons.settings_outlined,
                                color: AppTheme.primaryBlue),
                            title: const Text('Settings',
                                style: TextStyle(
                                    color: AppTheme.primaryBlue,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500)),
                            iconColor: AppTheme.primaryBlue,
                            collapsedIconColor: AppTheme.primaryBlue,
                            children: [
                              _buildSubTile('Quick entry from notification',
                                  Icons.notifications_active_outlined,
                                  trailing:
                                      Switch(value: false, onChanged: (v) {})),
                              _buildSubTile(
                                  'Dark Mode', Icons.dark_mode_outlined,
                                  trailing: Switch(
                                    value: isDark,
                                    activeColor: AppTheme.primaryBlue,
                                    onChanged: (val) {
                                      if (val != isDark) {
                                        ref
                                            .read(themeModeProvider.notifier)
                                            .toggleTheme();
                                      }
                                    },
                                  )),
                              _buildSubTile('App Lock', Icons.lock_outline),
                              _buildSubTile('Language', Icons.g_translate,
                                  onTap: _showLanguagePicker),
                              _buildSubTile('Business Currency:',
                                  Icons.monetization_on_outlined,
                                  trailingText: '🇵🇰',
                                  onTap: () =>
                                      context.push('/currency_selection')),
                              _buildSubTile(
                                  'Delete Business', Icons.delete_outline,
                                  isDestructive: true,
                                  onTap: () => _showDeleteConfirmation(
                                        context,
                                        'Delete Business',
                                        'Are you sure you want to delete this business and all its data? This action cannot be undone.',
                                        () async {
                                          try {
                                            final supabase =
                                                Supabase.instance.client;
                                            final profile = await supabase
                                                .from('profiles')
                                                .select('active_business_id')
                                                .single();
                                            final bizId =
                                                profile['active_business_id'];
                                            if (bizId != null) {
                                              await supabase
                                                  .from('businesses')
                                                  .delete()
                                                  .eq('id', bizId);
                                              if (mounted) {
                                                context.go('/home');
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                      content: Text(
                                                          'Business deleted')),
                                                );
                                              }
                                            }
                                          } catch (e) {
                                            if (mounted) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content:
                                                          Text('Error: $e')));
                                            }
                                          }
                                        },
                                      )),
                              _buildSubTile('Delete DigiKhata Account',
                                  Icons.delete_outline,
                                  isDestructive: true,
                                  onTap: () => _showDeleteConfirmation(
                                        context,
                                        'Delete Account',
                                        'This will permanently delete your account and all associated data. You will be logged out immediately.',
                                        () async {
                                          try {
                                            await Supabase.instance.client.auth
                                                .signOut();
                                            if (mounted) {
                                              context.go('/language');
                                            }
                                          } catch (e) {
                                            if (mounted) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content:
                                                          Text('Error: $e')));
                                            }
                                          }
                                        },
                                      )),
                            ],
                          ),
                        ),
                        const Divider(height: 1, indent: 50),

                        // Expandable Help & Support
                        Theme(
                          data: Theme.of(context)
                              .copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            leading: const Icon(Icons.help_outline,
                                color: AppTheme.primaryBlue),
                            title: const Text('Help & Support',
                                style: TextStyle(
                                    color: AppTheme.primaryBlue,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500)),
                            iconColor: AppTheme.primaryBlue,
                            collapsedIconColor: AppTheme.primaryBlue,
                            children: [
                              _buildSubTile('FAQs', Icons.help_center_outlined,
                                  onTap: () => context.push('/faqs')),
                              _buildSubTile('Call Us', Icons.call_outlined),
                              _buildSubTile(
                                  'WhatsApp Us', FontAwesomeIcons.whatsapp),
                              _buildSubTile('How to use DigiKhata',
                                  Icons.play_circle_outline),
                            ],
                          ),
                        ),
                        const Divider(height: 1, indent: 50),

                        // Expandable About Us
                        Theme(
                          data: Theme.of(context)
                              .copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            leading: const Icon(Icons.info_outline,
                                color: AppTheme.primaryBlue),
                            title: const Text('About us',
                                style: TextStyle(
                                    color: AppTheme.primaryBlue,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500)),
                            iconColor: AppTheme.primaryBlue,
                            collapsedIconColor: AppTheme.primaryBlue,
                            children: [
                              _buildSubTile('Web Site', Icons.language),
                              _buildSubTile(
                                  'Privacy Policy', Icons.privacy_tip_outlined),
                              _buildSubTile('Terms & Conditions',
                                  Icons.receipt_long_outlined),
                              _buildSubTile(
                                  'Share DigiKhata', Icons.share_outlined),
                            ],
                          ),
                        ),
                        const Divider(height: 1, indent: 50),
                        _buildMenuTile('Logout', Icons.logout, _handleLogout),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // FOOTER
                  const Text('Follow us on',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(FontAwesomeIcons.whatsapp,
                          color: Colors.green.shade600, size: 30),
                      const SizedBox(width: 16),
                      FaIcon(FontAwesomeIcons.facebook,
                          color: Colors.blue.shade700, size: 30),
                      const SizedBox(width: 16),
                      FaIcon(FontAwesomeIcons.youtube,
                          color: Colors.red.shade600, size: 30),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('Version: 9.6.0',
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500)),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildUtilityBox(String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppTheme.primaryBlue, size: 28),
            const SizedBox(height: 8),
            Text(label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87)),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuTile(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryBlue),
      title: Text(title,
          style: const TextStyle(
              color: Colors.black87,
              fontSize: 15,
              fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right, color: AppTheme.primaryBlue),
      onTap: onTap,
    );
  }

  Widget _buildSubTile(String title, dynamic icon,
      {Widget? trailing,
      String? trailingText,
      bool isDestructive = false,
      VoidCallback? onTap}) {
    const defaultColor = AppTheme.primaryBlue;
    final isFaIcon = icon.runtimeType.toString() == 'IconDataBrands' ||
        icon.runtimeType.toString() == 'IconDataSolid' ||
        icon.runtimeType.toString() == 'IconDataRegular';
    final Widget finalIcon = isFaIcon
        ? FaIcon(icon,
            color: isDestructive ? Colors.red.shade600 : defaultColor, size: 20)
        : Icon(icon,
            color: isDestructive ? Colors.red.shade600 : defaultColor,
            size: 20);

    return ListTile(
      contentPadding: const EdgeInsets.only(left: 42, right: 16),
      leading: finalIcon,
      title: Text(title,
          style: TextStyle(
              color: isDestructive ? Colors.black87 : Colors.black87,
              fontSize: 14,
              fontWeight: FontWeight.w400)),
      trailing: trailing ??
          (trailingText != null
              ? Row(mainAxisSize: MainAxisSize.min, children: [
                  Text(trailingText, style: const TextStyle(fontSize: 16)),
                  const SizedBox(width: 8),
                  const Icon(Icons.chevron_right, size: 20, color: Colors.grey)
                ])
              : const Icon(Icons.chevron_right, size: 20, color: Colors.grey)),
      onTap: onTap ?? () {},
    );
  }

  void _showLanguagePicker() {
    final languages = [
      'English',
      'Roman Urdu',
      'اردو',
      'سنڌي',
      'پښتو',
      'فارسی',
      'العربية',
      'বাংলা',
      'हिंदी',
      'Français',
      'Türkçe',
      'Malay'
    ];
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.grey.shade100,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Select your language',
                  style: TextStyle(fontSize: 20, color: Colors.black87)),
              const SizedBox(height: 24),
              Flexible(
                child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: languages.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 2.2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (context, index) {
                    final isSelected = index == 0; // Simulate English selected
                    return GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? AppTheme.primaryBlue
                                : Colors.grey.shade300,
                            width: isSelected ? 1.5 : 1,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          languages[index],
                          style: TextStyle(
                            fontSize: 14,
                            color: isSelected
                                ? Colors.black87
                                : Colors.grey.shade800,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
