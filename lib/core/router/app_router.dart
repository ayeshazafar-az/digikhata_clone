import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/language_selection_screen.dart';
import '../../features/auth/presentation/screens/onboarding_carousel_screen.dart';
import '../../features/auth/presentation/screens/otp_screen.dart';
import '../../features/auth/presentation/screens/pin_setup_screen.dart';
import '../../features/auth/presentation/screens/kyc_onboarding_screen.dart';
import '../../features/ledger/presentation/screens/dashboard_screen.dart';
import '../../features/customers/presentation/screens/customer_ledger_screen.dart';
import '../../features/ledger/presentation/screens/cash_entry_screen.dart';
import '../../features/admin/presentation/screens/admin_dashboard_screen.dart';
import '../../features/admin/presentation/screens/admin_users_screen.dart';
import '../../features/customers/presentation/screens/customer_list_screen.dart';
import '../../features/customers/presentation/screens/add_party_screen.dart';
import '../../features/cashbook/presentation/screens/cashbook_screen.dart';
import '../../features/stock/presentation/screens/stock_book_screen.dart';
import '../../features/billing/presentation/screens/bill_book_screen.dart';
import '../../features/admin/presentation/screens/admin_businesses_screen.dart';
import '../../features/admin/presentation/screens/admin_announcements_screen.dart';
import '../../features/admin/presentation/screens/admin_transactions_screen.dart';
import '../../features/admin/presentation/screens/admin_settings_screen.dart';
import '../../features/ledger/presentation/screens/business_selection_screen.dart';
import '../../features/ledger/presentation/screens/create_business_screen.dart';
import '../../features/ledger/presentation/screens/qr_code_screen.dart';
import '../../features/staff/presentation/screens/staff_book_screen.dart';
import '../../features/expense/presentation/screens/expense_screen.dart';
import '../../features/ledger/presentation/screens/digi_ai_screen.dart';

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
        path: '/language',
        name: 'language',
        builder: (context, state) => const LanguageSelectionScreen(),
      ),
      GoRoute(
        path: '/kyc_onboarding',
        name: 'kyc_onboarding',
        builder: (context, state) => const KycOnboardingScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingCarouselScreen(),
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
        path: '/pin_setup',
        name: 'pin_setup',
        builder: (context, state) {
          final bool hasBusiness = state.extra as bool? ?? false;
          return PinSetupScreen(hasBusiness: hasBusiness);
        },
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/qr_code',
        name: 'qr_code',
        builder: (context, state) => const QrCodeScreen(
          businessName: 'My DigiKhata Business',
          phoneNumber: '+923245423290',
        ),
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
        path: '/admin_users',
        name: 'admin_users',
        builder: (context, state) => const AdminUsersScreen(),
      ),
      GoRoute(
        path: '/admin_announcements',
        name: 'admin_announcements',
        builder: (context, state) => const AdminAnnouncementsScreen(),
      ),
      GoRoute(
        path: '/admin_transactions',
        name: 'admin_transactions',
        builder: (context, state) => const AdminTransactionsScreen(),
      ),
      GoRoute(
        path: '/admin_settings',
        name: 'admin_settings',
        builder: (context, state) => const AdminSettingsScreen(),
      ),
      GoRoute(
        path: '/admin_businesses',
        name: 'admin_businesses',
        builder: (context, state) => const AdminBusinessesScreen(),
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
      GoRoute(
        path: '/staff_book',
        name: 'staff_book',
        builder: (context, state) => const StaffBookScreen(),
      ),
      GoRoute(
        path: '/customer_list',
        name: 'customer_list',
        builder: (context, state) => const CustomerListScreen(),
      ),
      GoRoute(
        path: '/add_party',
        name: 'add_party',
        builder: (context, state) => AddPartyScreen(
            partyType: state.uri.queryParameters['type'] ?? 'customer'),
      ),
      GoRoute(
        path: '/cashbook',
        name: 'cashbook',
        builder: (context, state) => const CashBookScreen(),
      ),
      GoRoute(
        path: '/stock_book',
        name: 'stock_book',
        builder: (context, state) => const StockBookScreen(),
      ),
      GoRoute(
        path: '/bill_book',
        name: 'bill_book',
        builder: (context, state) => const BillBookScreen(),
      ),
      GoRoute(
        path: '/expense',
        name: 'expense',
        builder: (context, state) => const ExpenseScreen(),
      ),
      GoRoute(
        path: '/digi_ai',
        name: 'digi_ai',
        builder: (context, state) => const DigiAiScreen(),
      ),
    ],
  );
}
