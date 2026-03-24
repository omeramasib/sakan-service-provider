import 'dart:async';

import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../../services/secure_storage_service.dart';
import 'package:http/http.dart' as http;
import '../../../../constants/dialogs.dart';
import '../../../../constants/httpHelper.dart';
import '../../../routes/app_pages.dart';
import '../../../../core/utils/safe_json_helper.dart';

class EditMultipleRoomProvider extends GetConnect {
  static EditMultipleRoomProvider get instance =>
      Get.put(EditMultipleRoomProvider());
  final SecureStorageService storage = SecureStorageService.instance;
  // var networkController = Get.put(NetworkController());
  Timer? timer;
  @override
  void onInit() {
    httpClient.baseUrl = HttpHelper.baseUrl;
    EasyLoading.addStatusCallback((status) {
      if (status == EasyLoadingStatus.dismiss) {
        timer?.cancel();
      }
    });
  }

  Future<void> editMultipleRoom({
    required File image,
    required int roomNumber,
    required int numberOfBeds,
    required int numberOfAvailableBeds,
    required bool dailyBooking,
    required bool monthlyBooking,
    required int pricePerDay,
    required int pricePerMonth,
    required String roomId,
  }) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      EasyLoading.show(status: 'loading'.tr);

      final token = await storage.read('token');
      final dakliaId = await storage.read('dakliaId');
      int statusCode;
      String responseString;

      var request = http.MultipartRequest(
        'PUT',
        Uri.parse('${HttpHelper.baseUrl2}/$dakliaId${HttpHelper.rooms}$roomId/'),
      );
      request.headers['authorization'] = 'Token $token';
      request.fields['room_number'] = roomNumber.toString();
      request.fields['numberOfBeds'] = numberOfBeds.toString();
      request.fields['num_Available_Beds'] = numberOfAvailableBeds.toString();
      request.fields['daily_booking'] = dailyBooking.toString();
      request.fields['monthly_booking'] = monthlyBooking.toString();
      request.fields['price_per_day'] = pricePerDay.toString();
      request.fields['price_per_month'] = pricePerMonth.toString();

      if (image.path != '') {
        request.files
            .add(await http.MultipartFile.fromPath('room_image', image.path));
      }

      debugPrint('========== [editMultipleRoom] MULTIPART REQUEST ==========');
      debugPrint('URL: ${request.url}');
      debugPrint('Method: PUT');
      debugPrint('Headers: ${request.headers}');
      debugPrint('Fields: ${request.fields}');
      debugPrint('Files: ${request.files.map((f) => '${f.field}: ${f.filename} (${f.length} bytes)').toList()}');
      debugPrint('==========================================================');

      var streamedResponse = await request.send();
      var responseData = await streamedResponse.stream.toBytes();
      responseString = String.fromCharCodes(responseData);
      statusCode = streamedResponse.statusCode;

      debugPrint('========== [editMultipleRoom] MULTIPART RESPONSE ==========');
      debugPrint('Status: $statusCode');
      debugPrint('Response headers: ${streamedResponse.headers}');
      debugPrint('Body: ${responseString.length > 2000 ? responseString.substring(0, 2000) : responseString}');
      debugPrint('===========================================================');

      log('this is the status code: $statusCode');
      log('this is the raw response: $responseString');

      // Safe decode — won't crash on plain text like "Not Found"
      final data = safeJsonDecode(responseString);

      if (data == null && statusCode != 200) {
        log('Response is not valid JSON');
        EasyLoading.dismiss();
        Dialogs.errorDialog(Get.context!, 'server_error'.tr);
        return;
      }

      log('this is the data: $data');
      EasyLoading.show(status: 'loading'.tr);

      if (statusCode == 200) {
        log('this is the statusCode : $statusCode');
        timer = Timer(const Duration(seconds: 1), () {
          EasyLoading.dismiss();
        });
        Dialogs.successDialog(
            Get.context!, "success_update_room_information".tr);
        Get.offAllNamed(Routes.HOME);
        return;
      }

      if (statusCode == 400 && data is Map<String, dynamic>) {
        timer = Timer(const Duration(seconds: 1), () {
          EasyLoading.dismiss();
        });

        String errorMessage = 'validation_error'.tr;
        if (data['message'] == 'Daklia is already exist') {
          errorMessage = 'daklia_already_exist'.tr;
        } else if (data['user_id'] != null) {
          errorMessage = 'user_id_already_exist'.tr;
        } else if (data['daklia_image'] != null ||
            data['image'] != null ||
            data['room_image'] != null) {
          var imageError =
              data['room_image'] ?? data['daklia_image'] ?? data['image'];
          if (imageError is List) {
            List errorList = imageError;
            errorMessage = errorList.isNotEmpty
                ? errorList.first.toString()
                : 'daklia_image_required'.tr;
          } else {
            errorMessage = 'daklia_image_required'.tr;
          }
        } else if (data['room_number'] != null || data['roomNumber'] != null) {
          var roomError = data['room_number'] ?? data['roomNumber'];
          if (roomError is List) {
            List errorList = roomError;
            errorMessage = errorList.isNotEmpty
                ? errorList.first.toString()
                : 'room_number_required'.tr;
          } else {
            errorMessage = 'room_number_required'.tr;
          }
        }

        Dialogs.errorDialog(Get.context!, errorMessage);
        return;
      }

      if (statusCode == 401) {
        timer = Timer(const Duration(seconds: 1), () {
          EasyLoading.dismiss();
        });
        Dialogs.errorDialog(Get.context!, 'token_is_invalid'.tr);
        Get.offAllNamed(Routes.AUTH, arguments: 0);
        return;
      }

      if (statusCode == 404) {
        timer = Timer(const Duration(seconds: 1), () {
          EasyLoading.dismiss();
        });
        if (data is Map<String, dynamic>) {
          if (data['message'] == 'Daklia is not exist') {
            Dialogs.errorDialog(Get.context!, 'daklia_not_exist'.tr);
          } else if (data['message'] == 'Room does not exist') {
            Dialogs.errorDialog(Get.context!, 'room_not_exist'.tr);
          } else {
            Dialogs.errorDialog(Get.context!, 'user_not_exist'.tr);
          }
        } else {
          Dialogs.errorDialog(Get.context!, 'user_not_exist'.tr);
        }
        return;
      }

      if (statusCode == 500) {
        EasyLoading.dismiss();
        Dialogs.errorDialog(Get.context!, 'server_error'.tr);
        return;
      }

      // Fallback for any other unhandled status code
      EasyLoading.dismiss();
      Dialogs.errorDialog(Get.context!, 'server_error'.tr);
    } catch (e) {
      log('Error in editMultipleRoom: $e');
      EasyLoading.dismiss();
      Dialogs.errorDialog(Get.context!, 'network_error'.tr);
    }
  }
}
