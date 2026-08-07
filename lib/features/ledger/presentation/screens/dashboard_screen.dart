import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme.dart';
import 'home_grid_screen.dart';
import '../../../digicash/presentation/screens/digicash_secure_wrapper.dart';
import 'digi_pos_screen.dart';
import 'digi_bazar_screen.dart';

final dashboardIndexProvider = StateProvider<int>((ref) => 0);

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(dashboardIndexProvider);

    final List<Widget> pages = [
      const HomeGridScreen(),
      const DigiBazarScreen(),
      const DigiPosScreen(),
      const DigiCashSecureWrapper(),
    ];
    return Scaffold(
      body: pages[currentIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/digi_ai');
        },
        backgroundColor: const Color(0xFFF16522),
        shape: const CircleBorder(),
        elevation: 6,
        child: const Icon(Icons.auto_awesome,
            color: Colors.white, size: 30), // Sparkles icon!
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          ref.read(dashboardIndexProvider.notifier).state = index;
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
                    color: currentIndex == 2
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
                    color: currentIndex == 3
                        ? const Color(0xFFCE2A2A) // Red for Digicash
                        : Colors.grey.shade400)),
            label: '',
          ),
        ],
      ),
    );
  }
}
