import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../../services/secure_storage_service.dart';
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
  final SecureStorageService storage = SecureStorageService.instance;
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
    required List<File> roomImages,
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
    final token = await storage.read('token');
    final dakliaId = await storage.read('dakliaId');
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
        HttpHelper.baseUrl2 + HttpHelper.addRoom,
      ),
    );
    request.headers["authorization"] = "Token $token";
    request.headers["Accept"] = "application/json";
    request.headers["Content-Type"] = "multipart/form-data";

    // Debug logging
    log('=== DEBUG: Data being sent to API ===');
    log('roomNumber: $roomNumber');
    log('roomType: "$roomType"');
    log('pricePerMonth: $pricePerMonth');
    log('pricePerDay: $pricePerDay');
    log('numberOfBeds: $numberOfBeds');
    log('numAvailableBeds: $numAvailableBeds');
    log('dailyBooking: $dailyBooking');
    log('monthlyBooking: $monthlyBooking');
    log('roomImages count: ${roomImages.length}');
    log('===================================');

    // Ensure proper data types and validation
    if (roomNumber <= 0) {
      throw Exception('Invalid room number: $roomNumber');
    }
    if (roomType.trim().isEmpty) {
      throw Exception('Room type cannot be empty');
    }
    if (numberOfBeds <= 0) {
      throw Exception('Invalid number of beds: $numberOfBeds');
    }
    if (numAvailableBeds < 0) {
      throw Exception('Invalid available beds: $numAvailableBeds');
    }
    if (pricePerMonth < 0) {
      throw Exception('Invalid monthly price: $pricePerMonth');
    }
    if (pricePerDay < 0) {
      throw Exception('Invalid daily price: $pricePerDay');
    }
    if (roomImages.isEmpty) {
      throw Exception('At least one image is required');
    }

    // Set proper form data
    request.fields['daklia_id'] = dakliaId.toString();
    request.fields['room_number'] = roomNumber.toString();
    request.fields['room_type'] = roomType.trim();
    request.fields['price_per_month'] = pricePerMonth.toString();
    request.fields['price_per_day'] = pricePerDay.toString();
    request.fields['numberOfBeds'] = numberOfBeds.toString();
    request.fields['num_Available_Beds'] = numAvailableBeds.toString();
    request.fields['daily_booking'] = dailyBooking.toString();
    request.fields['monthly_booking'] = monthlyBooking.toString();

    // Add multiple images
    try {
      for (int i = 0; i < roomImages.length; i++) {
        final roomImage = roomImages[i];
        if (await roomImage.exists()) {
          log('Adding image ${i + 1}: ${roomImage.path}');
          log('Image file size: ${await roomImage.length()} bytes');

          if (i == 0) {
            // First image as room_image (backward compatible)
            final multipartFile = await http.MultipartFile.fromBytes(
              'room_image',
              roomImage.readAsBytesSync(),
              filename: roomImage.path.split('/').last,
              contentType: MediaType('image', 'jpeg'),
            );
            request.files.add(multipartFile);
          }

          // All images (including first) as images[] array
          final multipartFile = await http.MultipartFile.fromBytes(
            'images[]',
            roomImage.readAsBytesSync(),
            filename: roomImage.path.split('/').last,
            contentType: MediaType('image', 'jpeg'),
          );
          request.files.add(multipartFile);
        } else {
          log('Image file does not exist: ${roomImage.path}');
        }
      }
    } catch (e) {
      log('Error adding files: $e');
      throw Exception('Failed to attach image files: $e');
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
    log('Status code: $statusCode');
    log('Response: $responseString');

    if (statusCode == 201) {
      timer = Timer(const Duration(seconds: 1), () {
        EasyLoading.dismiss();
      });
      storage.write('roomId', data['room_id']?.toString());
      Dialogs.successDialog(Get.context!, 'room_added_successfully'.tr);
      var roomController = Get.put(RoomManagementController());
      roomFeatures(Get.context!);
      roomController.setRooms = DakliaRoomModel.fromJson(data);
      roomController.getRoomFeatures();
      return DakliaRoomModel.fromJson(data);
    }

    if (statusCode == 400) {
      timer = Timer(const Duration(seconds: 1), () {
        EasyLoading.dismiss();
      });
      if (data['message'] == "Daklia account is not verified") {
        Dialogs.errorDialog(Get.context!, 'account_not_verified'.tr);
      } else {
        Dialogs.errorDialog(
            Get.context!, data['message']?.toString() ?? 'Error adding room');
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
      Dialogs.errorDialog(Get.context!, 'daklia_dosent_exist'.tr);
    }

    if (statusCode == 500 || statusCode == 502 || statusCode == 503) {
      timer = Timer(const Duration(seconds: 1), () {
        EasyLoading.dismiss();
      });
      Dialogs.errorDialog(Get.context!, 'server_error'.tr);
    }

    return DakliaRoomModel.fromJson(data);
  }

  Future<DakliaRoomModel> addSingleRoom({
    required List<File> roomImages,
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
    final token = await storage.read('token');
    final dakliaId = await storage.read('dakliaId');
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
        HttpHelper.baseUrl2 + HttpHelper.addRoom,
      ),
    );
    request.headers["authorization"] = "Token $token";
    request.headers["Accept"] = "application/json";
    request.headers["Content-Type"] = "multipart/form-data";
    request.fields['daklia_id'] = dakliaId.toString();
    request.fields['room_number'] = roomNumber.toString();
    request.fields['room_type'] = roomType.trim();
    request.fields['daily_booking'] = dailyBooking.toString();
    request.fields['monthly_booking'] = monthlyBooking.toString();
    request.fields['price_per_month'] = pricePerMonth.toString();
    request.fields['price_per_day'] = pricePerDay.toString();
    request.fields['numberOfBeds'] = numberOfBeds.toString();
    request.fields['num_Available_Beds'] = numAvailableBeds.toString();

    // Add multiple images
    if (roomImages.isEmpty) {
      throw Exception('At least one image is required');
    }

    for (int i = 0; i < roomImages.length; i++) {
      final roomImage = roomImages[i];
      if (await roomImage.exists()) {
        if (i == 0) {
          // First image as room_image (backward compatible)
          final multipartFile = await http.MultipartFile.fromBytes(
            'room_image',
            roomImage.readAsBytesSync(),
            filename: roomImage.path.split('/').last,
            contentType: MediaType('image', 'jpeg'),
          );
          request.files.add(multipartFile);
        }

        // All images as images[] array
        final multipartFile = await http.MultipartFile.fromBytes(
          'images[]',
          roomImage.readAsBytesSync(),
          filename: roomImage.path.split('/').last,
          contentType: MediaType('image', 'jpeg'),
        );
        request.files.add(multipartFile);
      }
    }

    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    var data = json.decode(responseString);
    var statusCode = response.statusCode;
    log('Status code: $statusCode');
    log('Response: $responseString');

    if (statusCode == 201) {
      timer = Timer(const Duration(seconds: 1), () {
        EasyLoading.dismiss();
      });
      var roomController = Get.put(RoomManagementController());
      storage.write('roomId', data['room_id']?.toString());
      Dialogs.successDialog(Get.context!, 'room_added_successfully'.tr);
      roomFeatures(Get.context!);
      roomController.setRooms = DakliaRoomModel.fromJson(data);
      roomController.getRoomFeatures();
      return DakliaRoomModel.fromJson(data);
    }

    if (statusCode == 400) {
      timer = Timer(const Duration(seconds: 1), () {
        EasyLoading.dismiss();
      });
      if (data['message'] == "Daklia account is not verified") {
        Dialogs.errorDialog(Get.context!, 'account_not_verified'.tr);
      } else {
        Dialogs.errorDialog(
            Get.context!, data['message']?.toString() ?? 'Error adding room');
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
      Dialogs.errorDialog(Get.context!, 'daklia_dosent_exist'.tr);
    }

    if (statusCode == 500 || statusCode == 502 || statusCode == 503) {
      timer = Timer(const Duration(seconds: 1), () {
        EasyLoading.dismiss();
      });
      Dialogs.errorDialog(Get.context!, 'server_error'.tr);
    }

    return DakliaRoomModel.fromJson(data);
  }
}
