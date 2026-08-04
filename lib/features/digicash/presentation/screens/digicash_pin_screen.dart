import 'package:flutter/material.dart';
import '../../../../app/theme.dart';

class DigiCashPinScreen extends StatefulWidget {
  final VoidCallback onSuccess;

  const DigiCashPinScreen({super.key, required this.onSuccess});

  @override
  State<DigiCashPinScreen> createState() => _DigiCashPinScreenState();
}

class _DigiCashPinScreenState extends State<DigiCashPinScreen> {
  String _pin = '';
  final String _correctPin = '1234'; // Stubbed for mockup integrity

  void _onDigitPressed(String digit) {
    if (_pin.length < 4) {
      setState(() {
        _pin += digit;
      });
      if (_pin.length == 4) {
        _verifyPin();
      }
    }
  }

  void _onBackspacePressed() {
    if (_pin.isNotEmpty) {
      setState(() {
        _pin = _pin.substring(0, _pin.length - 1);
      });
    }
  }

  void _verifyPin() {
    if (_pin == _correctPin) {
      widget.onSuccess();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Incorrect PIN. Try 1234.')),
      );
      setState(() {
        _pin = '';
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
            const SizedBox(height: 32),
            // PIN Indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  height: 50,
                  width: 45,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _pin.length == index
                          ? AppTheme.primaryBlue
                          : Colors.grey.shade200,
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: _pin.length > index
                        ? const Icon(Icons.circle,
                            size: 12, color: Colors.black87)
                        : null,
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),
            const Text(
              'Enter DigiKhata PIN',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 12),
            const Text(
              'Forgot PIN?',
              style: TextStyle(
                fontSize: 15,
                color: AppTheme.primaryBlue,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            // Numpad
            _buildNumpad(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildNumpad() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNumpadButton('1'),
              _buildNumpadButton('2'),
              _buildNumpadButton('3'),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNumpadButton('4'),
              _buildNumpadButton('5'),
              _buildNumpadButton('6'),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNumpadButton('7'),
              _buildNumpadButton('8'),
              _buildNumpadButton('9'),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 64), // Empty space
              _buildNumpadButton('0'),
              GestureDetector(
                onTap: _onBackspacePressed,
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
      ),
    );
  }

  Widget _buildNumpadButton(String digit) {
    return GestureDetector(
      onTap: () => _onDigitPressed(digit),
      child: Container(
        width: 64,
        height: 64,
        alignment: Alignment.center,
        child: Text(
          digit,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w400,
            color: AppTheme.primaryBlue,
          ),
        ),
      ),
    );
  }
}
