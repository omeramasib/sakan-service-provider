/// Enum representing the available app flavors/environments.
enum Flavor { development, production }

/// Singleton configuration class for managing flavor-specific settings.
///
/// Initialize this class at app startup before any other initialization:
/// ```dart
/// FlavorConfig.initialize(flavor: Flavor.development);
/// ```
class FlavorConfig {
  final Flavor flavor;
  final String name;
  final String baseUrl;

  static FlavorConfig? _instance;

  FlavorConfig._internal({
    required this.flavor,
    required this.name,
    required this.baseUrl,
  });

  /// Get the current FlavorConfig instance.
  /// Throws if initialize() hasn't been called.
  static FlavorConfig get instance {
    if (_instance == null) {
      throw StateError(
          'FlavorConfig has not been initialized. Call FlavorConfig.initialize() first.');
    }
    return _instance!;
  }

  /// Check if current flavor is development.
  static bool get isDevelopment => _instance?.flavor == Flavor.development;

  /// Check if current flavor is production.
  static bool get isProduction => _instance?.flavor == Flavor.production;

  /// Initialize the FlavorConfig with the specified flavor.
  /// This should be called once at app startup, before runApp().
  static void initialize({required Flavor flavor}) {
    switch (flavor) {
      case Flavor.development:
        _instance = FlavorConfig._internal(
          flavor: flavor,
          name: 'Development',
          //baseUrl: 'https://lobster-app-aqlvh.ondigitalocean.app',
          baseUrl: 'http://10.0.2.2:8000/'
        );
        break;
      case Flavor.production:
        _instance = FlavorConfig._internal(
          flavor: flavor,
          name: 'Production',
          baseUrl: 'https://sakan-sd.com',
        );
        break;
    }
  }
}
