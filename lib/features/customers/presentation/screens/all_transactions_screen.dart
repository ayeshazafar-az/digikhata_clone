import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme.dart';

class AllTransactionsScreen extends StatelessWidget {
  final String type; // Passed to know if it's Customer, Supplier, etc.
  const AllTransactionsScreen({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFF3752A), Color(0xFFE94326)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Colors.white, size: 20),
          onPressed: () => context.pop(),
        ),
        title: const Text('All Transactions',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Custom Graphic mimic
            SizedBox(
              width: 150,
              height: 150,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFBE4D8),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const Icon(Icons.assignment,
                      size: 80,
                      color: Color(0xFFDDA656)), // Clipboard looking icon
                  Positioned(
                    top: 20,
                    left: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppTheme.successGreen,
                        shape: BoxShape.circle,
                      ),
                      child:
                          const Icon(Icons.lock, color: Colors.white, size: 14),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.search,
                          color: Colors.black, size: 18),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            Text(
              'Please add a ${type.toLowerCase()} first',
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),

            const SizedBox(height: 64),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    context.push('/add_${type.toLowerCase()}_route');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE94326),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24)),
                  ),
                  child: Text('ADD ${type.toUpperCase()}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
