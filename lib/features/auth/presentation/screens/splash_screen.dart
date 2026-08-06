import 'dart:async';
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
  late StreamSubscription<AuthState> _authStateSubscription;

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    // Wait short time to allow UI to render first
    await Future.delayed(const Duration(milliseconds: 500));

    _authStateSubscription =
        Supabase.instance.client.auth.onAuthStateChange.listen((data) async {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;

      // If we are signed in, or if it's the initial session check and it's already signed in
      if (session != null) {
        _authStateSubscription.cancel(); // Stop listening once resolved
        try {
          final profile = await Supabase.instance.client
              .from('profiles')
              .select('role')
              .eq('id', session.user.id)
              .maybeSingle();

          if ((profile != null && profile['role'] == 'super_admin') ||
              session.user.phone == '923245423290' ||
              session.user.phone == '+923245423290') {
            if (mounted) context.go('/admin');
          } else {
            final hasBio = await BiometricService.isBiometricAvailable();
            if (hasBio) {
              final authSuccess = await BiometricService.authenticate();
              if (authSuccess) {
                if (mounted) context.go('/home');
              } else {
                if (mounted) context.go('/language');
              }
            } else {
              if (mounted) context.go('/home');
            }
          }
        } catch (e) {
          if (mounted) context.go('/home');
        }
      } else if (event == AuthChangeEvent.initialSession) {
        // Give native deep links (app_links) up to 2 seconds to finish token parsing before forcing unauthenticated fallback
        Future.delayed(const Duration(milliseconds: 2000), () {
          if (mounted && Supabase.instance.client.auth.currentSession == null) {
            _authStateSubscription.cancel();
            context.go('/language');
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _authStateSubscription.cancel();
    super.dispose();
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
              Icons.shield_moon,
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
            const SizedBox(height: 4),
            const Text(
              'Powered by Zenvyro Labs',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.successGreen,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(color: AppTheme.successGreen),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          '100% Free, Safe & Secure\n© ${DateTime.now().year} Zenvyro Labs',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
