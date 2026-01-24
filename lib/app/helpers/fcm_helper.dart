import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import '../services/secure_storage_service.dart';
import '../../constants/httpHelper.dart';

class FCMHelper extends GetConnect {
  static FCMHelper get instance => Get.put(FCMHelper());
  final SecureStorageService storage = SecureStorageService.instance;

  Future<void> updateFCMToken() async {
    // Debug: Log where this method is being called from
    print('=== FCMHelper.updateFCMToken() CALLED ===');
    print(
        'Called from: ${StackTrace.current.toString().split('\n').take(5).join('\n')}');

    try {
      print('Attempting to get FCM token...');
      String? token = await FirebaseMessaging.instance.getToken();
      if (token == null) {
        print('FCM Token is null - Firebase may not be initialized properly');
        return;
      }

      print('FCM Token obtained: ${token.substring(0, 20)}...');

      String? authToken = await storage.read('token');
      if (authToken == null) {
        print('Auth Token is null, cannot update FCM token');
        return;
      }

      print('Auth token exists, sending FCM token to server...');
      print('URL: ${HttpHelper.baseUrlPerson}${HttpHelper.updateFcmToken}');

      final response = await post(
        HttpHelper.baseUrlPerson + HttpHelper.updateFcmToken,
        {
          'fcm_token': token,
        },
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Token $authToken',
        },
      );

      print('Update FCM Token Status Code: ${response.statusCode}');
      print('Update FCM Token Response: ${response.body}');

      if (response.statusCode == 200) {
        print('FCM Token updated successfully');
      } else {
        print('Failed to update FCM Token: ${response.statusText}');
      }
    } catch (e, stackTrace) {
      if (e.toString().contains('permission-blocked')) {
        print(
            'Notification permission blocked by user. FCM token update skipped.');
      } else {
        print('Error updating FCM Token: $e');
        print('Stack trace: $stackTrace');
      }
    }

    print('=== FCMHelper.updateFCMToken() FINISHED ===');
  }
}
