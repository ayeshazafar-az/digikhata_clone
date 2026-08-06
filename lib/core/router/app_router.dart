import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/utilities/presentation/screens/calculator_screen.dart';
import '../../features/utilities/presentation/screens/business_card_screen.dart';
import '../../features/utilities/presentation/screens/tasdeeq_screen.dart';
import '../../features/utilities/presentation/screens/distributor_screen.dart';

import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/language_selection_screen.dart';
import '../../features/auth/presentation/screens/onboarding_carousel_screen.dart';
import '../../features/auth/presentation/screens/otp_screen.dart';
import '../../features/auth/presentation/screens/pin_setup_screen.dart';
import '../../features/auth/presentation/screens/kyc_onboarding_screen.dart';
import '../../features/ledger/presentation/screens/dashboard_screen.dart';
import '../../features/ledger/presentation/screens/business_dashboard_screen.dart';
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
import '../../features/ledger/presentation/screens/settings_screen.dart';
import '../../features/admin/presentation/screens/kyc_status_screen.dart';
import '../../features/auth/presentation/screens/change_pin_screen.dart';
import '../../features/ledger/presentation/screens/currency_selection_screen.dart';
import '../../features/ledger/presentation/screens/faqs_screen.dart';
import '../../features/ledger/presentation/screens/multi_devices_screen.dart';
import '../../features/ledger/presentation/screens/recycle_bin_screen.dart';
import '../../features/ledger/presentation/screens/profile_edit_screen.dart';
import '../../features/admin/presentation/screens/admin_analytics_screen.dart';

// Customer specific sub-routes
import '../../features/customers/presentation/screens/add_contact_screen.dart';
import '../../features/customers/presentation/screens/select_bank_screen.dart';
import '../../features/customers/presentation/screens/add_new_bank_screen.dart';
import '../../features/customers/presentation/screens/all_transactions_screen.dart';

import '../../features/ledger/presentation/screens/categories_screen.dart';
import '../../features/ledger/presentation/screens/all_brands_screen.dart';
import '../../features/ledger/presentation/screens/notifications_screen.dart';
import '../../features/ledger/presentation/screens/pro_subscription_screen.dart';
import '../../features/ledger/presentation/screens/backup_restore_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

class AppRouter {
  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
      GoRoute(
          path: '/notifications',
          builder: (context, state) => const NotificationsScreen()),
      GoRoute(
          path: '/pro_subscription',
          builder: (context, state) => const ProSubscriptionScreen()),
      GoRoute(
          path: '/categories',
          builder: (context, state) => const CategoriesScreen()),
      GoRoute(
          path: '/all_brands',
          builder: (context, state) => const AllBrandsScreen()),
      GoRoute(
          path: '/calculator',
          builder: (context, state) => const CalculatorScreen()),
      GoRoute(
          path: '/business_card',
          builder: (context, state) => const BusinessCardScreen()),
      GoRoute(
          path: '/profile_edit',
          builder: (context, state) => const ProfileEditScreen()),
      GoRoute(
          path: '/admin_analytics',
          builder: (context, state) => const AdminAnalyticsScreen()),
      GoRoute(
          path: '/tasdeeq', builder: (context, state) => const TasdeeqScreen()),
      GoRoute(
          path: '/recycle_bin',
          builder: (context, state) => const RecycleBinScreen()),
      GoRoute(
          path: '/multi_devices',
          builder: (context, state) => const MultiDevicesScreen()),
      GoRoute(
          path: '/distributor',
          builder: (context, state) => const DistributorScreen()),
      GoRoute(
          path: '/backup',
          builder: (context, state) => const BackupRestoreScreen()),
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
        path: '/business_dashboard',
        name: 'business_dashboard',
        builder: (context, state) => const BusinessDashboardScreen(),
      ),
      GoRoute(
        path: '/qr_code',
        name: 'qr_code',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return QrCodeScreen(
            businessName: extra['businessName'] ?? 'My Business',
            phoneNumber: extra['phoneNumber'] ?? '',
          );
        },
      ),
      GoRoute(
        path: '/collection',
        name: 'collection',
        builder: (context, state) => const CollectionScreen(),
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
        path: '/select_bank',
        name: 'select_bank',
        builder: (context, state) => const SelectBankScreen(),
      ),
      GoRoute(
        path: '/add_contact',
        name: 'add_contact',
        builder: (context, state) => AddContactScreen(
          type: state.uri.queryParameters['type'] ?? 'customer',
        ),
      ),
      GoRoute(
        path: '/add_customer_route',
        name: 'add_customer_route',
        builder: (context, state) =>
            const AddPartyScreen(partyType: 'customer'),
      ),
      GoRoute(
        path: '/add_new_bank',
        name: 'add_new_bank',
        builder: (context, state) => AddNewBankScreen(
          bankName: state.uri.queryParameters['bankName'],
        ),
      ),
      GoRoute(
        path: '/add_supplier_route',
        name: 'add_supplier_route',
        builder: (context, state) =>
            const AddPartyScreen(partyType: 'supplier'),
      ),
      GoRoute(
        path: '/all_transactions_route',
        name: 'all_transactions_route',
        builder: (context, state) => AllTransactionsScreen(
          type: state.uri.queryParameters['type'] ?? 'all',
        ),
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
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/change_pin',
        name: 'change_pin',
        builder: (context, state) => const ChangePinScreen(),
      ),
      GoRoute(
        path: '/kyc_status',
        name: 'kyc_status',
        builder: (context, state) => const KycStatusScreen(),
      ),
      GoRoute(
        path: '/currency_selection',
        name: 'currency_selection',
        builder: (context, state) => const CurrencySelectionScreen(),
      ),
      GoRoute(
        path: '/faqs',
        name: 'faqs',
        builder: (context, state) => const FaqsScreen(),
      ),
      // Duplicate /multi_devices and /recycle_bin routes removed (defined at top)
      GoRoute(
        path: '/add_customer_route',
        builder: (context, state) => const AddContactScreen(type: 'Customer'),
      ),
      GoRoute(
        path: '/add_supplier_route',
        builder: (context, state) => const AddContactScreen(type: 'Supplier'),
      ),
      GoRoute(
        path: '/select_bank',
        builder: (context, state) => const SelectBankScreen(),
      ),
      GoRoute(
        path: '/add_new_bank',
        builder: (context, state) {
          final uri = Uri.parse(state.uri.toString());
          final bankName = uri.queryParameters['bankName'];
          return AddNewBankScreen(bankName: bankName);
        },
      ),
      GoRoute(
        path: '/all_transactions_route',
        builder: (context, state) {
          final uri = Uri.parse(state.uri.toString());
          final type = uri.queryParameters['type'] ?? 'Customer';
          // Capitalize first letter
          final typeFormatted = type.isNotEmpty
              ? '${type[0].toUpperCase()}${type.substring(1)}'
              : 'Customer';
          return AllTransactionsScreen(type: typeFormatted);
        },
      ),
    ],
  );
}
