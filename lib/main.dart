import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app/app.dart';
import 'core/database/local_db.dart';
import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint("Handling a background message: ${message.messageId}");
}

void main() async {
  // Ensure Flutter bindings are initialized before calling native code
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();

  try {
    // Initialize Firebase Cloud Messaging platform
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Initialize FCM Push Notifications
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted permission for FCM.');
    }

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Got a message whilst in the foreground!');
      if (message.notification != null) {
        debugPrint(
            'Message also contained a notification: ${message.notification}');
      }
    });
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
