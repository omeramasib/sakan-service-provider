# Shorebird Code Push

This project uses [Shorebird](https://shorebird.dev/) for Code Push. Shorebird allows you to push updates to your Flutter app instantly, without going through the app store review process.

## Setup

Shorebird is already configured for this project with support for `development` and `production` flavors.

To use Shorebird on your machine, you need to install the CLI:

```bash
curl --proto '=https' --tlsv1.2 https://raw.githubusercontent.com/shorebirdtech/install/main/install.sh -sSf | bash
```

And login:

```bash
shorebird login
```

### ⚠️ Common Issue: "command not found: shorebird"
If you see this error after installation, your terminal hasn't picked up the new path yet. Run this command to fix it for the current session:

```bash
source ~/.zshrc
```

Or simply **restart your terminal**.

## Releases

When you are ready to publish a new version of your app to the Play Store or App Store, you must create a release with Shorebird. This usually replaces your standard `flutter build` command.

**Note on Obfuscation:**
It is highly recommended to obfuscate your code for release builds. This hides your Dart code and reduces the app size.
**Important:** The `--obfuscate` flag must be passed after a `--` separator so it is forwarded to the Flutter build command.

### Android

For **Development** flavor:
```bash
shorebird release android --flavor development --target lib/main_development.dart --split-debug-info=./build/app/outputs/symbols -- --obfuscate
```

For **Production** flavor:
```bash
shorebird release android --flavor production --target lib/main_production.dart --split-debug-info=./build/app/outputs/symbols -- --obfuscate
```

This command will build your app bundle (`.aab`) and upload the release artifacts to Shorebird. You can then find the `.aab` file in `build/app/outputs/bundle/developmentRelease/` (or production) to upload to the Play Store.

### iOS

For **Development** flavor:
```bash
shorebird release ios --flavor development --target lib/main_development.dart --split-debug-info=./build/ios/outputs/symbols -- --obfuscate
```

For **Production** flavor:
```bash
shorebird release ios --flavor production --target lib/main_production.dart --split-debug-info=./build/ios/outputs/symbols -- --obfuscate
```

This creates an `.xcarchive` which you can then distribute via TestFlight or the App Store.

## Patching

Once a release is live, you can push over-the-air updates (patches) to it.

### Android

To patch the **Development** flavor:
```bash
shorebird patch android --flavor development --target lib/main_development.dart --split-debug-info=./build/app/outputs/symbols -- --obfuscate
```

To patch the **Production** flavor:
```bash
shorebird patch android --flavor production --target lib/main_production.dart --split-debug-info=./build/app/outputs/symbols -- --obfuscate
```

### iOS

To patch the **Development** flavor:
```bash
shorebird patch ios --flavor development --target lib/main_development.dart --split-debug-info=./build/ios/outputs/symbols -- --obfuscate
```

To patch the **Production** flavor:
```bash
shorebird patch ios --flavor production --target lib/main_production.dart --split-debug-info=./build/ios/outputs/symbols -- --obfuscate
```

## Selecting Release Version

By default, Shorebird patches the latest release. if you need to patch a specific version, you can use the `--release-version` flag:

```bash
shorebird patch android --flavor production --target lib/main_production.dart --release-version 1.0.0+1 --split-debug-info=./build/app/outputs/symbols -- --obfuscate
```

## Previewing

You can preview the release on a connected device before publishing:

```bash
shorebird preview --app-id <APP_ID> --release-version <VERSION>
```

(You can find your App IDs in `shorebird.yaml`)
