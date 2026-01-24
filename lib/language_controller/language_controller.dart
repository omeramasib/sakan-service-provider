import 'dart:ui';

import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../language/ar.dart';
import '../language/en.dart';

class LanguageController extends GetxController implements Translations {
  static LanguageController get instance => Get.put(LanguageController());

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Cached locale value for synchronous access
  String? _cachedLocale;

  var locale = const Locale('ar', 'SA');
  var fallbackLocale = const Locale('ar', 'SA');

  @override
  void onInit() {
    super.onInit();
    _loadCachedLocale();
  }

  Future<void> _loadCachedLocale() async {
    _cachedLocale = await _storage.read(key: 'locale');
  }

  String get getLocale {
    if (_cachedLocale != null) {
      return _cachedLocale!;
    }
    return 'ar';
  }

  get isEnglish => getLocale == 'en';

  set setLocale(languageCode) {
    _cachedLocale = languageCode;
    _storage.write(key: 'locale', value: languageCode);
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
