/// Model representing app configuration from the backend.
///
/// Used for maintenance mode, force update, and version checking.
class AppConfigModel {
  final String? minAndroidVersion;
  final String? minIosVersion;
  final String? currentActiveVersion;
  final bool isMaintenanceMode;
  final String? maintenanceMessage;
  final StoreUrlsModel? storeUrls;
  final bool isForceUpdate;

  AppConfigModel({
    this.minAndroidVersion,
    this.minIosVersion,
    this.currentActiveVersion,
    this.isMaintenanceMode = false,
    this.maintenanceMessage,
    this.storeUrls,
    this.isForceUpdate = false,
  });

  factory AppConfigModel.fromJson(Map<String, dynamic> json) {
    return AppConfigModel(
      minAndroidVersion: json['min_android_version'] as String?,
      minIosVersion: json['min_ios_version'] as String?,
      currentActiveVersion: json['current_active_version'] as String?,
      isMaintenanceMode: json['is_maintenance_mode'] as bool? ?? false,
      maintenanceMessage: json['maintenance_message'] as String?,
      storeUrls: json['store_urls'] != null
          ? StoreUrlsModel.fromJson(json['store_urls'] as Map<String, dynamic>)
          : null,
      isForceUpdate: json['is_force_update'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'min_android_version': minAndroidVersion,
      'min_ios_version': minIosVersion,
      'current_active_version': currentActiveVersion,
      'is_maintenance_mode': isMaintenanceMode,
      'maintenance_message': maintenanceMessage,
      'store_urls': storeUrls?.toJson(),
      'is_force_update': isForceUpdate,
    };
  }
}

/// Model for store URLs (Android Play Store and iOS App Store).
class StoreUrlsModel {
  final String? android;
  final String? ios;

  StoreUrlsModel({
    this.android,
    this.ios,
  });

  factory StoreUrlsModel.fromJson(Map<String, dynamic> json) {
    return StoreUrlsModel(
      android: json['android'] as String?,
      ios: json['ios'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'android': android,
      'ios': ios,
    };
  }
}
