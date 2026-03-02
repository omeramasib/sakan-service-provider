import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../../services/secure_storage_service.dart';
import 'package:http/http.dart' as http;
import '../../../../constants/dialogs.dart';
import '../../../../constants/httpHelper.dart';
import '../../../routes/app_pages.dart';
import '../../../../core/utils/safe_json_helper.dart';

class UpdateProfileProvider extends GetConnect {
  static UpdateProfileProvider get instance => Get.put(UpdateProfileProvider());
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

  Future<void> updateProfile({
    required File image,
    required String dakliaDescription,
    required int numberOfRooms,
  }) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      EasyLoading.show(status: 'loading'.tr);
      log('this is the image: $image');
      log('this is the daklia description: $dakliaDescription');
      log('this is the number of rooms: $numberOfRooms');
      final token = await storage.read('token');
      final dakliaId = await storage.read('dakliaId');
      int statusCode;
      String responseString;

      if (image.path == '') {
        // Use standard URL-encoded form when no image is updated to avoid Unsupported Media Type
        var response = await http.put(
          Uri.parse(
              '${HttpHelper.baseUrl2}/$dakliaId${HttpHelper.updateProfile}'),
          headers: {
            "authorization": "Token $token",
            "Accept": "application/json",
          },
          body: {
            if (dakliaDescription.isNotEmpty)
              'daklia_description': dakliaDescription,
            'numberOfRooms': numberOfRooms.toString(),
          },
        );
        statusCode = response.statusCode;
        responseString = response.body;
      } else {
        // Use Multipart for image upload
        var request = http.MultipartRequest(
          'PUT',
          Uri.parse(
              '${HttpHelper.baseUrl2}/$dakliaId${HttpHelper.updateProfile}'),
        );
        request.headers["authorization"] = "Token $token";
        request.files.add(
          await http.MultipartFile.fromPath('daklia_image', image.path),
        );
        if (dakliaDescription.isNotEmpty) {
          request.fields['daklia_description'] = dakliaDescription;
        }
        request.fields['numberOfRooms'] = numberOfRooms.toString();

        var response = await request.send();
        var responseData = await response.stream.toBytes();
        responseString = String.fromCharCodes(responseData);
        statusCode = response.statusCode;
      }
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
        Dialogs.successDialog(Get.context!, "success_update_profile".tr);
        Get.offAllNamed(Routes.HOME);
        return;
      }

      if (statusCode == 400 && data is Map<String, dynamic>) {
        log('DEBUG UPDATE_PROFILE ERROR LIST: $data');
        timer = Timer(const Duration(seconds: 1), () {
          EasyLoading.dismiss();
        });

        String errorMessage = 'validation_error'.tr;
        if (data['message'] == 'Daklia is already exist') {
          errorMessage = 'daklia_already_exist'.tr;
        } else if (data['user_id'] != null) {
          errorMessage = "USER ID ERROR: ${data['user_id']}";
        } else if (data['daklia_image'] != null || data['image'] != null) {
          errorMessage =
              "IMAGE ERROR: ${data['daklia_image'] ?? data['image']}";
        } else if (data['daklia_description'] != null ||
            data['description'] != null) {
          errorMessage =
              "DESCRIPTION ERROR: ${data['daklia_description'] ?? data['description']}";
        } else if (data['numberOfRooms'] != null ||
            data['number_of_rooms'] != null) {
          errorMessage =
              "ROOMS ERROR: ${data['numberOfRooms'] ?? data['number_of_rooms']}";
        } else if (data['detail'] != null) {
          errorMessage = "SERVER MESSAGE: ${data['detail']}";
        } else {
          errorMessage = "RAW ERROR: $data";
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
        Dialogs.errorDialog(Get.context!, 'user_not_exist'.tr);
        return;
      }

      if (statusCode == 415) {
        timer = Timer(const Duration(seconds: 1), () {
          EasyLoading.dismiss();
        });
        Dialogs.errorDialog(Get.context!,
            "SERVER MESSAGE: Unsupported Media Type (415)\n$data");
        return;
      }

      if (statusCode == 500 || statusCode == 502 || statusCode == 503) {
        timer = Timer(
          const Duration(seconds: 1),
          () {
            EasyLoading.dismiss();
          },
        );
        Dialogs.errorDialog(Get.context!, 'server_error'.tr);
        return;
      }

      // Fallback for any other unhandled status code
      EasyLoading.dismiss();
      Dialogs.errorDialog(Get.context!, "API ERROR $statusCode: $data");
    } catch (e) {
      log('Error in updateProfile: $e');
      EasyLoading.dismiss();
      Dialogs.errorDialog(Get.context!, 'network_error'.tr);
    }
  }
}
