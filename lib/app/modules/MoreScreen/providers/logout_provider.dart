import 'dart:async';
import 'dart:developer';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../constants/dialogs.dart';
import '../../../../constants/httpHelper.dart';
import '../../../routes/app_pages.dart';
import '../../network/controllers/network_controller.dart';

class LogoutProvider extends GetConnect {
  static LogoutProvider get instance => LogoutProvider.instance;
  var networkController = NetworkController.instance;
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

  Future<void> logout() async {
    final response =
        await post(HttpHelper.baseUrl + HttpHelper.logout, {}, headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Token ${storage.read('token')}',
    });

    var data = response.body;
    log('this is the list of data: $data');
    var statusCode = response.statusCode;
    log('this is the status code: $statusCode');

    if (statusCode == 200) {
      storage.remove('token');
      EasyLoading.dismiss();
      Get.offAllNamed(Routes.AUTH, arguments: 0);
    }

    if (statusCode == 401) {
      timer = Timer(const Duration(seconds: 1), () {
        EasyLoading.dismiss();
      });
      Dialogs.errorDialog(Get.context!, "invalid_token.".tr);
      Get.offAllNamed(Routes.AUTH, arguments: 0);
    }
  }
}
