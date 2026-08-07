import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../app/theme.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/localization/app_localizations.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _useEmail = true; // Default to email as requested, but allow toggle
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _sendOtp() async {
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();

    if (_useEmail) {
      if (email.isEmpty || !email.contains('@')) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid email address')),
        );
        return;
      }
    } else {
      if (phone.isEmpty || phone.length < 10) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid phone number')),
        );
        return;
      }
    }

    setState(() => _isLoading = true);
    try {
      if (_useEmail) {
        await Supabase.instance.client.auth.signInWithOtp(
          email: email,
          emailRedirectTo:
              kIsWeb ? null : 'io.supabase.digikhata://login-callback',
        );
        if (mounted) context.push('/otp', extra: email);
      } else {
        await Supabase.instance.client.auth.signInWithOtp(
          phone: '+92$phone',
        );
        if (mounted) context.push('/otp', extra: '+92$phone');
      }
    } catch (e) {
      if (mounted) {
        final errorMsg = e.toString().toLowerCase();
        if (errorMsg.contains('rate_limit') ||
            errorMsg.contains('limit') ||
            errorMsg.contains('exceeded')) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'Too many requests sent. Please check your email or try again later.'),
            backgroundColor: AppTheme.warningOrange,
            duration: Duration(seconds: 5),
          ));
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
        }
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.menu_book_rounded,
                        color: AppTheme.primaryBlue, size: 40),
                    const SizedBox(width: 8),
                    const Text(
                      'DigiKhata',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 64),
              Text(
                ref.watch(l10nProvider).translate('lets_get_started'),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                _useEmail
                    ? 'Enter your Email Address'
                    : 'Enter your Mobile Number',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 24),
              if (_useEmail)
                Container(
                  height: 56,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  child: TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(fontSize: 16, letterSpacing: 1.0),
                    decoration: const InputDecoration(
                      hintText: 'user@example.com',
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                    ),
                  ),
                )
              else
                Container(
                  height: 56,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          border: Border(
                              right: BorderSide(color: Colors.grey.shade300)),
                        ),
                        child: const Row(
                          children: [
                            Text('🇵🇰', style: TextStyle(fontSize: 20)),
                            SizedBox(width: 8),
                            Text('+92',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          style:
                              const TextStyle(fontSize: 16, letterSpacing: 1.0),
                          decoration: InputDecoration(
                            hintText: ref
                                .watch(l10nProvider)
                                .translate('mobile_number'),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              const Spacer(),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _sendOtp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryBlue,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                              ref.watch(l10nProvider).translate('continue_btn'),
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward),
                        ],
                      ),
                    ),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _useEmail = !_useEmail;
                    });
                  },
                  child: Text(
                    _useEmail
                        ? 'Login via Phone Number'
                        : 'Login via Magic Link (Email)',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryBlue,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Text(
                    '100% Safe & Secure\nPowered by Zenvyro Labs',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
