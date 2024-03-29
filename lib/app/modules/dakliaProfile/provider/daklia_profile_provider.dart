import 'dart:async';
import 'dart:developer';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../constants/dialogs.dart';
import '../../../../constants/httpHelper.dart';
import '../../../routes/app_pages.dart';
import '../../network/controllers/network_controller.dart';
import '../model/daklia_profile_model.dart';

class DakliaProfileProvider extends GetConnect {
  var networkController = NetworkController.instance;
  static DakliaProfileProvider get instance => Get.put(DakliaProfileProvider());
  GetStorage storage = GetStorage();
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
    final response = await get(
        HttpHelper.baseUrl2 + HttpHelper.dakliaProfile + '$id',
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Token ${storage.read('token')}',
        });

    var data = response.body;
    var statusCode = response.statusCode;
    log('this is the status code: $statusCode');
    log(data.toString());
    if (statusCode == 200) {
      timer = Timer(const Duration(seconds: 1), () {
        EasyLoading.dismiss();
        storage.write('locationId', data['location_id']);
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
      Dialogs.errorDialog(Get.context!, 'server_error'.tr);
    }

    if (statusCode == 404) {
      timer = Timer(const Duration(seconds: 1), () {
        EasyLoading.dismiss();
      });
      Dialogs.errorDialog(Get.context!, 'user_not_exist'.tr);
    }
  }
}
