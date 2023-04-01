import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../model/daklia_profile_model.dart';
import '../provider/daklia_profile_provider.dart';

class DakliaProfileController extends GetxController {
  static DakliaProfileController get instance =>
      Get.put(DakliaProfileController());
  RxList profileList = <DakliaProfileModel>[].obs;
  RxBool isLoading = false.obs;
  var storage = GetStorage();
  var provider = DakliaProfileProvider();
  getDakliaProfile() async {
    isLoading.value = true;
    var data = await provider
        .getProfileInfo(
      storage.read('dakliaId').toString(),
    )
        .timeout(
      const Duration(seconds: 1),
      onTimeout: () {
        EasyLoading.dismiss();
        // Dialogs.connectionErrorDialog(Get.context!);
        isLoading.value = false;
        update();
        // return DakliaProfileModel();
      },
    );
    if (data != null && data is DakliaProfileModel) {
      profileList.add(data);

    }
    isLoading.value = false;
    EasyLoading.dismiss();
    update();
  }

  @override
  void onInit() {
    super.onInit();
    getDakliaProfile();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
