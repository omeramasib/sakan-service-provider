import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../../services/secure_storage_service.dart';
import 'package:http/http.dart' as http;

import '../../../../constants/dialogs.dart';
import '../../../../constants/httpHelper.dart';
import '../../../routes/app_pages.dart';
import '../models/booking_model.dart';

class BookingProvider extends GetConnect {
  static BookingProvider get instance => Get.put(BookingProvider());
  final SecureStorageService storage = SecureStorageService.instance;
  Timer? timer;

  @override
  void onInit() {
    super.onInit();
    httpClient.baseUrl = HttpHelper.baseUrlPerson;
    print('>>> BookingProvider.onInit() called');
    EasyLoading.addStatusCallback((status) {
      if (status == EasyLoadingStatus.dismiss) {
        timer?.cancel();
      }
    });
  }

  /// Fetch all bookings for the daklia owner
  Future<List<BookingModel>> getOwnerBookings({String? status}) async {
    try {
      String url = HttpHelper.baseUrlPerson + HttpHelper.ownerBookings;
      if (status != null && status.isNotEmpty) {
        url += '?status=$status';
      }

      log('Fetching owner bookings from: $url');

      String? token = await storage.read('token');
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Token $token',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 30));

      log('Bookings response status: ${response.statusCode}');
      log('Bookings response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<BookingModel> bookings = [];

        if (data['data'] != null && data['data'] is List) {
          for (var booking in data['data']) {
            bookings.add(BookingModel.fromJson(booking));
          }
        }

        return bookings;
      } else if (response.statusCode == 401) {
        EasyLoading.dismiss();
        Dialogs.errorDialog(Get.context!, 'token_is_invalid'.tr);
        Get.offAllNamed(Routes.AUTH, arguments: 0);
        return [];
      } else {
        log('Failed to fetch bookings: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      log('Error fetching bookings: $e');
      return [];
    }
  }

  /// Get booking details by ID
  Future<BookingModel?> getBookingDetails(int bookingId) async {
    try {
      String url =
          HttpHelper.baseUrlPerson + HttpHelper.bookingDetails + '$bookingId/';

      log('Fetching booking details from: $url');

      String? token = await storage.read('token');
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Token $token',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 30));

      log('Booking details response status: ${response.statusCode}');
      log('Booking details response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['data'] != null) {
          return BookingModel.fromJson(data['data']);
        }
        return null;
      } else if (response.statusCode == 401) {
        EasyLoading.dismiss();
        Dialogs.errorDialog(Get.context!, 'token_is_invalid'.tr);
        Get.offAllNamed(Routes.AUTH, arguments: 0);
        return null;
      } else {
        log('Failed to fetch booking details: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      log('Error fetching booking details: $e');
      return null;
    }
  }

  /// Approve a booking
  Future<bool> approveBooking(int bookingId) async {
    try {
      EasyLoading.show(status: 'loading'.tr);

      String url = HttpHelper.baseUrlPerson +
          HttpHelper.ownerBookings +
          '$bookingId' +
          HttpHelper.bookingAction;

      log('Approving booking at: $url');

      String? token = await storage.read('token');
      final response = await http
          .post(
            Uri.parse(url),
            headers: {
              'Authorization': 'Token $token',
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
            body: json.encode({
              'action': 'approve',
            }),
          )
          .timeout(const Duration(seconds: 30));

      log('Approve response status: ${response.statusCode}');
      log('Approve response body: ${response.body}');

      timer = Timer(const Duration(seconds: 1), () {
        EasyLoading.dismiss();
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        Dialogs.successDialog(Get.context!, 'booking_approved'.tr);
        return true;
      } else if (response.statusCode == 401) {
        Dialogs.errorDialog(Get.context!, 'token_is_invalid'.tr);
        Get.offAllNamed(Routes.AUTH, arguments: 0);
        return false;
      } else {
        final data = json.decode(response.body);
        Dialogs.errorDialog(Get.context!, data['message'] ?? 'error'.tr);
        return false;
      }
    } catch (e) {
      log('Error approving booking: $e');
      EasyLoading.dismiss();
      Dialogs.errorDialog(Get.context!, 'error'.tr);
      return false;
    }
  }

  /// Reject a booking with reason
  Future<bool> rejectBooking(int bookingId, String reason) async {
    try {
      EasyLoading.show(status: 'loading'.tr);

      String url = HttpHelper.baseUrlPerson +
          HttpHelper.ownerBookings +
          '$bookingId' +
          HttpHelper.bookingAction;

      log('Rejecting booking at: $url');

      String? token = await storage.read('token');
      final response = await http
          .post(
            Uri.parse(url),
            headers: {
              'Authorization': 'Token $token',
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
            body: json.encode({
              'action': 'reject',
              'reason': reason,
            }),
          )
          .timeout(const Duration(seconds: 30));

      log('Reject response status: ${response.statusCode}');
      log('Reject response body: ${response.body}');

      timer = Timer(const Duration(seconds: 1), () {
        EasyLoading.dismiss();
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        Dialogs.successDialog(Get.context!, 'booking_rejected'.tr);
        return true;
      } else if (response.statusCode == 401) {
        Dialogs.errorDialog(Get.context!, 'token_is_invalid'.tr);
        Get.offAllNamed(Routes.AUTH, arguments: 0);
        return false;
      } else {
        final data = json.decode(response.body);
        Dialogs.errorDialog(Get.context!, data['message'] ?? 'error'.tr);
        return false;
      }
    } catch (e) {
      log('Error rejecting booking: $e');
      EasyLoading.dismiss();
      Dialogs.errorDialog(Get.context!, 'error'.tr);
      return false;
    }
  }
}
