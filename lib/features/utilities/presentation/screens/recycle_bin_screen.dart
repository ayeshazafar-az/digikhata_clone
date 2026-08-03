import 'package:flutter/material.dart';
import '../../../../app/theme.dart';

class RecycleBinScreen extends StatelessWidget {
  const RecycleBinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recycle Bin'), backgroundColor: AppTheme.primaryBlue, foregroundColor: Colors.white),
      backgroundColor: Colors.grey.shade50,
      body: Center(
         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             Icon(Icons.delete_outline, size: 80, color: Colors.grey.shade400),
             const SizedBox(height: 16),
             const Text('Recycle Bin is Empty', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
           ],
         ),
      ),
    );
  }
}
