import 'package:flutter/material.dart';
import '../../../../app/theme.dart';

class BusinessCardScreen extends StatelessWidget {
  const BusinessCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Business Card'), backgroundColor: AppTheme.primaryBlue, foregroundColor: Colors.white),
      backgroundColor: Colors.grey.shade50,
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(16),
          height: 220,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [AppTheme.primaryBlue, AppTheme.secondaryBlue]),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0,5))]
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.storefront, size: 64, color: Colors.white),
              SizedBox(height: 16),
              Text('My Business Name', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('+92 300 1234567 | business@digikhata.pk', style: TextStyle(color: Colors.white70, fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
}
