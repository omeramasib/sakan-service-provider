import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../../../constants/dialogs.dart';
import '../../../../constants/httpHelper.dart';
import '../../../routes/app_pages.dart';

class EditMultipleRoomProvider extends GetConnect {
  static EditMultipleRoomProvider get instance =>
      Get.put(EditMultipleRoomProvider());
  GetStorage storage = GetStorage();
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
    await Future.delayed(const Duration(seconds: 1));
    EasyLoading.show(status: 'loading'.tr);
    // log('this is the image: $image');
    // log('this is the roomNumber: $roomNumber');
    // log('this is the numberOfBeds: $numberOfBeds');
    // log('this is the numberOfAvailableBeds: $numberOfAvailableBeds');
    // log('this is the dailyBooking: $dailyBooking');
    // log('this is the monthlyBooking: $monthlyBooking');
    // log('this is the pricePerDay: $pricePerDay');
    // log('this is the pricePerMonth: $pricePerMonth');
    // log('this is the roomId: $roomId');

    var request = http.MultipartRequest(
      'PUT',
      Uri.parse(
          '${HttpHelper.baseUrl2}/${storage.read('dakliaId')}${HttpHelper.rooms}$roomId/'),
    );
    log('this is the request: $request');
    request.headers["authorization"] = "Token ${storage.read('token')}";
    if (image.path != '') {
      request.files.add(
        await http.MultipartFile.fromPath(
          'room_image',
          image.path,
        ),
      );
    } else {
      request.fields['room_image'] = '';
    }
    request.fields['room_number'] = roomNumber.toString();
    request.fields['numberOfBeds'] = numberOfBeds.toString();
    request.fields['num_Available_Beds'] = numberOfAvailableBeds.toString();
    request.fields['daily_booking'] = dailyBooking.toString();
    request.fields['monthly_booking'] = monthlyBooking.toString();
    request.fields['price_per_day'] = pricePerDay.toString();
    request.fields['price_per_month'] = pricePerMonth.toString();
    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    var data = json.decode(responseString);
    var statusCode = response.statusCode;

    log('this is the status code: $statusCode');
    log('this is the data: $data');
    EasyLoading.show(status: 'loading'.tr);

    if (statusCode == 200) {
      log('this is the statusCode : $statusCode');
      timer = Timer(const Duration(seconds: 1), () {
        EasyLoading.dismiss();
      });
      Dialogs.successDialog(Get.context!, "success_update_room_information".tr);
      Get.offAllNamed(Routes.HOME);
    }

    if (statusCode == 400) {
      if (data['message'] != 'Daklia is already exist') {
        timer = Timer(const Duration(seconds: 1), () {
          EasyLoading.dismiss();
        });
        Dialogs.errorDialog(Get.context!, 'user_id_already_exist'.tr);
      }

      if (data['user_id'] != null) {
        timer = Timer(const Duration(seconds: 1), () {
          EasyLoading.dismiss();
        });
        Dialogs.errorDialog(Get.context!, 'user_id_already_exist'.tr);
      }
      if (data['daklia_image'] != null) {
        timer = Timer(const Duration(seconds: 1), () {
          EasyLoading.dismiss();
        });
        Dialogs.errorDialog(Get.context!, 'daklia_image_required'.tr);
      }

      if (data['daklia_description'] != null) {
        timer = Timer(const Duration(seconds: 1), () {
          EasyLoading.dismiss();
        });
        Dialogs.errorDialog(Get.context!, 'daklia_description_required'.tr);
      }
    }

    if (statusCode == 401) {
      timer = Timer(const Duration(seconds: 1), () {
        EasyLoading.dismiss();
      });
      Dialogs.errorDialog(Get.context!, 'token_is_invalid'.tr);
      Get.offAllNamed(Routes.AUTH, arguments: 0);
    }

    if (statusCode == 404) {
      timer = Timer(const Duration(seconds: 1), () {
        EasyLoading.dismiss();
      });
      if (data['message'] == 'Daklia is not exist') {
        Dialogs.errorDialog(Get.context!, 'daklia_not_exist'.tr);
      } else if (data['message'] == 'Room does not exist') {
        Dialogs.errorDialog(Get.context!, 'room_not_exist'.tr);
      }
    }

    if (statusCode == 500) {
      EasyLoading.dismiss();
      EasyLoading.show(status: 'loading'.tr);
      Dialogs.errorDialog(Get.context!, 'server_error'.tr);
    }
  }
}
