import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app/app.dart';
import 'core/database/local_db.dart';
import 'firebase_options.dart';

void main() async {
  // Ensure Flutter bindings are initialized before calling native code
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Firebase Cloud Messaging platform
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase init error: $e');
  }

  try {
    // Initialize Supabase Backend
    await Supabase.initialize(
      url: 'https://eezvzrepirvvfpxekjob.supabase.co',
      anonKey: 'sb_publishable_nU7ew7U-9DfFAutkJDkavA_kzEK_RwS',
    );
  } catch (e) {
    debugPrint('Supabase init error: $e');
  }

  try {
    // Initialize Local Isar Database
    await LocalDb.init();
  } catch (e) {
    debugPrint('Isar init error: $e');
  }

  // Wrap the app in ProviderScope for Riverpod State Management
  runApp(const ProviderScope(child: MyApp()));
}
