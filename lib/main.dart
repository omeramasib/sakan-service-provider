import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/modules/network/bindings/network_binding.dart';
import 'app/routes/app_pages.dart';
import 'constants/theme_manager.dart';
import 'language_controller/language_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase FIRST
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e, stack) {
    debugPrint('MAIN: CRITICAL Error initializing Firebase: $e');
    debugPrint('MAIN: Stack trace: $stack');
  }

  await GetStorage.init();

  runApp(
    GetMaterialApp(
      title: "sakan-provider",
      debugShowCheckedModeBanner: false,
      translations: LanguageController.instance,
      locale: Locale('ar', 'SA'),
      // fallbackLocale: LanguageController.instance.fallbackLocale,
      initialRoute: AppPages.INITIAL,
      initialBinding: NetworkBinding(),
      getPages: AppPages.routes,
      theme: getApplicationTheme(),
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
      ],
      builder: EasyLoading.init(),
    ),
  );
  configLoading();
}

void configLoading() async {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}
