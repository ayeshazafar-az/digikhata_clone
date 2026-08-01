import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpenseScreen extends ConsumerWidget {
  const ExpenseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFF151515), // Dark mode background
      appBar: AppBar(
        title: const Text('Expense Book',
            style: TextStyle(color: Colors.white, fontSize: 20)),
        backgroundColor: const Color(0xFF151515),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          _buildStatsHeader(),
          Expanded(child: _buildEmptyState()),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Push to add expense
        },
        backgroundColor: const Color(0xFFF05A28), // Orange
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('ADD EXPENSE',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }

  Widget _buildStatsHeader() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF252525),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Expenses (This Month)',
                  style: TextStyle(color: Colors.white70, fontSize: 14)),
              Text('Rs 0.00',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 16),
          LinearProgressIndicator(
            value: 0.0,
            backgroundColor: Color(0xFF151515),
            valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('0 items',
                  style: TextStyle(color: Colors.grey, fontSize: 12)),
              Text('Budget Limit: Not Set',
                  style: TextStyle(color: Colors.green, fontSize: 12)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.payments_outlined, size: 100, color: Colors.grey.shade800),
          const SizedBox(height: 16),
          const Text('No Expenses Yet',
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Tap + to log your daily business expenses.',
              style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
