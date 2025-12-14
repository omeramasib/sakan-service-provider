import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
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
    request.headers["Accept"] = "application/json";
    request.headers["Content-Type"] = "multipart/form-data";

    // Debug logging
    log('=== DEBUG: Data being sent to API ===');
    log('roomNumber: $roomNumber (type: ${roomNumber.runtimeType})');
    log('roomType: "$roomType" (type: ${roomType.runtimeType})');
    log('pricePerMonth: $pricePerMonth (type: ${pricePerMonth.runtimeType})');
    log('pricePerDay: $pricePerDay (type: ${pricePerDay.runtimeType})');
    log('numberOfBeds: $numberOfBeds (type: ${numberOfBeds.runtimeType})');
    log('numAvailableBeds: $numAvailableBeds (type: ${numAvailableBeds.runtimeType})');
    log('dailyBooking: $dailyBooking (type: ${dailyBooking.runtimeType})');
    log('monthlyBooking: $monthlyBooking (type: ${monthlyBooking.runtimeType})');
    log('roomImage path: ${roomImage?.path}');
    log('===================================');

    // Ensure proper data types and validation
    if (roomNumber == null || roomNumber <= 0) {
      throw Exception('Invalid room number: $roomNumber');
    }
    if (roomType == null || roomType.trim().isEmpty) {
      throw Exception('Room type cannot be empty');
    }
    if (numberOfBeds == null || numberOfBeds <= 0) {
      throw Exception('Invalid number of beds: $numberOfBeds');
    }
    if (numAvailableBeds == null || numAvailableBeds < 0) {
      throw Exception('Invalid available beds: $numAvailableBeds');
    }
    if (pricePerMonth == null || pricePerMonth < 0) {
      throw Exception('Invalid monthly price: $pricePerMonth');
    }
    if (pricePerDay == null || pricePerDay < 0) {
      throw Exception('Invalid daily price: $pricePerDay');
    }

    // Set proper form data with correct types
    request.fields['daklia_id'] = storage.read('dakliaId').toString();
    request.fields['room_number'] = roomNumber.toString();
    request.fields['room_type'] = roomType.trim();
    request.fields['price_per_month'] = pricePerMonth.toString();
    request.fields['price_per_day'] = pricePerDay.toString();
    request.fields['numberOfBeds'] = numberOfBeds.toString();
    request.fields['num_Available_Beds'] = numAvailableBeds.toString();

    // Use the same boolean format as the edit provider
    request.fields['daily_booking'] = dailyBooking.toString();
    request.fields['monthly_booking'] = monthlyBooking.toString();

    // Add file using fromBytes method (similar to daklia verify account)
    try {
      if (roomImage != null && await roomImage.exists()) {
        log('Image file exists: ${roomImage.path}');
        log('Image file size: ${await roomImage.length()} bytes');

        final multipartFile = await http.MultipartFile.fromBytes(
          'room_image',
          roomImage.readAsBytesSync(),
          filename: roomImage.path.split('/').last,
          contentType: MediaType('image', 'jpeg'),
        );
        log('File info: ${multipartFile.filename}, ${multipartFile.contentType}, ${multipartFile.length} bytes');
        request.files.add(multipartFile);
      } else {
        log('Image file does not exist: ${roomImage?.path}');
        throw Exception('Image file is required and must exist');
      }
    } catch (e) {
      log('Error adding file: $e');
      throw Exception('Failed to attach image file: $e');
    }

    // Log what we're actually sending
    log('=== FINAL REQUEST DATA ===');
    log('Fields: ${request.fields}');
    log('Files: ${request.files.map((f) => '${f.field}: ${f.filename}')}');
    log('=========================');

    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    var data = json.decode(responseString);
    var statusCode = response.statusCode;
    log('this is the status code: $statusCode');
    log('this is the response: $responseString');
    log('this is the parsed data: $data');

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
    request.headers["Accept"] = "application/json";
    request.headers["Content-Type"] = "multipart/form-data";
    request.fields['daklia_id'] = storage.read('dakliaId').toString();
    request.fields['room_number'] = roomNumber.toString();
    request.fields['room_type'] = roomType.trim();
    request.fields['daily_booking'] = dailyBooking.toString();
    request.fields['monthly_booking'] = monthlyBooking.toString();
    request.fields['price_per_month'] = pricePerMonth.toString();
    request.fields['price_per_day'] = pricePerDay.toString();
    request.fields['numberOfBeds'] = numberOfBeds.toString();
    request.fields['num_Available_Beds'] = numAvailableBeds.toString();

    // Add file using fromBytes method
    if (roomImage != null && await roomImage.exists()) {
      final multipartFile = await http.MultipartFile.fromBytes(
        'room_image',
        roomImage.readAsBytesSync(),
        filename: roomImage.path.split('/').last,
        contentType: MediaType('image', 'jpeg'),
      );
      request.files.add(multipartFile);
    } else {
      throw Exception('Image file is required and must exist');
    }
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
