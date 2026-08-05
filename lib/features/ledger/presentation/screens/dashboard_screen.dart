import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme.dart';
import 'home_grid_screen.dart';
import '../../../digicash/presentation/screens/digicash_secure_wrapper.dart';
import 'digi_pos_screen.dart';
import 'digi_bazar_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeGridScreen(),
    const DigiBazarScreen(),
    const DigiPosScreen(),
    const DigiCashSecureWrapper(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/digi_ai');
        },
        backgroundColor: AppTheme
            .primaryBlue, // Enforced Blue Theme constraints! (Original was Orange)
        shape: const CircleBorder(),
        elevation: 6,
        child: const Icon(Icons.auto_awesome,
            color: Colors.white, size: 30), // Sparkles icon!
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        selectedItemColor: AppTheme.primaryBlue,
        unselectedItemColor: Colors.grey.shade400,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            activeIcon: Icon(Icons.menu_book),
            label: 'Khata', // Ledger icon style in SS
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            activeIcon: Icon(Icons.shopping_bag),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Text('DIGI\nPOS',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                    color: _currentIndex == 2
                        ? AppTheme.primaryBlue
                        : Colors.grey.shade400)),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Text('DIGI\nCASH',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                    color: _currentIndex == 3
                        ? AppTheme.primaryBlue
                        : Colors.grey.shade400)),
            label: '',
          ),
        ],
      ),
    );
  }
}
