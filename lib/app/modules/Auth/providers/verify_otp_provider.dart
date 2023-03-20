import 'dart:async';
import 'dart:developer';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../constants/dialogs.dart';
import '../../../../constants/httpHelper.dart';
import '../../../routes/app_pages.dart';
import '../models/login_model.dart';
import '../models/verify_otp_model.dart';

class VerifyOtpProvider extends GetConnect {
  static VerifyOtpProvider get instance => Get.put(VerifyOtpProvider());
  GetStorage storage = GetStorage();
  Timer? timer;
  @override
  void onInit() {
    httpClient.baseUrl = HttpHelper.baseUrl;
    EasyLoading.addStatusCallback((status) {
      if (status == EasyLoadingStatus.dismiss) {
        timer?.cancel();
      }
    }
    );
  }

   Future<VerifyOtpModel> verifyOtp(
      // {
      //   required String otp_code,
      // }
      ) async {
    final response = await post(
      HttpHelper.baseUrl + HttpHelper.verifyOtp,
      {
        'phone_number': '+966888888888',
        'otp': '382394',
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
      return VerifyOtpModel.fromJson(data);
    }

    if (statusCode == 400) {

      if(data['message']== 'OTP is incorrect'){
        timer = Timer(const Duration(seconds: 1), () {
          EasyLoading.dismiss();
        });
        Dialogs.errorDialog(Get.context!, 'wrong_otp'.tr);
      }

      if(data['message']== 'User is not active'){
        timer = Timer(const Duration(seconds: 1), () {
          EasyLoading.dismiss();
        }
        );
        Dialogs.errorDialog(Get.context!, 'user_not_active'.tr);
      }

    }

    if(statusCode == 404){
      if (data['message']== 'User does not exist') {
        timer = Timer(const Duration(seconds: 1), () {
          EasyLoading.dismiss();
        });
        Dialogs.errorDialog(Get.context!, 'user_not_exist'.tr);
      }
      else{
        timer = Timer(const Duration(seconds: 1), () {
        EasyLoading.dismiss();
      });
      Dialogs.errorDialog(Get.context!, 'unknown_error'.tr);
      }
    }

    if (statusCode == 500 || statusCode == 502 || statusCode == 503) {
      timer = Timer(const Duration(seconds: 1), () {
        EasyLoading.dismiss();
      },
      );
      EasyLoading.show(status: 'loading'.tr);
      Dialogs.errorDialog(Get.context!, 'server_error'.tr);
    }
    return VerifyOtpModel.fromJson(data);
  }
}