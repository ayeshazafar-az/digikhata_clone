import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app/app.dart';
import 'core/database/local_db.dart';

void main() async {
  // Ensure Flutter bindings are initialized before calling native code
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase Backend
  await Supabase.initialize(
    url: 'https://eezvzrepirvvfpxekjob.supabase.co',
    anonKey: 'sb_publishable_nU7ew7U-9DfFAutkJDkavA_kzEK_RwS',
  );

  // Initialize Local Isar Database
  await LocalDb.init();

  // Wrap the app in ProviderScope for Riverpod State Management
  runApp(const ProviderScope(child: MyApp()));
}
