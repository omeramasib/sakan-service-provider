import 'dart:async';
import 'dart:developer';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../../services/secure_storage_service.dart';

import '../../../../constants/dialogs.dart';
import '../../../../constants/httpHelper.dart';
import '../../../routes/app_pages.dart';
import '../../network/controllers/network_controller.dart';

class LogoutProvider extends GetConnect {
  static LogoutProvider get instance => LogoutProvider.instance;
  var networkController = NetworkController.instance;
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

  Future<void> logout() async {
    String? token = await storage.read('token');
    final response =
        await post(HttpHelper.baseUrl + HttpHelper.logout, {}, headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Token $token',
    });

    var data = response.body;
    log('this is the list of data: $data');
    var statusCode = response.statusCode;
    log('this is the status code: $statusCode');

    if (statusCode == 200) {
      await storage.deleteAll();
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
