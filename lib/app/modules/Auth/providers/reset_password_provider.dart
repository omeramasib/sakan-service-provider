import 'dart:async';
import 'dart:developer';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sakan/app/modules/Auth/otp/otp.screen.dart';

import '../../../../constants/dialogs.dart';
import '../../../../constants/httpHelper.dart';
import '../../../routes/app_pages.dart';
import '../models/login_model.dart';

class ResetPasswordProvider extends GetConnect {
  static ResetPasswordProvider get instance => Get.put(ResetPasswordProvider());
  GetStorage storage = GetStorage();

  Timer? timer;
  @override
  void onInit() {
    EasyLoading.addStatusCallback((status) {
      if (status == EasyLoadingStatus.dismiss) {
        timer?.cancel();
      }
    });
  }

  Future<void> resetPassword({
    required String password,
  }) async {
    final response = await put(
      HttpHelper.baseUrl + HttpHelper.resetPassword,
      {
        'phone_number': storage.read('phone'),
        'password': password,
      },
    );
    var data = response.body;
    var statusCode = response.statusCode;
    log('this is the status code: $statusCode');
    log('this is the data: $data');

    if (statusCode == 200) {
      timer = Timer(const Duration(seconds: 1), () {
        EasyLoading.dismiss();
        Dialogs.successDialog(Get.context!, 'password_changed_successfully'.tr);
        Get.offAllNamed(Routes.AUTH, arguments: 0);
      });

      if (data['user_type'] == 1) {
        Dialogs.successDialog(Get.context!, 'password_changed_successfully'.tr);
        Get.offAllNamed(Routes.AUTH, arguments: 0);
      }
      if (data['user_type'] == 0) {
        Dialogs.errorDialog(Get.context!, 'user_not_allowed'.tr);
      }

    }

    if (statusCode == 400) {
      if (data['message'] == 'Password is same as old password') {
        timer = Timer(const Duration(seconds: 1), () {
          EasyLoading.dismiss();
        });
        Dialogs.errorDialog(Get.context!, 'password_cant_be_as_old_one'.tr);
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

  }
}
