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
  var provider = DakliaProfileProvider.instance;
  getDakliaProfile() async {
    isLoading.value = true;
    final dakliaIdRaw = await storage.read('dakliaId');

    // Check if dakliaId is null or empty
    if (dakliaIdRaw == null || dakliaIdRaw.isEmpty) {
      print('DEBUG: dakliaId is null or empty, cannot fetch profile');
      isLoading.value = false;
      update();
      return;
    }

    final dakliaId = dakliaIdRaw.toString();
    print('DEBUG: Fetching daklia profile for ID: $dakliaId');

    var data = await provider.getProfileInfo(dakliaId).timeout(
      const Duration(seconds: 30),
      onTimeout: () {
        print('DEBUG: getDakliaProfile timeout after 30 seconds');
        EasyLoading.dismiss();
        isLoading.value = false;
        update();
        return null;
      },
    );

    print('DEBUG: getDakliaProfile response: $data');

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
