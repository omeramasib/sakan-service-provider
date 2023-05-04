import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../../../constants/dialogs.dart';
import '../../../../constants/httpHelper.dart';
import '../../../../widgets/room_management/room_features/room_features.dart';
import '../../../routes/app_pages.dart';
import '../controllers/room_management_controller.dart';
import '../models/add_room_model.dart';
import '../models/daklia_rooms_models.dart';

class AddRoomProvider extends GetConnect {
  static AddRoomProvider get instance => Get.put(AddRoomProvider());
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

  Future<DakliaRoomModel> addMultipleRoom({
    required File? roomImage,
    required int roomNumber,
    required String roomType,
    required int pricePerMonth,
    required int pricePerDay,
    required int numberOfBeds,
    required int numAvailableBeds,
    required bool dailyBooking,
    required bool monthlyBooking,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
        HttpHelper.baseUrl2 + HttpHelper.addRoom,
      ),
    );
    request.headers["authorization"] = "Token ${storage.read('token')}";
    request.fields['daklia_id'] = storage.read('dakliaId').toString();
    request.fields['room_number'] = roomNumber.toString();
    request.files.add(await http.MultipartFile.fromPath(
      'room_image',
      roomImage!.path,
    ));
    request.fields['room_type'] = roomType;
    request.fields['price_per_month'] = pricePerMonth.toString();
    request.fields['price_per_day'] = pricePerDay.toString();
    request.fields['numberOfBeds'] = numberOfBeds.toString();
    request.fields['num_Available_Beds'] = numAvailableBeds.toString();
    request.fields['daily_booking'] = dailyBooking.toString();
    request.fields['monthly_booking'] = monthlyBooking.toString();
    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    var data = json.decode(responseString);
    var statusCode = response.statusCode;
    log('this is the status code: $statusCode');
    log('this is the data: $data');

    if (statusCode == 201) {
      log('this is the statusCode : $statusCode');
      timer = Timer(const Duration(seconds: 1), () {
        EasyLoading.dismiss();
      });
      storage.write('roomId', data['room_id']);
      Dialogs.successDialog(Get.context!, 'room_added_successfully'.tr);
      var roomController = Get.put(RoomManagementController());
      roomFeatures(Get.context!);
      roomController.setRooms = DakliaRoomModel.fromJson(data);
      roomController.getRoomFeatures();
      return DakliaRoomModel.fromJson(data);
    }

    if (statusCode == 400) {
      if (data['message'] != "Daklia account is not verified") {
        timer = Timer(const Duration(seconds: 1), () {
          EasyLoading.dismiss();
        });
        Dialogs.errorDialog(Get.context!, 'account_not_verified'.tr);
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
      if (data['message'] != 'Daklia does not exis') {
        timer = Timer(const Duration(seconds: 1), () {
          EasyLoading.dismiss();
        });
        Dialogs.errorDialog(Get.context!, 'daklia_dosent_exist'.tr);
      }
    }

    if (statusCode == 500 || statusCode == 502 || statusCode == 503) {
      timer = Timer(
        const Duration(seconds: 1),
        () {
          EasyLoading.dismiss();
        },
      );
      EasyLoading.show(status: 'loading'.tr);
      Dialogs.errorDialog(Get.context!, 'server_error'.tr);
    }
    return DakliaRoomModel.fromJson(data);
  }

  Future<DakliaRoomModel> addSingleRoom({
    required File? roomImage,
    required int roomNumber,
    required String roomType,
    required int pricePerMonth,
    required bool dailyBooking,
    required bool monthlyBooking,
    required int pricePerDay,
    required int numberOfBeds,
    required int numAvailableBeds,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
        HttpHelper.baseUrl2 + HttpHelper.addRoom,
      ),
    );
    request.headers["authorization"] = "Token ${storage.read('token')}";
    request.fields['daklia_id'] = storage.read('dakliaId').toString();
    request.fields['room_number'] = roomNumber.toString();
    request.files.add(await http.MultipartFile.fromPath(
      'room_image',
      roomImage!.path,
    ));
    request.fields['room_type'] = roomType;
    request.fields['daily_booking'] = dailyBooking.toString();
    request.fields['monthly_booking'] = monthlyBooking.toString();
    request.fields['price_per_month'] = pricePerMonth.toString();
    request.fields['price_per_day'] = pricePerDay.toString();
    request.fields['numberOfBeds'] = numberOfBeds.toString();
    request.fields['num_Available_Beds'] = numAvailableBeds.toString();
    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    var data = json.decode(responseString);
    var statusCode = response.statusCode;
    log('this is the status code: $statusCode');
    log('this is the data: $data');

    if (statusCode == 201) {
      log('this is the statusCode : $statusCode');
      timer = Timer(const Duration(seconds: 1), () {
        EasyLoading.dismiss();
      });
      var roomController = Get.put(RoomManagementController());
      storage.write('roomId', data['room_id']);
      Dialogs.successDialog(Get.context!, 'room_added_successfully'.tr);
      roomFeatures(Get.context!);
      roomController.setRooms = DakliaRoomModel.fromJson(data);
      roomController.getRoomFeatures();
      return DakliaRoomModel.fromJson(data);
    }

    if (statusCode == 400) {
      if (data['message'] != "Daklia account is not verified") {
        timer = Timer(const Duration(seconds: 1), () {
          EasyLoading.dismiss();
        });
        Dialogs.errorDialog(Get.context!, 'account_not_verified'.tr);
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
      if (data['message'] != 'Daklia does not exis') {
        timer = Timer(const Duration(seconds: 1), () {
          EasyLoading.dismiss();
        });
        Dialogs.errorDialog(Get.context!, 'daklia_dosent_exist'.tr);
      }
    }

    if (statusCode == 500 || statusCode == 502 || statusCode == 503) {
      timer = Timer(
        const Duration(seconds: 1),
        () {
          EasyLoading.dismiss();
        },
      );
      EasyLoading.show(status: 'loading'.tr);
      Dialogs.errorDialog(Get.context!, 'server_error'.tr);
    }
    return DakliaRoomModel.fromJson(data);
  }
}
