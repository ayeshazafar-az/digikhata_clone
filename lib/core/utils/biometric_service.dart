import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

import 'package:flutter/foundation.dart';

class BiometricService {
  static final LocalAuthentication _auth = LocalAuthentication();

  static Future<bool> isBiometricAvailable() async {
    if (kIsWeb) return false;

    try {
      final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
      final bool canAuthenticate =
          canAuthenticateWithBiometrics || await _auth.isDeviceSupported();
      return canAuthenticate;
    } on PlatformException {
      return false;
    }
  }

  static Future<bool> authenticate() async {
    if (kIsWeb) return true; // Bypass on Web

    try {
      final bool didAuthenticate = await _auth.authenticate(
        localizedReason: 'Please authenticate to access your DigiKhata Ledger',
      );
      return didAuthenticate;
    } on PlatformException {
      return false;
    }
  }
}
