import 'package:flutter/material.dart';
import '../../../../app/theme.dart';

class MultiDevicesScreen extends StatelessWidget {
  const MultiDevicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Multi Devices'), backgroundColor: AppTheme.primaryBlue, foregroundColor: Colors.white),
      backgroundColor: Colors.grey.shade50,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.qr_code_scanner, size: 100, color: Colors.black87),
            const SizedBox(height: 16),
            const Text('Scan to login on Web', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 8),
            const Text('Go to web.digikhata.pk on your Desktop.', style: TextStyle(color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}
