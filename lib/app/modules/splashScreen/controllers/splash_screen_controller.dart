import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/models/app_config_model.dart';
import '../../../data/providers/config_provider.dart';
import '../../../routes/app_pages.dart';
import '../../../services/secure_storage_service.dart';

/// Controller for the Splash Screen module.
///
/// Handles app configuration fetching, version checking,
/// maintenance mode, and force update logic.
class SplashScreenController extends GetxController {
  // Dependencies
  final ConfigProvider _configProvider = Get.put(ConfigProvider());

  // Observable states
  final isLoading = true.obs;
  final showMaintenance = false.obs;
  final showForceUpdate = false.obs;
  final maintenanceMessage = ''.obs;
  final storeUrl = ''.obs;
  final newVersion = ''.obs;
  final errorMessage = ''.obs;

  @override
  void onReady() {
    super.onReady();
    _initializeApp();
  }

  /// Main initialization logic.
  ///
  /// Fetches app configuration and applies the decision tree:
  /// 1. Maintenance mode → show blocking view
  /// 2. Force update → show update required view
  /// 3. Success → navigate to appropriate screen
  Future<void> _initializeApp() async {
    try {
      isLoading.value = true;

      // Fetch app configuration from API
      final config = await _configProvider.getAppConfiguration();

      if (config == null) {
        // If API fails, proceed to normal flow (graceful degradation)
        debugPrint('SplashController: Config is null, proceeding to auth');
        await _navigateToNextScreen();
        return;
      }

      // Get installed app version
      final packageInfo = await PackageInfo.fromPlatform();
      final installedVersion = packageInfo.version;
      debugPrint('SplashController: Installed version: $installedVersion');

      // Priority 1: Check maintenance mode
      if (config.isMaintenanceMode) {
        debugPrint('SplashController: Maintenance mode is active');
        maintenanceMessage.value = config.maintenanceMessage ??
            'We are currently under maintenance. Please try again later.';
        showMaintenance.value = true;
        isLoading.value = false;
        return;
      }

      // Priority 2: Check force update
      final requiresUpdate = _checkIfUpdateRequired(
        config: config,
        installedVersion: installedVersion,
      );

      if (requiresUpdate) {
        debugPrint('SplashController: Force update required');
        storeUrl.value = _getStoreUrl(config.storeUrls);
        // Set newVersion to min version based on platform
        newVersion.value = Platform.isAndroid
            ? config.minAndroidVersion ?? ''
            : config.minIosVersion ?? '';
        showForceUpdate.value = true;
        isLoading.value = false;
        return;
      }

      // Priority 3: Navigate to next screen
      await _navigateToNextScreen();
    } catch (e, stackTrace) {
      debugPrint('SplashController: Error during initialization: $e');
      debugPrint('Stack trace: $stackTrace');

      // On error, proceed to auth screen (graceful degradation)
      await _navigateToNextScreen();
    }
  }

  /// Checks if an app update is required.
  ///
  /// Returns true if:
  /// - [AppConfigModel.isForceUpdate] is true AND
  /// - min_android_version/min_ios_version > installed version
  bool _checkIfUpdateRequired({
    required AppConfigModel config,
    required String installedVersion,
  }) {
    // If force update flag is not set, don't require update
    if (!config.isForceUpdate) {
      return false;
    }

    // Get minimum version based on platform (Android or iOS)
    final minVersionString =
        Platform.isAndroid ? config.minAndroidVersion : config.minIosVersion;

    if (minVersionString == null || minVersionString.isEmpty) {
      return false;
    }

    try {
      final installed = Version.parse(installedVersion);
      final minRequired = Version.parse(minVersionString);

      // Force update is required if min version > installed version
      // (meaning installed version is below the minimum required)
      return installed < minRequired;
    } catch (e) {
      debugPrint('SplashController: Error parsing versions: $e');
      return false;
    }
  }

  /// Gets the appropriate store URL based on platform.
  String _getStoreUrl(StoreUrlsModel? storeUrls) {
    if (storeUrls == null) {
      return '';
    }

    return Platform.isAndroid ? storeUrls.android ?? '' : storeUrls.ios ?? '';
  }

  /// Navigates to the next screen (Auth or Home).
  Future<void> _navigateToNextScreen() async {
    isLoading.value = false;
    final storage = Get.put(SecureStorageService.instance);
    final token = await storage.read('token');

    if (token != null && token.isNotEmpty) {
      debugPrint('SplashController: Token found, navigating to HOME');
      Get.offAllNamed(Routes.HOME);
    } else {
      debugPrint('SplashController: No token found, navigating to AUTH');
      Get.offAllNamed(Routes.AUTH);
    }
  }

  /// Opens the app store for update.
  Future<void> openStore() async {
    final url = storeUrl.value;

    if (url.isEmpty) {
      debugPrint('SplashController: Store URL is empty');
      return;
    }

    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('SplashController: Cannot launch URL: $url');
    }
  }

  /// Retry initialization (useful for maintenance mode)
  Future<void> retry() async {
    showMaintenance.value = false;
    showForceUpdate.value = false;
    await _initializeApp();
  }
}
