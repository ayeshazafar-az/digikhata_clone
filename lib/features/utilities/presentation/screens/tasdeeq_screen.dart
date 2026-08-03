import 'package:flutter/material.dart';
import '../../../../app/theme.dart';

class TasdeeqScreen extends StatelessWidget {
  const TasdeeqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tasdeeq Verification'), backgroundColor: AppTheme.primaryBlue, foregroundColor: Colors.white),
      backgroundColor: Colors.grey.shade50,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.verified_user, size: 64, color: AppTheme.successGreen),
            const SizedBox(height: 16),
            const Text('Verify your customers reliably using Tasdeeq.', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.black87)),
            const SizedBox(height: 32),
            TextField(
               decoration: InputDecoration(
                  labelText: 'Enter CNIC',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
               ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
               onPressed: () {},
               style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryBlue, foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 50)),
               child: const Text('Verify Now'),
            )
          ],
        ),
      ),
    );
  }
}
