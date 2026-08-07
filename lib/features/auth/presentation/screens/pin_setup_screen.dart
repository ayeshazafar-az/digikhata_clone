import 'package:flutter/material.dart';
import '../../../../../app/theme.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pinput/pinput.dart';

class PinSetupScreen extends StatefulWidget {
  final bool hasBusiness;
  const PinSetupScreen({super.key, this.hasBusiness = false});

  @override
  State<PinSetupScreen> createState() => _PinSetupScreenState();
}

class _PinSetupScreenState extends State<PinSetupScreen> {
  final TextEditingController _pinController = TextEditingController();

  void _onCompleted(String pinStr) {
    if (mounted) {
      Future.delayed(const Duration(milliseconds: 300), () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('app_pin', pinStr);
        if (mounted) {
          context.go('/home');
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
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppTheme.primaryBlue),
                onPressed: () => context.pop(),
              ),
            ),
            const SizedBox(height: 16),
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
              "Let's set your login PIN",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w900,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Please enter your login PIN",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
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
                  color: Colors.grey.shade200,
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
              onCompleted: _onCompleted,
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
