import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final authClientProvider = Provider<GoTrueClient>((ref) {
  return Supabase.instance.client.auth;
});

final authStateProvider = StreamProvider<AuthState>((ref) {
  return ref.watch(authClientProvider).onAuthStateChange;
});

class AuthNotifier extends StateNotifier<AsyncValue<void>> {
  final GoTrueClient _auth;

  AuthNotifier(this._auth) : super(const AsyncValue.data(null));

  Future<void> signInWithPhone(String phone) async {
    state = const AsyncValue.loading();
    try {
      await _auth.signInWithOtp(phone: phone);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> verifyOtp(String phone, String otp) async {
    state = const AsyncValue.loading();
    try {
      await _auth.verifyOTP(type: OtpType.sms, token: otp, phone: phone);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<void>>((ref) {
  return AuthNotifier(ref.watch(authClientProvider));
});
