import 'dart:async';
import 'dart:developer';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../constants/dialogs.dart';
import '../../../../constants/httpHelper.dart';
import '../../../routes/app_pages.dart';
import '../models/register_model.dart';

class RegisterProvider extends GetConnect {
  static RegisterProvider get instance => Get.put(RegisterProvider());
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
    }
    );
  }

  Future<RegisterModel> register(
      {
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
      },
    );
    var data = response.body;
    var statusCode = response.statusCode;
    log('this is the status code: $statusCode');
    log('this is the data: $data');
    if (statusCode == 201) {
      timer = Timer(const Duration(seconds: 1), () {
        EasyLoading.dismiss();
      });
      storage.write('token', data['token']);
      Dialogs.successDialog(Get.context!, 'sucsses_register'.tr);
      // Get.offAllNamed(Routes.HOME);
       Get.offAllNamed(Routes.COMPLETE_DAKLIA_ACCOUNT1);
      return RegisterModel.fromJson(data);
    }

    if (statusCode == 400) {
      if(data['phone_number'] == 'Phone number already exist.'){
        timer = Timer(const Duration(seconds: 1), () {
          EasyLoading.dismiss();
        });
        Dialogs.errorDialog(Get.context!, 'phone_number_already_exists'.tr);
      }

      if (data['username']== 'Username already exist.') {
        timer = Timer(const Duration(seconds: 1), () {
          EasyLoading.dismiss();
        });
        Dialogs.errorDialog(Get.context!, 'user_already_exist'.tr);
      }

      else {
        timer = Timer(const Duration(seconds: 1), () {
          EasyLoading.dismiss();
        });
        Dialogs.errorDialog(Get.context!, 'unknown_error'.tr);
      }
    }

    if(statusCode == 404){
      timer = Timer(const Duration(seconds: 1), () {
        EasyLoading.dismiss();
      });
      Dialogs.errorDialog(Get.context!, 'unknown_error'.tr);
    }

    if (statusCode == 500) {
      timer = Timer(const Duration(seconds: 1), () {
        EasyLoading.dismiss();
      });
      EasyLoading.show(status: 'loading'.tr);
      Dialogs.errorDialog(Get.context!, 'server_error'.tr);
    }
  return RegisterModel.fromJson(data);
  }
}