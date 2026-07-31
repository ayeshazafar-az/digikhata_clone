import 'package:flutter/material.dart';
import '../../../../app/theme.dart';
import '../../../customers/presentation/screens/customer_list_screen.dart';
import 'reports_screen.dart';
import 'settings_screen.dart';
import '../../cashbook/presentation/screens/cashbook_screen.dart';
import '../../stock/presentation/screens/stock_book_screen.dart';
import '../../billing/presentation/screens/bill_book_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const CustomerListScreen(), // Home / Khata
    const CashBookScreen(), // Cashbook (New)
    const StockBookScreen(), // Stock (New)
    const BillBookScreen(), // Bills (New)
    const SettingsScreen(), // More
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: AppTheme.primaryBlue,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed, // Allows more than 3 items
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Cashbook',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2),
            label: 'Stock',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Bills',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: 'More',
          ),
        ],
      ),
    );
  }
}
