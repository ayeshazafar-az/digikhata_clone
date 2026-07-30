import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/otp_screen.dart';
import '../../features/ledger/presentation/screens/dashboard_screen.dart';
import '../../features/customers/presentation/screens/customer_ledger_screen.dart';
import '../../features/ledger/presentation/screens/cash_entry_screen.dart';
import '../../features/admin/presentation/screens/admin_dashboard_screen.dart';
import '../../features/ledger/presentation/screens/business_selection_screen.dart';
import '../../features/ledger/presentation/screens/create_business_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

class AppRouter {
  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/otp',
        name: 'otp',
        builder: (context, state) {
          final phone = state.extra as String? ?? '';
          return OtpScreen(phoneNumber: phone);
        },
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/customer_ledger',
        name: 'customer_ledger',
        builder: (context, state) {
          final id = state.extra as String? ?? '';
          return CustomerLedgerScreen(customerId: id);
        },
      ),
      GoRoute(
        path: '/cash_entry',
        name: 'cash_entry',
        builder: (context, state) {
          final map = state.extra as Map<String, dynamic>? ?? {};
          return CashEntryScreen(
            customerId: map['customerId'] as String? ?? '',
            entryType: map['type'] as String? ?? 'credit',
          );
        },
      ),
      GoRoute(
        path: '/admin',
        name: 'admin',
        builder: (context, state) => const AdminDashboardScreen(),
      ),
      GoRoute(
        path: '/business',
        name: 'business',
        builder: (context, state) => const BusinessSelectionScreen(),
      ),
      GoRoute(
        path: '/create_business',
        name: 'create_business',
        builder: (context, state) => const CreateBusinessScreen(),
      ),
    ],
  );
}
