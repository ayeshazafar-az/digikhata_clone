import 'package:flutter/material.dart';
import '../../../../../app/theme.dart';
import 'package:go_router/go_router.dart';

class PinSetupScreen extends StatefulWidget {
  final bool hasBusiness;
  const PinSetupScreen({super.key, this.hasBusiness = false});

  @override
  State<PinSetupScreen> createState() => _PinSetupScreenState();
}

class _PinSetupScreenState extends State<PinSetupScreen> {
  String _pin = '';

  void _onKeyPress(String value) {
    if (_pin.length < 4) {
      setState(() => _pin += value);

      if (_pin.length == 4) {
        // Auto-submit when 4 digits entered
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) {
            if (widget.hasBusiness) {
              context.go('/home');
            } else {
              context.go('/create_business');
            }
          }
        });
      }
    }
  }

  void _onBackspace() {
    if (_pin.isNotEmpty) {
      setState(() => _pin = _pin.substring(0, _pin.length - 1));
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                bool isFilled = index < _pin.length;
                return Container(
                  width: 48,
                  height: 48,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: isFilled
                        ? const CircleAvatar(
                            radius: 6, backgroundColor: Colors.black)
                        : null,
                  ),
                );
              }),
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
            const SizedBox(width: 64), // For alignment with 0
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
            color: AppTheme
                .dangerRed, // In screenshot it's Orange, let's use dangerRed for parity as brand color
          ),
        ),
      ),
    );
  }
}
