import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
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

  /// Max image size in bytes before compression kicks in (500 KB)
  static const int _maxImageBytes = 500 * 1024;

  @override
  void onInit() {
    httpClient.baseUrl = HttpHelper.baseUrl;
    EasyLoading.addStatusCallback((status) {
      if (status == EasyLoadingStatus.dismiss) {
        timer?.cancel();
      }
    });
  }

  /// Compress image file if it exceeds [_maxImageBytes].
  /// Returns the (possibly compressed) bytes and the filename.
  Future<Uint8List> _compressImageIfNeeded(File imageFile) async {
    final originalBytes = await imageFile.readAsBytes();
    if (originalBytes.length <= _maxImageBytes) {
      print('[compress] Image OK (${originalBytes.length} bytes), no compression needed');
      return originalBytes;
    }
    // Compress with quality 70, then retry at 50 if still too large
    for (final quality in [70, 50, 30]) {
      final compressed = await FlutterImageCompress.compressWithFile(
        imageFile.absolute.path,
        quality: quality,
        minWidth: 1024,
        minHeight: 1024,
      );
      if (compressed != null) {
        print('[compress] Compressed from ${originalBytes.length} to ${compressed.length} bytes (quality=$quality)');
        if (compressed.length <= _maxImageBytes) {
          return Uint8List.fromList(compressed);
        }
      }
    }
    // Return best effort (quality 30 result or original)
    final lastTry = await FlutterImageCompress.compressWithFile(
      imageFile.absolute.path,
      quality: 25,
      minWidth: 800,
      minHeight: 800,
    );
    if (lastTry != null) {
      print('[compress] Final compress: ${lastTry.length} bytes');
      return Uint8List.fromList(lastTry);
    }
    return originalBytes;
  }

  Future<DakliaRoomModel?> addMultipleRoom({
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

    // Add multiple images (compressed)
    try {
      for (int i = 0; i < roomImages.length; i++) {
        final roomImage = roomImages[i];
        if (await roomImage.exists()) {
          final compressedBytes = await _compressImageIfNeeded(roomImage);
          final filename = roomImage.path.split('/').last;
          log('Adding image ${i + 1}: $filename (${compressedBytes.length} bytes after compression)');

          if (i == 0) {
            // First image as room_image (backward compatible)
            request.files.add(http.MultipartFile.fromBytes(
              'room_image',
              compressedBytes,
              filename: filename,
              contentType: MediaType('image', 'jpeg'),
            ));
          }

          // All images (including first) as images[] array
          request.files.add(http.MultipartFile.fromBytes(
            'images[]',
            compressedBytes,
            filename: filename,
            contentType: MediaType('image', 'jpeg'),
          ));
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

    // ========== DEBUG: Full request details ==========
    print('========== [addMultipleRoom] REQUEST ==========');
    print('URL: ${request.url}');
    print('Method: ${request.method}');
    print('Headers: ${request.headers}');
    print('Fields: ${request.fields}');
    print('Files: ${request.files.map((f) => '${f.field}: ${f.filename} (${f.length} bytes)').toList()}');
    print('================================================');

    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    var statusCode = response.statusCode;

    // ========== DEBUG: Full response details ==========
    print('========== [addMultipleRoom] RESPONSE ==========');
    print('Status code: $statusCode');
    print('Response headers: ${response.headers}');
    print('Response body (first 2000 chars): ${responseString.length > 2000 ? responseString.substring(0, 2000) : responseString}');
    print('Response body length: ${responseString.length}');
    print('=================================================');

    Map<String, dynamic>? data;
    if (responseString.trim().isNotEmpty &&
        !responseString.trim().toLowerCase().startsWith('<')) {
      try {
        final decoded = json.decode(responseString);
        data = decoded is Map<String, dynamic> ? decoded : null;
      } catch (e) {
        print('[addMultipleRoom] JSON parse error: $e');
      }
    } else {
      print('[addMultipleRoom] Response is HTML or empty, not JSON');
    }

    if (statusCode == 201 && data != null) {
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
      if (data != null) {
        if (data['message'] == "Daklia account is not verified") {
          Dialogs.errorDialog(Get.context!, 'account_not_verified'.tr);
        } else {
          Dialogs.errorDialog(
              Get.context!, data['message']?.toString() ?? 'Error adding room');
        }
      } else {
        Dialogs.errorDialog(Get.context!, 'validation_error'.tr);
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

    if (statusCode == 413) {
      timer = Timer(const Duration(seconds: 1), () {
        EasyLoading.dismiss();
      });
      Dialogs.errorDialog(Get.context!, 'image_too_large'.tr);
    }

    if (statusCode == 500 || statusCode == 502 || statusCode == 503) {
      timer = Timer(const Duration(seconds: 1), () {
        EasyLoading.dismiss();
      });
      Dialogs.errorDialog(Get.context!, 'server_error'.tr);
    }

    if (data == null) {
      EasyLoading.dismiss();
    }
    return null;
  }

  Future<DakliaRoomModel?> addSingleRoom({
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

    // Add multiple images (compressed)
    if (roomImages.isEmpty) {
      throw Exception('At least one image is required');
    }

    for (int i = 0; i < roomImages.length; i++) {
      final roomImage = roomImages[i];
      if (await roomImage.exists()) {
        final compressedBytes = await _compressImageIfNeeded(roomImage);
        final filename = roomImage.path.split('/').last;
        log('Adding image ${i + 1}: $filename (${compressedBytes.length} bytes after compression)');

        if (i == 0) {
          // First image as room_image (backward compatible)
          request.files.add(http.MultipartFile.fromBytes(
            'room_image',
            compressedBytes,
            filename: filename,
            contentType: MediaType('image', 'jpeg'),
          ));
        }

        // All images as images[] array
        request.files.add(http.MultipartFile.fromBytes(
          'images[]',
          compressedBytes,
          filename: filename,
          contentType: MediaType('image', 'jpeg'),
        ));
      }
    }

    // ========== DEBUG: Full request details ==========
    print('========== [addSingleRoom] REQUEST ==========');
    print('URL: ${request.url}');
    print('Method: ${request.method}');
    print('Headers: ${request.headers}');
    print('Fields: ${request.fields}');
    print('Files: ${request.files.map((f) => '${f.field}: ${f.filename} (${f.length} bytes)').toList()}');
    print('==============================================');

    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    var statusCode = response.statusCode;

    // ========== DEBUG: Full response details ==========
    print('========== [addSingleRoom] RESPONSE ==========');
    print('Status code: $statusCode');
    print('Response headers: ${response.headers}');
    print('Response body (first 2000 chars): ${responseString.length > 2000 ? responseString.substring(0, 2000) : responseString}');
    print('Response body length: ${responseString.length}');
    print('================================================');

    Map<String, dynamic>? data;
    if (responseString.trim().isNotEmpty &&
        !responseString.trim().toLowerCase().startsWith('<')) {
      try {
        final decoded = json.decode(responseString);
        data = decoded is Map<String, dynamic> ? decoded : null;
      } catch (e) {
        print('[addSingleRoom] JSON parse error: $e');
      }
    } else {
      print('[addSingleRoom] Response is HTML or empty, not JSON');
    }

    if (statusCode == 201 && data != null) {
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
      if (data != null) {
        if (data['message'] == "Daklia account is not verified") {
          Dialogs.errorDialog(Get.context!, 'account_not_verified'.tr);
        } else {
          Dialogs.errorDialog(
              Get.context!, data['message']?.toString() ?? 'Error adding room');
        }
      } else {
        Dialogs.errorDialog(Get.context!, 'validation_error'.tr);
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

    if (statusCode == 413) {
      timer = Timer(const Duration(seconds: 1), () {
        EasyLoading.dismiss();
      });
      Dialogs.errorDialog(Get.context!, 'image_too_large'.tr);
    }

    if (statusCode == 500 || statusCode == 502 || statusCode == 503) {
      timer = Timer(const Duration(seconds: 1), () {
        EasyLoading.dismiss();
      });
      Dialogs.errorDialog(Get.context!, 'server_error'.tr);
    }

    if (data == null) {
      EasyLoading.dismiss();
    }
    return null;
  }
}
