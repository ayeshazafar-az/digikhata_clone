import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../app/theme.dart';
import 'package:go_router/go_router.dart';

class QrCodeScreen extends StatelessWidget {
  final String businessName;
  final String phoneNumber;

  const QrCodeScreen(
      {super.key, required this.businessName, required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    // Generate a simple payload string that scanner apps could potentially read
    final qrData =
        'digikhata://pay?business=${Uri.encodeComponent(businessName)}&phone=${Uri.encodeComponent(phoneNumber)}';

    return Scaffold(
      appBar: AppBar(
        title: const Text('My QR Code'),
        leading: BackButton(onPressed: () => context.pop()),
      ),
      backgroundColor: AppTheme.primaryBlue,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: 5,
                  )
                ]),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  businessName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryBlue,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Scan to instantly add to ledger!',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 32),
                QrImageView(
                  data: qrData,
                  version: QrVersions.auto,
                  size: 250.0,
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: () {
                    // Logic to share the QR code image natively
                  },
                  icon: const Icon(Icons.share),
                  label: const Text('Share QR Image'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.successGreen,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
