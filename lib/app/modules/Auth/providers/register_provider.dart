import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:developer';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../../services/secure_storage_service.dart';
import '../../../helpers/fcm_helper.dart';

import '../../../../constants/dialogs.dart';
import '../../../../constants/httpHelper.dart';
import '../models/register_model.dart';
import '../otp/otp.screen.dart';

class RegisterProvider extends GetConnect {
  static RegisterProvider get instance => Get.put(RegisterProvider());
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

  Future<RegisterModel> register({
    required String dakliaName,
    required String phone,
    required String password,
    required String confirmPassword,
  }) async {
    final response = await post(
      HttpHelper.baseUrl + HttpHelper.register,
      {
        'username': dakliaName,
        'phone_number': phone,
        'password': password,
        'confirm_password': confirmPassword,
        'user_type': '1',
        'is_active': '1',
        'is_staff': '0',
        'is_superuser': '0',
      },
    );
    var data = response.body;
    var statusCode = response.statusCode;
    debugPrint('this is the status code: $statusCode');
    debugPrint('this is the data: $data');
    if (statusCode == 201) {
      timer = Timer(const Duration(seconds: 1), () {
        EasyLoading.dismiss();
      });
      await storage.write('token', data['token'].toString());
      await storage.write('otp', data['otp'].toString());
      await storage.write('phone', data['phone_number'].toString());
      await storage.write('userId', data['id'].toString());
      FCMHelper.instance.updateFCMToken();
      Get.offAll(OtpScreen(), arguments: 1);
      return RegisterModel.fromJson(data);
    }

    if (statusCode == 400) {
      if (data['phone_number'] != null) {
        timer = Timer(const Duration(seconds: 1), () {
          EasyLoading.dismiss();
        });
        Dialogs.errorDialog(Get.context!, 'phone_already_exist'.tr);
      }

      if (data['message'] == 'Phone Number already exists') {
        timer = Timer(const Duration(seconds: 1), () {
          EasyLoading.dismiss();
        });
        Dialogs.errorDialog(Get.context!, 'phone_already_exist'.tr);
      }

      if (data['message'] == 'Username already exist.') {
        timer = Timer(const Duration(seconds: 1), () {
          EasyLoading.dismiss();
        });
        Dialogs.errorDialog(Get.context!, 'user_already_exist'.tr);
      }

      if (data['username'] != null) {
        timer = Timer(const Duration(seconds: 1), () {
          EasyLoading.dismiss();
        });
        Dialogs.errorDialog(Get.context!, 'user_already_exist'.tr);
      }
    }

    if (statusCode == 404) {
      timer = Timer(const Duration(seconds: 1), () {
        EasyLoading.dismiss();
      });
      Dialogs.errorDialog(Get.context!, 'unknown_error'.tr);
    }

    if (statusCode == 500 || statusCode == 502 || statusCode == 503) {
      timer = Timer(const Duration(seconds: 1), () {
        EasyLoading.dismiss();
      });
      EasyLoading.show(status: 'loading'.tr);
      Dialogs.errorDialog(Get.context!, 'server_error'.tr);
    }
    return RegisterModel.fromJson(data);
  }
}
