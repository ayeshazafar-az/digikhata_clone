import 'package:flutter/material.dart';
import '../../../../app/theme.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  Future<void> _handleLogout() async {
    await Supabase.instance.client.auth.signOut();
    if (mounted) context.go('/language');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 60,
            floating: true,
            pinned: true,
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
                          leading: const Icon(Icons.cloud_done_outlined,
                              color: Color(0xFFE94326)),
                          title: RichText(
                            text: const TextSpan(
                              text: 'Backup ',
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                              children: [
                                TextSpan(
                                    text: '(Successful)',
                                    style:
                                        TextStyle(color: AppTheme.successGreen))
                              ],
                            ),
                          ),
                          trailing: const Icon(Icons.chevron_right,
                              color: Color(0xFFE94326)),
                        ),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFAF7F2),
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
                          context.push('/kyc_onboarding');
                        }),
                        const Divider(height: 1, indent: 50),
                        _buildMenuTile(
                            'Change Login PIN', Icons.vpn_key_outlined, () {}),
                        const Divider(height: 1, indent: 50),
                        _buildMenuTile(
                            'Settings', Icons.settings_outlined, () {}),
                        const Divider(height: 1, indent: 50),
                        _buildMenuTile(
                            'Help & Support', Icons.help_outline, () {}),
                        const Divider(height: 1, indent: 50),
                        _buildMenuTile('About us', Icons.info_outline, () {}),
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
            Icon(icon, color: const Color(0xFFE94326), size: 28),
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
      leading: Icon(icon, color: const Color(0xFFE94326)),
      title: Text(title,
          style: const TextStyle(
              color: Colors.black87,
              fontSize: 15,
              fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right, color: Color(0xFFE94326)),
      onTap: onTap,
    );
  }
}
