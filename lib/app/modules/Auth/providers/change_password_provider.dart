import 'dart:async';
import 'dart:developer';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../constants/dialogs.dart';
import '../../../../constants/httpHelper.dart';
import '../../../routes/app_pages.dart';
import '../../network/controllers/network_controller.dart';

class ChangePasswordProvider extends GetConnect {
  static ChangePasswordProvider get instance =>
      Get.put(ChangePasswordProvider());
  GetStorage storage = GetStorage();
  var networkController = NetworkController.instance;
  Timer? timer;
  @override
  void onInit() {
    EasyLoading.addStatusCallback((status) {
      if (status == EasyLoadingStatus.dismiss) {
        timer?.cancel();
      }
    });
  }

  Future<void> updatePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    final response = await put(
      HttpHelper.baseUrl + HttpHelper.changePassword,
      {
        'phone_number': storage.read('phone'),
        'password': oldPassword,
        'new_password': newPassword,
      },
    );
    var data = response.body;
    var statusCode = response.statusCode;
    log('this is the status code: $statusCode');
    log(data.toString());

    if (statusCode == 200) {
      EasyLoading.dismiss();
      Dialogs.successDialog(Get.context!, 'password_changed_successfully'.tr);
      Get.offAllNamed(Routes.HOME);
    }

    if (statusCode == 400) {
      if (data['message'] == 'Wrong password') {
        timer = Timer(const Duration(seconds: 1), () {
          EasyLoading.dismiss();
        });
        Dialogs.errorDialog(Get.context!, 'old_password_not_correct'.tr);
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
