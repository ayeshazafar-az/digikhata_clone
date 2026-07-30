import 'package:flutter/material.dart';
import '../../../../app/theme.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/utils/biometric_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () async {
      final session = Supabase.instance.client.auth.currentSession;
      if (session != null) {
        try {
          final profile = await Supabase.instance.client
              .from('profiles')
              .select('role')
              .eq('id', session.user.id)
              .maybeSingle();

          if (profile != null && profile['role'] == 'super_admin') {
            if (mounted) context.go('/admin');
          } else {
            // Require biometrics for normal users to protect their ledger!
            final hasBio = await BiometricService.isBiometricAvailable();
            if (hasBio) {
              final authSuccess = await BiometricService.authenticate();
              if (authSuccess) {
                if (mounted) context.go('/home');
              } else {
                // If failed, arguably we might want a retry button.
                // For simplicity, we fallback to login or retry UI.
                if (mounted) context.go('/language');
              }
            } else {
              if (mounted) context.go('/home');
            }
          }
        } catch (e) {
          if (mounted) context.go('/home');
        }
      } else {
        if (mounted) context.go('/language');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBlue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.account_balance_wallet,
              size: 100,
              color: Colors.white,
            ),
            const SizedBox(height: 20),
            const Text(
              'DigiKhata Clone',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            const CircularProgressIndicator(color: AppTheme.successGreen),
          ],
        ),
      ),
      bottomNavigationBar: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'Powered by Zenvyro Labs',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
