import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import '../routes/app_pages.dart';

/// Secure storage service for storing sensitive data like tokens and user info.
/// This is a singleton service that wraps FlutterSecureStorage.
class SecureStorageService {
  static SecureStorageService? _instance;

  static SecureStorageService get instance {
    _instance ??= SecureStorageService._();
    return _instance!;
  }

  SecureStorageService._();

  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    ),
  );

  // Storage keys
  static const String keyToken = 'token';
  static const String keyPhone = 'phone';
  static const String keyUserId = 'user_id';
  static const String keyOtp = 'otp';
  static const String keyLanguage = 'language';
  static const String keyDakliaId = 'daklia_id';

  /// Read a value from secure storage
  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  /// Write a value to secure storage
  Future<void> write(String key, String? value) async {
    if (value != null) {
      await _storage.write(key: key, value: value);
    }
  }

  /// Delete a value from secure storage
  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  /// Delete all values from secure storage
  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }

  static bool _isHandlingUnauthorized = false;

  /// Handle 401 Unauthorized error globally
  static Future<void> handleUnauthorized() async {
    if (_isHandlingUnauthorized) {
      debugPrint('🚨 handleUnauthorized: Already processing a redirect, skipping duplicate.');
      return;
    }
    _isHandlingUnauthorized = true;

    try {
      debugPrint('🚨 handleUnauthorized: Token invalidated. Clearing storage and redirecting to Login...');
      await instance.deleteAll();
      debugPrint('🚨 handleUnauthorized: Storage cleared. Executing navigation to Routes.AUTH...');
      Get.offAllNamed(Routes.AUTH, arguments: 0);
    } catch (e) {
      debugPrint('🚨 handleUnauthorized error: $e');
    } finally {
      // Intentionally not resetting _isHandlingUnauthorized to true/false in a loop 
      // because we are navigating away forever. But safe to leave as-is.
      _isHandlingUnauthorized = false;
    }
  }

  /// Check if a key exists in secure storage
  Future<bool> containsKey(String key) async {
    return await _storage.containsKey(key: key);
  }

  /// Read all values from secure storage
  Future<Map<String, String>> readAll() async {
    return await _storage.readAll();
  }
}
