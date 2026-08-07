import 'package:flutter/material.dart';
import '../../../../app/theme.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class RecycleBinScreen extends StatelessWidget {
  const RecycleBinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppTheme.primaryBlue, AppTheme.secondaryBlue],
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
        title: const Text('Recycle Bin',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20)),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white),
            onPressed: () {
              if (context.mounted) {
                showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                            title: const Text('Empty Recycle Bin',
                                style: TextStyle(color: AppTheme.dangerRed)),
                            content: const Text(
                                'Are you sure you want to permanently delete all items in the recycle bin?'),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel')),
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content:
                                                Text('Recycle bin emptied.')));
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: AppTheme.dangerRed),
                                  child: const Text('Empty',
                                      style: TextStyle(color: Colors.white))),
                            ]));
              }
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Orange Header Background Extension
          Container(
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.primaryBlue, AppTheme.secondaryBlue],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),

          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Info Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                      left: 16, right: 80, top: 16, bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2)),
                    ],
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Recycle bin show your deleted data',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'This data will be permanently deleted after the number of days displayed (up to 14 days) or upon logout.',
                        style: TextStyle(
                            fontSize: 13, color: Colors.black87, height: 1.3),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Deleted Item Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 2,
                          offset: const Offset(0, 1)),
                    ],
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat('EEEE, dd MMM yyyy').format(DateTime.now()),
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Ayesha\'s Ledger',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey.shade500)),
                          Text(DateFormat('hh:mm a').format(DateTime.now()),
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey.shade500)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.menu_book,
                                color: AppTheme.secondaryBlue, size: 24),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Business Deleted',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade400)),
                              const SizedBox(height: 2),
                              const Text('Ayesha\'s Ledger',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: () {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Successfully restored business ledger.')));
                            }
                          },
                          icon: const Icon(Icons.undo,
                              color: Color(0xFF991717), size: 16),
                          label: const Text('Undo',
                              style: TextStyle(
                                  color: Color(0xFF991717),
                                  fontWeight: FontWeight.bold)),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Positioned the 3D Recycle Bin Icon perfectly bleeding out of the top right
          Positioned(
            top: 4,
            right: 16,
            child: Container(
              height: 56,
              width: 56,
              decoration: const BoxDecoration(
                color: Color(0xFF1F5F99),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.recycling,
                  color: Colors.greenAccent, size: 36),
            ),
          ),
        ],
      ),
    );
  }
}
