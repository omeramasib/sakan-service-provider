import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'app/services/notification_service.dart';
import 'constants/flavor_config.dart' as config;
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'flavors.dart';

/// Common main function called by flavor-specific entry points.
/// Assumes F.appFlavor and FlavorConfig are already initialized.
Future<void> mainCommon({Widget? rootWidget}) async {
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Print FCM Token for debugging
  String? fcmToken = await FirebaseMessaging.instance.getToken();
  debugPrint('FCM TOKEN: $fcmToken');

  // Register background message handler (not supported on web)
  if (!kIsWeb) {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  // Initialize Notification Service
  await NotificationService().initialize();

  runApp(rootWidget ?? const App());
}

/// Main entry point - used by flutter build web
/// For mobile apps, use main_production.dart or main_development.dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize flavor for web builds (main.dart is used directly by flutter build web)
  F.appFlavor = Flavor.production;
  config.FlavorConfig.initialize(flavor: config.Flavor.production);

  await mainCommon();
}
