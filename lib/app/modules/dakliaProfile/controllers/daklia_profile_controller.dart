import 'dart:math';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../../services/secure_storage_service.dart';

import '../model/daklia_profile_model.dart';
import '../provider/daklia_profile_provider.dart';

class DakliaProfileController extends GetxController {
  static DakliaProfileController get instance =>
      Get.put(DakliaProfileController());
  RxList profileList = <DakliaProfileModel>[].obs;
  RxBool isLoading = false.obs;
  final SecureStorageService storage = SecureStorageService.instance;
  var provider = DakliaProfileProvider();
  getDakliaProfile() async {
    isLoading.value = true;
    var data = await provider
        .getProfileInfo(
      storage.read('dakliaId').toString(),
    )
        .timeout(
      const Duration(seconds: 3),
      onTimeout: () {
        EasyLoading.dismiss();
        // Dialogs.connectionErrorDialog(Get.context!);
        isLoading.value = false;
        update();
        return DakliaProfileModel();
      },
    );
    if (data != null) {
      profileList.clear();
      profileList.add(data);
    }
    isLoading.value = false;
    EasyLoading.dismiss();
    update();
  }

  @override
  void onInit() async {
    super.onInit();
    await getDakliaProfile();
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
