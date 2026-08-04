import 'package:flutter/material.dart';
import 'digicash_pin_screen.dart';
import 'digicash_screen.dart';

class DigiCashSecureWrapper extends StatefulWidget {
  const DigiCashSecureWrapper({super.key});

  @override
  State<DigiCashSecureWrapper> createState() => _DigiCashSecureWrapperState();
}

class _DigiCashSecureWrapperState extends State<DigiCashSecureWrapper> {
  bool _isUnlocked = false;

  void _onPinVerified() {
    setState(() {
      _isUnlocked = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isUnlocked) {
      return const DigiCashScreen();
    } else {
      return DigiCashPinScreen(onSuccess: _onPinVerified);
    }
  }
}
