import 'package:flutter/material.dart';
import '../../../../../app/theme.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PinLoginScreen extends StatefulWidget {
  const PinLoginScreen({super.key});

  @override
  State<PinLoginScreen> createState() => _PinLoginScreenState();
}

class _PinLoginScreenState extends State<PinLoginScreen> {
  String _pin = '';
  bool _isError = false;

  void _onKeyPress(String value) {
    if (_pin.length < 4) {
      setState(() {
        _pin += value;
        _isError = false; // reset error state
      });

      if (_pin.length == 4) {
        _verifyPin();
      }
    }
  }

  void _onBackspace() {
    if (_pin.isNotEmpty) {
      setState(() {
        _pin = _pin.substring(0, _pin.length - 1);
        _isError = false;
      });
    }
  }

  Future<void> _verifyPin() async {
    final prefs = await SharedPreferences.getInstance();
    final storedPin = prefs.getString('app_pin');

    if (storedPin == _pin) {
      if (mounted) context.go('/home');
    } else {
      setState(() {
        _isError = true;
      });
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            _pin = '';
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                bool isFilled = index < _pin.length;
                return Container(
                  width: 48,
                  height: 48,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: _isError ? Colors.red.shade50 : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                    border:
                        _isError ? Border.all(color: AppTheme.dangerRed) : null,
                  ),
                  child: Center(
                    child: isFilled
                        ? CircleAvatar(
                            radius: 6,
                            backgroundColor:
                                _isError ? AppTheme.dangerRed : Colors.black)
                        : null,
                  ),
                );
              }),
            ),
            // "Forgot Pin" option if needed
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                // To reset PIN, user can clear storage by logging out
                context.go('/language');
              },
              child: const Text('Forgot PIN / Switch Account',
                  style: TextStyle(
                      color: AppTheme.primaryBlue,
                      fontWeight: FontWeight.bold)),
            ),
            const Spacer(),
            _buildCustomKeypad(),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomKeypad() {
    return Column(
      children: [
        _buildKeypadRow(['1', '2', '3']),
        const SizedBox(height: 24),
        _buildKeypadRow(['4', '5', '6']),
        const SizedBox(height: 24),
        _buildKeypadRow(['7', '8', '9']),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(width: 64),
            _buildKeypadButton('0'),
            GestureDetector(
              onTap: _onBackspace,
              child: Container(
                width: 64,
                height: 64,
                alignment: Alignment.center,
                child: const Icon(Icons.backspace_outlined,
                    color: Colors.black87, size: 28),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildKeypadRow(List<String> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: keys.map((key) => _buildKeypadButton(key)).toList(),
    );
  }

  Widget _buildKeypadButton(String key) {
    return GestureDetector(
      onTap: () => _onKeyPress(key),
      child: Container(
        width: 64,
        height: 64,
        alignment: Alignment.center,
        child: Text(
          key,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w500,
            color: AppTheme.dangerRed,
          ),
        ),
      ),
    );
  }
}
