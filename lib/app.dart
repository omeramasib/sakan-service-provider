import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import 'app/routes/app_pages.dart';
import 'flavors.dart';
import 'language_controller/language_controller.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final languageController = Get.put(LanguageController());

    return GetMaterialApp(
      title: F.title,
      debugShowCheckedModeBanner: false,
      translations: languageController,
      locale: languageController.locale,
      fallbackLocale: languageController.fallbackLocale,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      builder: (context, child) {
        // Initialize EasyLoading
        child = EasyLoading.init()(context, child);

        // Add flavor banner only in development (never in production)
        if (kDebugMode && F.appFlavor == Flavor.development) {
          return Banner(
            location: BannerLocation.topStart,
            message: F.name,
            color: Colors.green.withAlpha(150),
            textStyle: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 12.0,
              letterSpacing: 1.0,
            ),
            textDirection: TextDirection.ltr,
            child: child,
          );
        }
        return child;
      },
    );
  }
}
