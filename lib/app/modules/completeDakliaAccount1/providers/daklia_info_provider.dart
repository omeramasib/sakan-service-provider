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
import '../../../routes/app_pages.dart';
import '../models/daklia_info_model.dart';

class DakliaInfoProvider extends GetConnect {
  static DakliaInfoProvider get instance => Get.put(DakliaInfoProvider());
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

  Future<DakliaInfoModel> sendDakliaInfo({
    required File? image,
    required String dakliaDescription,
    required int numberOfRooms,
  }) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      final token = await storage.read('token');
      final userId = await storage.read('userId');
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
          HttpHelper.baseUrl.replaceAll('/user', '/daklia') +
              HttpHelper.dakliaInfo,
        ),
      );
      request.headers["authorization"] = "Token $token";
      request.headers["Accept"] = "application/json";
      request.fields['user_id'] = userId.toString();

      // Check if image file exists and is valid
      if (image != null && await image.exists()) {
        log('Image file exists: ${image.path}');
        log('Image file size: ${await image.length()} bytes');

        // Use fromPath method with proper content type
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          image.path,
          contentType: MediaType('image', 'jpeg'),
        ));
      } else {
        log('Image file does not exist or is null: ${image?.path}');
        throw Exception('Image file is required and must exist');
      }

      // Ensure proper encoding for Arabic text
      String cleanDescription = dakliaDescription.trim();
      log('Original description: $cleanDescription');
      log('Description length: ${cleanDescription.length}');
      log('Description bytes: ${cleanDescription.codeUnits}');

      // Use the description as-is for form data (multipart handles encoding)
      request.fields['description'] = cleanDescription;
      request.fields['number_of_rooms'] = numberOfRooms.toString();

      // Debug logging
      log('Request URL: ${request.url}');
      log('Request headers: ${request.headers}');
      log('Request fields: ${request.fields}');
      log('Request files: ${request.files.map((f) => '${f.field}: ${f.filename} (${f.length} bytes)').toList()}');
      log('Image path: ${image.path}');
      log('Daklia description: $dakliaDescription');
      log('Number of rooms: $numberOfRooms');

      var response = await request.send().timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          EasyLoading.dismiss();
          Dialogs.errorDialog(Get.context!, 'connection_timeout'.tr);
          throw TimeoutException(
              'Request timeout', const Duration(seconds: 30));
        },
      );
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      var data = json.decode(responseString);
      var statusCode = response.statusCode;
      log('this is the status code: $statusCode');
      log('this is the data: $data');
      log('this is the data type: ${data.runtimeType}');

      if (statusCode == 201) {
        log('this is the statusCode : $statusCode');
        timer = Timer(const Duration(seconds: 1), () {
          EasyLoading.dismiss();
        });
        storage.write('dakliaId', data['Daklia_id']?.toString());
        Get.toNamed(Routes.COMPLETE_DAKLIA_ACCOUNT2);
        return DakliaInfoModel.fromJson(data);
      }

      if (statusCode == 400) {
        timer = Timer(const Duration(seconds: 1), () {
          EasyLoading.dismiss();
        });

        String errorMessage = 'validation_error'.tr;

        if (data['message'] == 'Daklia is already exist') {
          errorMessage = 'daklia_already_exist'.tr;
        } else if (data['user_id'] != null) {
          errorMessage = 'user_id_already_exist'.tr;
        } else if (data['daklia_image'] != null || data['image'] != null) {
          // Handle List<dynamic> error format
          var imageError = data['daklia_image'] ?? data['image'];
          if (imageError is List) {
            List errorList = imageError;
            errorMessage = errorList.isNotEmpty
                ? errorList.first.toString()
                : 'daklia_image_required'.tr;
          } else {
            errorMessage = 'daklia_image_required'.tr;
          }
        } else if (data['daklia_description'] != null ||
            data['description'] != null) {
          // Handle List<dynamic> error format
          var descError = data['daklia_description'] ?? data['description'];
          if (descError is List) {
            List errorList = descError;
            errorMessage = errorList.isNotEmpty
                ? errorList.first.toString()
                : 'daklia_description_required'.tr;
          } else {
            errorMessage = 'daklia_description_required'.tr;
          }
        } else if (data['numberOfRooms'] != null ||
            data['number_of_rooms'] != null) {
          // Handle List<dynamic> error format
          var roomError = data['numberOfRooms'] ?? data['number_of_rooms'];
          if (roomError is List) {
            List errorList = roomError;
            errorMessage = errorList.isNotEmpty
                ? errorList.first.toString()
                : 'number_of_rooms_required'.tr;
          } else {
            errorMessage = 'number_of_rooms_required'.tr;
          }
        }

        Dialogs.errorDialog(Get.context!, errorMessage);
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
        Dialogs.errorDialog(Get.context!, 'user_not_exist'.tr);
      }

      if (statusCode == 500 || statusCode == 502 || statusCode == 503) {
        timer = Timer(
          const Duration(seconds: 1),
          () {
            EasyLoading.dismiss();
          },
        );
        Dialogs.errorDialog(Get.context!, 'server_error'.tr);
      }

      // Only try to parse as DakliaInfoModel if it's a successful response
      if (statusCode == 201) {
        return DakliaInfoModel.fromJson(data);
      } else {
        // For error responses, return empty model
        return DakliaInfoModel();
      }
    } catch (e) {
      log('Error in sendDakliaInfo: $e');
      EasyLoading.dismiss();
      Dialogs.errorDialog(Get.context!, 'network_error'.tr);
      return DakliaInfoModel();
    }
  }
}
