import 'package:flutter/material.dart';
import '../../../../app/theme.dart';

class DistributorScreen extends StatelessWidget {
  const DistributorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Become a Distributor'), backgroundColor: AppTheme.primaryBlue, foregroundColor: Colors.white),
      backgroundColor: Colors.grey.shade50,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.local_shipping, size: 80, color: AppTheme.primaryBlue),
            const SizedBox(height: 16),
            const Text('Join the DigiKhata Network', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 16),
            const Text('Become a distributor and earn commissions on POS hardware and premium subscriptions in your area.', textAlign: TextAlign.center, style: TextStyle(color: Colors.black54, fontSize: 16)),
            const SizedBox(height: 32),
            ElevatedButton(
               onPressed: () {},
               style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryBlue, foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 50)),
               child: const Text('Contact Sales Team'),
            )
          ],
        ),
      ),
    );
  }
}
