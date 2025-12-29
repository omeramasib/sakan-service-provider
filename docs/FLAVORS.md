# Flutter Flavors Documentation

This project uses Flutter flavors to manage different environments (development and production).

## Overview

| Flavor | Base URL | App Name | Android ID | iOS Bundle ID |
|--------|----------|----------|------------|---------------|
| `development` | `https://lobster-app-aqlvh.ondigitalocean.app` | Sakan Provider Dev | `com.sakan.service_provider` | `com.sakan.service-provider` |
| `production` | `https://sakan-sd.com` | Sakan Provider | `com.sakan.service_provider` | `com.sakan.service-provider` |

## Project Structure

```
lib/
├── constants/
│   ├── flavor_config.dart    # FlavorConfig singleton class
│   └── httpHelper.dart       # API endpoints (uses FlavorConfig)
├── main.dart                 # Shared app initialization
├── main_development.dart     # Development entry point
└── main_production.dart      # Production entry point
```

---

## Running the App

### Development
```bash
flutter run --flavor development -t lib/main_development.dart
```

### Production
```bash
flutter run --flavor production -t lib/main_production.dart
```

---

## Building for Release

### Android APK

```bash
# Development
flutter build apk --flavor development -t lib/main_development.dart

# Production
flutter build apk --flavor production -t lib/main_production.dart
```

### Android App Bundle

```bash
# Development
flutter build appbundle --flavor development -t lib/main_development.dart

# Production
flutter build appbundle --flavor production -t lib/main_production.dart
```

### iOS

```bash
# Development
flutter build ios --flavor development -t lib/main_development.dart

# Production
flutter build ios --flavor production -t lib/main_production.dart
```

---

## FlavorConfig Usage

### Accessing Current Configuration

```dart
import 'package:sakan/constants/flavor_config.dart';

// Get the current base URL
String baseUrl = FlavorConfig.instance.baseUrl;

// Get the flavor name
String name = FlavorConfig.instance.name; // "Development" or "Production"

// Get the flavor enum
Flavor flavor = FlavorConfig.instance.flavor;
```

### Checking Current Flavor

```dart
import 'package:sakan/constants/flavor_config.dart';

if (FlavorConfig.isDevelopment) {
  // Development-specific code
  print('Running in development mode');
}

if (FlavorConfig.isProduction) {
  // Production-specific code
  print('Running in production mode');
}
```

### Using with API Calls

The `HttpHelper` class automatically uses the correct base URL:

```dart
import 'package:sakan/constants/httpHelper.dart';

// These URLs are automatically constructed based on current flavor:
// HttpHelper.baseUrl       -> {flavorBaseUrl}/api/v1/user
// HttpHelper.baseUrlPerson -> {flavorBaseUrl}/api/v1/person
// HttpHelper.baseUrl2      -> {flavorBaseUrl}/api/v1/daklia
```

---

## Adding New Environment Variables

To add new environment-specific variables:

1. **Update `FlavorConfig` class** in `lib/constants/flavor_config.dart`:

```dart
class FlavorConfig {
  final Flavor flavor;
  final String name;
  final String baseUrl;
  final String newVariable;  // Add new field

  // Update the initialize method for each flavor:
  static void initialize({required Flavor flavor}) {
    switch (flavor) {
      case Flavor.development:
        _instance = FlavorConfig._internal(
          flavor: flavor,
          name: 'Development',
          baseUrl: 'https://lobster-app-aqlvh.ondigitalocean.app',
          newVariable: 'dev_value',  // Development value
        );
        break;
      case Flavor.production:
        _instance = FlavorConfig._internal(
          flavor: flavor,
          name: 'Production',
          baseUrl: 'https://sakan-sd.com',
          newVariable: 'prod_value',  // Production value
        );
        break;
    }
  }
}
```

---

## Firebase Configuration

If using separate Firebase projects per environment, run:

```bash
# For development
flutterfire configure --project=your-dev-project-id

# For production
flutterfire configure --project=your-prod-project-id
```

---

## IDE Configuration

### VS Code

Add launch configurations to `.vscode/launch.json`:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Development",
      "request": "launch",
      "type": "dart",
      "program": "lib/main_development.dart",
      "args": ["--flavor", "development"]
    },
    {
      "name": "Production",
      "request": "launch",
      "type": "dart",
      "program": "lib/main_production.dart",
      "args": ["--flavor", "production"]
    }
  ]
}
```

### Android Studio / IntelliJ

1. Go to **Run** > **Edit Configurations**
2. Create new **Flutter** configurations
3. Set **Dart entrypoint** and **Additional run args**:
   - Development: `-t lib/main_development.dart --flavor development`
   - Production: `-t lib/main_production.dart --flavor production`
