import 'package:flutter/material.dart';
import '../../../../../app/theme.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pinput/pinput.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PinLoginScreen extends StatefulWidget {
  const PinLoginScreen({super.key});

  @override
  State<PinLoginScreen> createState() => _PinLoginScreenState();
}

class _PinLoginScreenState extends State<PinLoginScreen> {
  final TextEditingController _pinController = TextEditingController();
  bool _isError = false;

  Future<void> _verifyPin(String enteredPin) async {
    final prefs = await SharedPreferences.getInstance();
    final storedPin = prefs.getString('app_pin');

    if (storedPin == enteredPin) {
      if (mounted) context.go('/home');
    } else {
      setState(() {
        _isError = true;
      });
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            _isError = false;
            _pinController.clear();
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 32),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.menu_book_rounded,
                      color: AppTheme.primaryBlue, size: 40),
                  const SizedBox(width: 8),
                  const Text(
                    'DigiKhata',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),
            const Text(
              "Welcome Back!",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w900,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _isError
                  ? "Incorrect PIN, try again."
                  : "Please enter your login PIN",
              style: TextStyle(
                fontSize: 16,
                color: _isError ? AppTheme.dangerRed : Colors.black54,
                fontWeight: _isError ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            const SizedBox(height: 32),
            const SizedBox(height: 32),
            Pinput(
              controller: _pinController,
              length: 4,
              autofocus: true,
              obscureText: true,
              obscuringWidget:
                  const CircleAvatar(backgroundColor: Colors.black, radius: 8),
              defaultPinTheme: PinTheme(
                width: 56,
                height: 56,
                textStyle: const TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
                decoration: BoxDecoration(
                  color: _isError ? Colors.red.shade50 : Colors.grey.shade200,
                  border: _isError
                      ? Border.all(color: AppTheme.dangerRed, width: 2)
                      : null,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              focusedPinTheme: PinTheme(
                width: 56,
                height: 56,
                textStyle: const TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  border: Border.all(color: AppTheme.primaryBlue, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onCompleted: _verifyPin,
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('app_pin');
                await Supabase.instance.client.auth.signOut();
                if (context.mounted) context.go('/language');
              },
              child: const Text('Forgot PIN / Switch Account',
                  style: TextStyle(
                      color: AppTheme.primaryBlue,
                      fontWeight: FontWeight.bold)),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
