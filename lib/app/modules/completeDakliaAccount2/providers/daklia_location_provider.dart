import 'dart:async';
import 'dart:developer';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../../services/secure_storage_service.dart';
import 'package:sakan/app/routes/app_pages.dart';

import '../../../../constants/dialogs.dart';
import '../../../../constants/httpHelper.dart';
import '../model/daklia_location_model.dart';

class DakliaLocationProvider extends GetConnect {
  static DakliaLocationProvider get instance =>
      Get.put(DakliaLocationProvider());
  final SecureStorageService storage = SecureStorageService.instance;
  // var networkController = Get.put(NetworkController());
  Timer? timer;
  @override
  void onInit() {
    EasyLoading.addStatusCallback((status) {
      if (status == EasyLoadingStatus.dismiss) {
        timer?.cancel();
      }
    });
  }

  Future<DakliaLocationModel> sendAddress({
    required String longitude,
    required String latitude,
    required String address,
    required String additonal_address,
  }) async {
    final token = await storage.read('token');
    final userId = await storage.read('userId');
    final response =
        await post(HttpHelper.baseUrl2 + HttpHelper.dakliaLocation, {
      'user_id': userId,
      'longitude': longitude,
      'latitude': latitude,
      'address': address,
      'additional_address': additonal_address,
    }, headers: {
      'Authorization': 'Token $token',
    });
    var data = response.body;
    var statusCode = response.statusCode;
    log('this is the status code: $statusCode');
    log('this is the data: $data');
    if (statusCode == 201) {
      timer = Timer(const Duration(seconds: 1), () {
        EasyLoading.dismiss();
      });
      Get.toNamed(Routes.COMPLETE_DAKLIA_ACCOUNT3);
      Dialogs.successDialog(Get.context!, 'sucsses_add_daklia_location'.tr);
      return DakliaLocationModel.fromJson(data);
    }

    if (statusCode == 400) {
      if (data['user_id'] != null) {
        timer = Timer(const Duration(seconds: 1), () {
          EasyLoading.dismiss();
        });
        Dialogs.errorDialog(Get.context!, 'user_id_already_exist'.tr);
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
    return DakliaLocationModel.fromJson(data);
  }
}
