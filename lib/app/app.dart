import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // Intrinsic
import '../core/router/app_router.dart';
import 'theme.dart';
import 'theme_provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      final prefs = await SharedPreferences.getInstance();
      final isLocked = prefs.getBool('app_lock_enabled') ?? false;

      // Basic check to see if we are not already on the pin screen
      final currentRoute =
          AppRouter.router.routerDelegate.currentConfiguration.uri.toString();
      if (isLocked &&
          currentRoute != '/pin' &&
          currentRoute != '/change_pin' &&
          currentRoute != '/' &&
          currentRoute != '/login' &&
          currentRoute != '/language') {
        AppRouter.router.push('/pin');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'DigiKhata Clone',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('ur', ''), // Urdu Support Enabled natively!
      ],
      routerConfig: AppRouter.router,
    );
  }
}
