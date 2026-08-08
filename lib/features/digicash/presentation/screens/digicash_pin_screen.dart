import 'package:flutter/material.dart';
import '../../../../app/theme.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DigiCashPinScreen extends StatefulWidget {
  final VoidCallback onSuccess;

  const DigiCashPinScreen({super.key, required this.onSuccess});

  @override
  State<DigiCashPinScreen> createState() => _DigiCashPinScreenState();
}

class _DigiCashPinScreenState extends State<DigiCashPinScreen> {
  final TextEditingController _pinController = TextEditingController();
  bool _isError = false;

  Future<void> _verifyPin(String enteredPin) async {
    final prefs = await SharedPreferences.getInstance();
    final storedPin = prefs.getString('app_pin');

    if (storedPin == enteredPin) {
      widget.onSuccess();
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Incorrect PIN. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 60),
              // Lock Icon
              const Icon(
                Icons.lock_outline,
                size: 64,
                color: AppTheme.primaryBlue,
              ),
              const SizedBox(height: 24),
              // Timeout text
              const Text(
                'Your session has timed out.\nTo refresh the session, please enter your\nDigiKhata Login PIN',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 48),
              Text(
                _isError ? "Incorrect PIN" : 'Enter DigiKhata PIN',
                style: TextStyle(
                    fontSize: 16,
                    color: _isError ? AppTheme.dangerRed : Colors.black87,
                    fontWeight: _isError ? FontWeight.bold : FontWeight.normal),
              ),
              const SizedBox(height: 24),
              Pinput(
                controller: _pinController,
                length: 4,
                autofocus: true,
                obscureText: true,
                obscuringWidget: const CircleAvatar(
                    backgroundColor: Colors.black, radius: 8),
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
              const SizedBox(height: 24),
              const Text(
                'Forgot PIN?',
                style: TextStyle(
                  fontSize: 15,
                  color: AppTheme.primaryBlue,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}
