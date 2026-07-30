import 'package:flutter/material.dart';

class AppTheme {
  // Core Zenvyro Labs Blue Theme Colors
  static const Color primaryBlue = Color(0xFF0A4D68);
  static const Color secondaryBlue = Color(0xFF088395);
  static const Color background = Color(0xFFF6F8FA);
  static const Color successGreen = Color(0xFF00DFA2); // For Cash In
  static const Color dangerRed = Color(0xFFFF0060); // For Cash Out
  static const Color warningOrange = Color(0xFFFF9800); // For Admins

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryBlue,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.light(
        primary: primaryBlue,
        secondary: secondaryBlue,
        surface: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      useMaterial3: true,
    );
  }
}
