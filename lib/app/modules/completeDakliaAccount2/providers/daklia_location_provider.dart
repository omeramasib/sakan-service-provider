import 'dart:async';
import 'dart:developer';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sakan/app/routes/app_pages.dart';

import '../../../../constants/dialogs.dart';
import '../../../../constants/httpHelper.dart';
import '../model/daklia_location_model.dart';

class DakliaLocationProvider extends GetConnect {
  static DakliaLocationProvider get instance =>
      Get.put(DakliaLocationProvider());
  GetStorage storage = GetStorage();
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
    required String additonal_address,
  }) async {
    final response = await post(
      HttpHelper.baseUrl2 + HttpHelper.dakliaLocation,
      {
        'user_id': storage.read('userId'),
        'longitude': longitude,
        'latitude': latitude,
        'additional_address': additonal_address,
      },
      headers: {
      'Authorization': 'Token ${storage.read('token')}',
    }
    );
    var data = response.body;
    var statusCode = response.statusCode;
    log('this is the status code: $statusCode');
    log('this is the data: $data');
    if (statusCode == 201) {
      timer = Timer(const Duration(seconds: 1), () {
        EasyLoading.dismiss();
      });
      Get.toNamed(Routes.COMPLETE_DAKLIA_ACCOUNT3);
      return DakliaLocationModel.fromJson(data);
    }

    if (statusCode == 400) {
      if (data['phone_number'] != null) {
        timer = Timer(const Duration(seconds: 1), () {
          EasyLoading.dismiss();
        });
        Dialogs.errorDialog(Get.context!, 'phone_already_exist'.tr);
      }

      if (data['message'] == 'Phone Number already exists') {
        timer = Timer(const Duration(seconds: 1), () {
          EasyLoading.dismiss();
        });
        Dialogs.errorDialog(Get.context!, 'phone_already_exist'.tr);
      }

      if (data['message'] == 'Username already exist.') {
        timer = Timer(const Duration(seconds: 1), () {
          EasyLoading.dismiss();
        });
        Dialogs.errorDialog(Get.context!, 'user_already_exist'.tr);
      }

      if (data['username'] != null) {
        timer = Timer(const Duration(seconds: 1), () {
          EasyLoading.dismiss();
        });
        Dialogs.errorDialog(Get.context!, 'user_already_exist'.tr);
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
