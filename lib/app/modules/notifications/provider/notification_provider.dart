import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import '../../../../constants/httpHelper.dart';
import '../../../services/secure_storage_service.dart';
import 'package:http/http.dart' as http;

class NotificationProvider extends GetConnect {
  static NotificationProvider get instance => Get.put(NotificationProvider());
  final SecureStorageService storage = SecureStorageService.instance;

  @override
  void onInit() {
    super.onInit();
    httpClient.baseUrl = HttpHelper.baseUrlPerson;
  }

  /// Fetch notifications with pagination
  Future<Map<String, dynamic>> getNotifications({
    int page = 1,
    int pageSize = 20,
    bool? isRead,
  }) async {
    try {
      String url =
          '${HttpHelper.baseUrlPerson}${HttpHelper.notifications}?page=$page&page_size=$pageSize';
      if (isRead != null) {
        url += '&is_read=$isRead';
      }

      log('Fetching notifications from: $url');

      String? token = await storage.read('token');
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Token $token',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 30));

      log('Notifications response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        log('Failed to fetch notifications: ${response.body}');
        return {};
      }
    } catch (e) {
      log('Error fetching notifications: $e');
      return {};
    }
  }

  /// Mark notification as read
  Future<bool> markAsRead(int notificationId) async {
    try {
      String url =
          '${HttpHelper.baseUrlPerson}${HttpHelper.notifications}$notificationId/read/';

      log('Marking notification as read: $url');

      String? token = await storage.read('token');
      final response = await http.patch(
        Uri.parse(url),
        headers: {
          'Authorization': 'Token $token',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 30));

      log('Mark read response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        return true;
      } else {
        log('Failed to mark notification as read: ${response.body}');
        return false;
      }
    } catch (e) {
      log('Error marking notification as read: $e');
      return false;
    }
  }
}
