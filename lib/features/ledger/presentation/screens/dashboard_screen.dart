import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme.dart';
import 'home_grid_screen.dart';
import '../../../customers/presentation/screens/customer_list_screen.dart';
import '../../../cashbook/presentation/screens/cashbook_screen.dart';
import '../../../stock/presentation/screens/stock_book_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const CustomerListScreen(isRoot: true),
    const CashBookScreen(isRoot: true),
    const SizedBox.shrink(), // Center FAB slot
    const StockBookScreen(isRoot: true),
    const HomeGridScreen(isRoot: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Typically opens an entry menu. For now, default to adding a customer
          context.push('/add_customer_route');
        },
        backgroundColor:
            AppTheme.primaryBlue, // Enforced Blue Theme constraints
        shape: const CircleBorder(),
        elevation: 4,
        child:
            const Icon(Icons.add_circle_outline, color: Colors.white, size: 30),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex == 2
            ? 0
            : _currentIndex, // Prevent 2 from being selected
        onTap: (index) {
          if (index == 2) return; // FAB occupies this space logically
          setState(() => _currentIndex = index);
        },
        selectedItemColor: AppTheme.primaryBlue,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            activeIcon: Icon(Icons.menu_book),
            label: 'Cash Book',
          ),
          BottomNavigationBarItem(
            icon: SizedBox(height: 24), // Spacer for FAB
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            activeIcon: Icon(Icons.inventory_2),
            label: 'Stock Book',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view),
            activeIcon: Icon(Icons.grid_view_rounded),
            label: 'More',
          ),
        ],
      ),
    );
  }
}
