import 'dart:async';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../../services/secure_storage_service.dart';

import '../../../routes/app_pages.dart';
import '../providers/logout_provider.dart';

class MoreScreenController extends GetxController {
  //TODO: Implement MoreScreenController

  final count = 0.obs;

  RxBool toogleStatus = false.obs;
  void changeToogleStatus(bool value) {
    toogleStatus.value = value;
    update();
  }

  RxBool isLoading = false.obs;
  var provider = LogoutProvider();
  final SecureStorageService storage = SecureStorageService.instance;

  Future<void> submitLogot() async {
    isLoading.value = true;
    EasyLoading.show(status: 'loading'.tr);
    await provider.logout();
    update();
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
