import 'package:get/get.dart';
import 'package:sakan/constants/flavor_config.dart';
import '../models/app_config_model.dart';

/// Provider for fetching app configuration from the backend.
///
/// Uses GetConnect for native GetX networking.
class ConfigProvider extends GetConnect {
  static ConfigProvider get instance => Get.put(ConfigProvider());

  @override
  void onInit() {
    httpClient.baseUrl = FlavorConfig.instance.baseUrl;
    httpClient.timeout = const Duration(seconds: 30);
    super.onInit();
  }

  /// Fetches app configuration for the provider app.
  ///
  /// Endpoint: GET /api/app-configuration/?app_type=provider
  Future<AppConfigModel?> getAppConfiguration() async {
    try {
      final response = await get(
        '/api/app-configuration/',
        query: {'app_type': 'provider'},
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200 && response.body != null) {
        return AppConfigModel.fromJson(response.body as Map<String, dynamic>);
      }

      // Log error for debugging
      print('ConfigProvider: Failed to fetch config');
      print('Status: ${response.statusCode}');
      print('Body: ${response.body}');

      return null;
    } catch (e) {
      print('ConfigProvider: Exception occurred: $e');
      return null;
    }
  }
}
