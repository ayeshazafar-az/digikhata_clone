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
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _requestPhoneHint();
  }

  Future<void> _requestPhoneHint() async {
    // Only works natively on Android
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      try {
        final hint = await SmsAutoFill().hint;
        if (hint != null && hint.isNotEmpty) {
          // Typically returns full E164 format (+92345678901)
          // We can populate the controller with it
          String cleaned = hint;
          if (cleaned.startsWith('+92')) {
            cleaned = cleaned
                .substring(3); // Remove prefix since UI has +92 hardcoded
          } else if (cleaned.startsWith('0')) {
            cleaned = cleaned.substring(1);
          }
          if (mounted) {
            setState(() {
              _phoneController.text = cleaned;
            });
          }
        }
      } catch (e) {
        debugPrint('Phone hint error: $e');
      }
    }
  }

  Future<void> _sendOtp() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty || phone.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid mobile number')),
      );
      return;
    }

    // Request location permission first to simulate original Digikhata flow.
    final status = await Permission.location.status;
    if (!status.isGranted) {
      await Permission.location.request();
    }

    setState(() => _isLoading = true);

    try {
      // In production you would use Twilio or a similar provider configured in Supabase
      // to send OTP directly to the formatted +92... number.
      await Supabase.instance.client.auth.signInWithOtp(
        phone: '+92$phone',
      );

      if (mounted) {
        context.push('/otp', extra: '+92$phone');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
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
                child: GestureDetector(
                  onLongPress: () {
                    // Hidden Backdoor for Web Testing!
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Admin Bypass Activated!',
                            style: TextStyle(color: Colors.white)),
                        backgroundColor: AppTheme.dangerRed));
                    context.go('/admin');
                  },
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
                ref.watch(l10nProvider).translate('enter_mobile'),
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Container(
                    height: 56,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        const Text('🇵🇰', style: TextStyle(fontSize: 20)),
                        const SizedBox(width: 8),
                        const Text('+92',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
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
                  ),
                ],
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
                          borderRadius: BorderRadius.circular(
                              28), // Fully rounded like screenshot
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
              const SizedBox(height: 24),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Text(
                    '100% Safe & Secure',
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
