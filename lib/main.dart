import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/routes/app_pages.dart';
import 'constants/theme_manager.dart';
import 'language_controller/language_controller.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(
    GetMaterialApp(
      title: "Application",
      debugShowCheckedModeBanner: false,
      translations: LanguageController.instance,
      locale: Locale(LanguageController.instance.getLocale),
      fallbackLocale: LanguageController.instance.fallbackLocale,
      initialRoute: AppPages.INITIAL,
      // initialBinding: NetworkBinding(),
      getPages: AppPages.routes,
      theme: getApplicationTheme(),
      // builder: EasyLoading.init(),
    ),
  );
}
