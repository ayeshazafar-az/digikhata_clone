import 'package:flutter/material.dart';
import '../../../../app/theme.dart';
import 'home_grid_screen.dart';
import 'settings_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeGridScreen(),
    const Center(child: Text('Shopping Coming Soon')),
    const Center(child: Text('DIGI POS Coming Soon')),
    const Center(child: Text('DIGI CASH Coming Soon')),
    const SettingsScreen(), // Used for the empty 5th slot behind FAB
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _currentIndex = 4; // Assuming FAB triggers the More/Settings panel
          });
        },
        backgroundColor: AppTheme.dangerRed,
        child: const Icon(Icons.auto_awesome, color: Colors.white, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex > 3
            ? 0
            : _currentIndex, // 4 doesn't exist in items list
        onTap: (index) {
          if (index == 4) return;
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
            icon: Icon(Icons.menu_book),
            label: 'Khata',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.point_of_sale),
            label: 'DIGI POS',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            label: 'DIGI CASH',
          ),
          BottomNavigationBarItem(
            icon: SizedBox.shrink(),
            label: '',
          ),
        ],
      ),
    );
  }
}
