import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:developer';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../../services/secure_storage_service.dart';
import 'package:sakan/app/modules/Auth/otp/otp.screen.dart';

import '../../../../constants/dialogs.dart';
import '../../../../constants/httpHelper.dart';
import '../models/forget_password_model.dart';

class ForgetPasswordProvider extends GetConnect {
  static ForgetPasswordProvider get instance =>
      Get.put(ForgetPasswordProvider());
  final SecureStorageService storage = SecureStorageService.instance;
  Timer? timer;
  @override
  void onInit() {
    EasyLoading.addStatusCallback((status) {
      if (status == EasyLoadingStatus.dismiss) {
        timer?.cancel();
      }
    });
  }

  Future<ForgetPasswordModel> forgetPassword({
    required String phone,
  }) async {
    final response = await post(
      HttpHelper.baseUrl + HttpHelper.sendOtp,
      {
        'phone_number': phone,
      },
    );
    var data = response.body;
    var statusCode = response.statusCode;
    debugPrint('this is the status code: $statusCode');
    debugPrint('this is the data: $data');

    if (statusCode == 200) {
      timer = Timer(const Duration(seconds: 1), () {
        EasyLoading.dismiss();
      });
      await storage.write('phone', phone);
      Get.to(OtpScreen(), arguments: 0);
      return ForgetPasswordModel.fromJson(data);
    }

    if (statusCode == 400) {
      if (data['message'] == 'User is not active') {
        timer = Timer(const Duration(seconds: 1), () {
          EasyLoading.dismiss();
        });
        Dialogs.errorDialog(Get.context!, 'user_not_active'.tr);
      }
    }

    if (statusCode == 404) {
      if (data['message'] == 'Phone Number does not exist') {
        timer = Timer(const Duration(seconds: 1), () {
          EasyLoading.dismiss();
        });
        Dialogs.errorDialog(Get.context!, 'phone_number_does_not_exist'.tr);
      } else {
        timer = Timer(const Duration(seconds: 1), () {
          EasyLoading.dismiss();
        });
        Dialogs.errorDialog(Get.context!, 'unknown_error'.tr);
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
    return ForgetPasswordModel.fromJson(data);
  }
}
