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

class LoginProvider extends GetConnect {
  static LoginProvider get instance => Get.put(LoginProvider());
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

  Future<LoginModel> loginUser({
    required String phone,
    required String password,
  }) async {
    final response = await post(
      HttpHelper.baseUrl + HttpHelper.login,
      {
        'phone_number': phone,
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
      });
      // storage.write('otp', data['otp']);
      storage.write('token', data['token']);
      // storage.write('phone', data['phone_number']);
      storage.write('userId', data['id']);

      if (data['user_type'] == 1) {
        Get.offAllNamed(Routes.HOME);
        Dialogs.successDialog(Get.context!, 'login_success'.tr);
      }
      if (data['user_type'] == 0 || data['user_type'] == 2) {
        Dialogs.errorDialog(Get.context!, 'user_not_allowed'.tr);
      }
      return LoginModel.fromJson(data);
    }

    if (statusCode == 400) {
      if (data['message'] == 'Wrong password') {
        timer = Timer(const Duration(seconds: 1), () {
          EasyLoading.dismiss();
        });
        Dialogs.errorDialog(Get.context!, 'login_failed'.tr);
      }

      if (data['message'] == 'Account does not verified') {
        timer = Timer(const Duration(seconds: 1), () {
          EasyLoading.dismiss();
        });
        storage.write('phone', phone);
        Dialogs.errorDialog(Get.context!, 'user_not_verified'.tr);
        Get.to(OtpScreen(), arguments: 2);
      }
    }

    if (statusCode == 401) {
      if (data['message'] == 'Account does not active') {
        timer = Timer(const Duration(seconds: 1), () {
          EasyLoading.dismiss();
        });
        Dialogs.errorDialog(Get.context!, 'user_not_active'.tr);
      }
    }

    if (statusCode == 404) {
      if (data['message'] == 'User does not exist') {
        timer = Timer(const Duration(seconds: 1), () {
          EasyLoading.dismiss();
        });
        Dialogs.errorDialog(Get.context!, 'user_not_exist'.tr);
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
    return LoginModel.fromJson(data);
  }
}
