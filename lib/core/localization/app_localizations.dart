import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppLocalizations {
  final String localeCode;

  AppLocalizations(this.localeCode);

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'app_title': 'DigiKhata Clone',
      'welcome': 'Welcome',
      'login': 'Log In',
      'signup': 'Sign Up',
      'language': 'Language',
      'choose_language': 'Choose Language',
      'home': 'Home',
      'cashbook': 'Cashbook',
      'stock': 'Stock',
      'bills': 'Bills',
      'more': 'More',
      'add_customer': 'Add Customer',
      'add_supplier': 'Add Supplier',
      'party': 'Party',
      'select_language': 'Select your language',
      'lets_get_started': 'Let\'s get started!',
      'enter_mobile': 'Please enter your mobile number',
      'mobile_number': 'Mobile Number',
      'continue_btn': 'Continue',
    },
    'ur': {
      'app_title': 'ڈیجی کھاتا کلون',
      'welcome': 'خوش آمدید',
      'login': 'لاگ ان کریں',
      'signup': 'سائن اپ کریں',
      'language': 'زبان',
      'choose_language': 'زبان منتخب کریں',
      'home': 'ہوم',
      'cashbook': 'کیش بک',
      'stock': 'اسٹاک',
      'bills': 'بل',
      'more': 'مزید',
      'add_customer': 'گاہک شامل کریں',
      'add_supplier': 'سپلائر شامل کریں',
      'party': 'پارٹی',
      'select_language': 'اپنی زبان منتخب کریں',
      'lets_get_started': 'آئیے شروع کریں!',
      'enter_mobile': 'براہ کرم اپنا موبائل نمبر درج کریں',
      'mobile_number': 'موبائل نمبر',
      'continue_btn': 'جاری رکھیں',
    },
  };

  String translate(String key) {
    if (_localizedValues.containsKey(localeCode)) {
      if (_localizedValues[localeCode]!.containsKey(key)) {
        return _localizedValues[localeCode]![key]!;
      }
    }
    // Fallback to English
    return _localizedValues['en']![key] ?? key;
  }
}

class LocaleNotifier extends StateNotifier<String> {
  LocaleNotifier() : super('en');

  void setLocale(String localeCode) {
    state = localeCode;
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, String>((ref) {
  return LocaleNotifier();
});

final l10nProvider = Provider<AppLocalizations>((ref) {
  final locale = ref.watch(localeProvider);
  return AppLocalizations(locale);
});
