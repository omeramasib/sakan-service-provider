import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../../services/secure_storage_service.dart';

import '../../../../constants/dialogs.dart';
import '../../../../constants/httpHelper.dart';
import '../../../routes/app_pages.dart';
import '../../network/controllers/network_controller.dart';
import '../model/daklia_profile_model.dart';

class DakliaProfileProvider extends GetConnect {
  var networkController = NetworkController.instance;
  static DakliaProfileProvider get instance => Get.put(DakliaProfileProvider());
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

  Future getProfileInfo(String? id) async {
    try {
      final token = await storage.read('token');
      final response = await get(
          HttpHelper.baseUrl.replaceAll('/user', '/daklia') +
              HttpHelper.dakliaProfile +
              '$id',
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Token $token',
          }).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          EasyLoading.dismiss();
          Dialogs.errorDialog(Get.context!, 'connection_timeout'.tr);
          throw TimeoutException(
              'Request timeout', const Duration(seconds: 30));
        },
      );

      var data = response.body;
      var statusCode = response.statusCode;
      log('this is the status code: $statusCode');
      log('Profile data: $data');
      if (statusCode == 200) {
        timer = Timer(const Duration(seconds: 1), () {
          EasyLoading.dismiss();
          storage.write('locationId', data['location_id']?.toString());
        });
        return DakliaProfileModel.fromJson(data);
      }

      if (statusCode == 401) {
        timer = Timer(const Duration(seconds: 1), () {
          EasyLoading.dismiss();
        });
        Dialogs.errorDialog(Get.context!, 'token_is_invalid'.tr);
        Get.offAllNamed(Routes.AUTH, arguments: 0);
      }
      if (statusCode == 500 || statusCode == 502 || statusCode == 503) {
        timer = Timer(const Duration(seconds: 1), () {
          EasyLoading.dismiss();
        });

        // Check if it's the specific daklia_image error
        if (data.toString().contains('daklia_image') &&
            data.toString().contains('no file associated')) {
          Dialogs.errorDialog(Get.context!, 'profile_image_missing'.tr);
        } else {
          Dialogs.errorDialog(Get.context!, 'server_error'.tr);
        }
      }

      if (statusCode == 404) {
        timer = Timer(const Duration(seconds: 1), () {
          EasyLoading.dismiss();
        });
        Dialogs.errorDialog(Get.context!, 'user_not_exist'.tr);
      }

      return null;
    } catch (e) {
      log('Error in getProfileInfo: $e');
      EasyLoading.dismiss();
      Dialogs.errorDialog(Get.context!, 'network_error'.tr);
      return null;
    }
  }
}
