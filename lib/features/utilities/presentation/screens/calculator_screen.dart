import 'package:flutter/material.dart';
import '../../../../app/theme.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _display = '0';
  
  void _onPress(String text) {
    setState(() {
      if (_display == '0') {
        _display = text;
      } else {
        _display += text;
      }
    });
  }

  void _clear() => setState(() => _display = '0');
  void _calculate() => setState(() => _display = 'Error: Parsing Engine Needed');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calculator'), backgroundColor: AppTheme.primaryBlue, foregroundColor: Colors.white),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(24),
              color: Colors.grey.shade100,
              child: Text(_display, style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.black87)),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              color: Colors.white,
              child: GridView.count(
                crossAxisCount: 4,
                children: [
                  for (var btn in ['7','8','9','/','4','5','6','*','1','2','3','-','C','0','=','+'])
                    InkWell(
                      onTap: () {
                         if (btn == 'C') _clear();
                         else if (btn == '=') _calculate();
                         else _onPress(btn);
                      },
                      child: Center(
                        child: Text(btn, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: btn == '=' || btn == 'C' ? AppTheme.primaryBlue : Colors.black87)),
                      ),
                    )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
