import 'package:flutter/material.dart';
import '../../../../app/theme.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _display = '0';
  String _operand1 = '';
  String _operand2 = '';
  String _operator = '';
  bool _isNewInput = true;

  void _onPress(String text) {
    setState(() {
      if (_display == 'Error') {
        _display = '0';
        _isNewInput = true;
      }

      if (_isNewInput) {
        _display = text;
        _isNewInput = false;
      } else {
        if (text == '.' && _display.contains('.')) return;
        _display += text;
      }
    });
  }

  void _onOperator(String op) {
    setState(() {
      if (_operator.isNotEmpty && !_isNewInput) {
        _calculate();
      }
      _operand1 = _display;
      _operator = op;
      _isNewInput = true;
    });
  }

  void _calculate() {
    setState(() {
      _operand2 = _display;
      if (_operand1.isEmpty || _operator.isEmpty) return;

      double num1 = double.tryParse(_operand1) ?? 0;
      double num2 = double.tryParse(_operand2) ?? 0;
      double result = 0;

      switch (_operator) {
        case '+':
          result = num1 + num2;
          break;
        case '-':
          result = num1 - num2;
          break;
        case 'x':
          result = num1 * num2;
          break;
        case '÷':
          result = num2 == 0 ? double.nan : num1 / num2;
          break;
        case '%':
          result = num1 % num2;
          break;
      }

      if (result.isNaN) {
        _display = 'Error';
      } else {
        _display =
            result.toStringAsFixed(result.truncateToDouble() == result ? 0 : 2);
      }

      _operand1 = _display;
      _operator = '';
      _isNewInput = true; // wait for next sequence
    });
  }

  void _clear() {
    setState(() {
      _display = '0';
      _operand1 = '';
      _operand2 = '';
      _operator = '';
      _isNewInput = true;
    });
  }

  void _onBackspace() {
    setState(() {
      if (_isNewInput || _display == 'Error' || _display.length == 1) {
        _display = '0';
        _isNewInput = true;
      } else {
        _display = _display.substring(0, _display.length - 1);
      }
    });
  }

  Widget _buildKey(String label,
      {int flex = 1, VoidCallback? onTap, bool isPrimary = false}) {
    return Expanded(
      flex: flex,
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isPrimary ? AppTheme.primaryBlue : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: isPrimary
              ? null
              : Border.all(color: Colors.grey.shade300, width: 1),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12, blurRadius: 2, offset: Offset(0, 2))
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Center(
              child: label == 'BS'
                  ? Icon(Icons.backspace_outlined,
                      color: isPrimary ? Colors.white : Colors.black87)
                  : Text(label,
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: isPrimary ? Colors.white : Colors.black87)),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Calculator',
            style: TextStyle(color: Colors.white, fontSize: 20)),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Display Area
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(32),
              width: double.infinity,
              color: Colors.grey.shade100,
              child: Text(
                _display,
                style: const TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          // Keypad Area
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  // Column 1
                  Expanded(
                    child: Column(
                      children: [
                        _buildKey('AC',
                            flex: 2, onTap: _clear, isPrimary: true),
                        _buildKey('7', onTap: () => _onPress('7')),
                        _buildKey('4', onTap: () => _onPress('4')),
                        _buildKey('1', onTap: () => _onPress('1')),
                        _buildKey('0', onTap: () => _onPress('0')),
                      ],
                    ),
                  ),
                  // Column 2
                  Expanded(
                    child: Column(
                      children: [
                        _buildKey('%', onTap: () => _onOperator('%')),
                        _buildKey('x', onTap: () => _onOperator('x')),
                        _buildKey('8', onTap: () => _onPress('8')),
                        _buildKey('5', onTap: () => _onPress('5')),
                        _buildKey('2', onTap: () => _onPress('2')),
                        _buildKey('00', onTap: () => _onPress('00')),
                      ],
                    ),
                  ),
                  // Column 3
                  Expanded(
                    child: Column(
                      children: [
                        _buildKey('÷', onTap: () => _onOperator('÷')),
                        _buildKey('-', onTap: () => _onOperator('-')),
                        _buildKey('9', onTap: () => _onPress('9')),
                        _buildKey('6', onTap: () => _onPress('6')),
                        _buildKey('3', onTap: () => _onPress('3')),
                        _buildKey('.', onTap: () => _onPress('.')),
                      ],
                    ),
                  ),
                  // Column 4
                  Expanded(
                    child: Column(
                      children: [
                        _buildKey('BS', flex: 2, onTap: _onBackspace),
                        _buildKey('+', flex: 2, onTap: () => _onOperator('+')),
                        _buildKey('=',
                            flex: 2, onTap: _calculate, isPrimary: true),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
