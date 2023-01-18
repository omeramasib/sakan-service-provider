import 'dart:developer';
import 'dart:ui';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/foundation.dart';

import '../language/ar.dart';
import '../language/en.dart';

class LanguageController extends GetxController implements Translations {
  static LanguageController get instance => Get.put(LanguageController());

  final storage = GetStorage();

  var locale = const Locale('en', 'US');
  var fallbackLocale = const Locale('en', 'US');

  String get getLocale {
    if (storage.hasData('locale')) {
      return storage.read('locale');
    }
    return Get.deviceLocale!.languageCode;
  }

  get isEnglish => getLocale == 'en';

  set setLocale(languageCode) {
    storage.write('locale', languageCode);
    Get.offAllNamed('/home');
  }

  final lang = ['english'.tr, 'arabic'.tr].obs;

  static final locales = [
    const Locale('en', 'US'),
    const Locale('ar', 'SA'),
  ].obs;

  @override
  Map<String, Map<String, String>> get keys => {'en_US': enUS, 'ar_SA': arSA};

  changeLocale(dynamic language) {
    final locale = _getLocaleFromLanguage(language);
    Get.updateLocale(locale!);
    setLocale = locale.languageCode;
  }

  Locale? _getLocaleFromLanguage(String language) {
    for (int i = 0; i < lang.length; i++) {
      if (language == lang[i]) return locales[i];
    }
    return Get.locale;
  }
}
