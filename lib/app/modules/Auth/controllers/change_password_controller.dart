import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../../services/secure_storage_service.dart';

import '../../../../constants/dialogs.dart';
import '../../network/controllers/network_controller.dart';
import '../providers/change_password_provider.dart';

class ChangePasswordController extends GetxController {
  static ChangePasswordController get instance =>
      Get.put(ChangePasswordController());

  final GlobalKey<FormState> changePasswordFormKey = GlobalKey<FormState>();
  late TextEditingController passwordController,
      confirmPasswordController,
      oldPasswordController;

  var networkController = NetworkController.instance;

  var provider = ChangePasswordProvider.instance;
  // storage insialisations
  final SecureStorageService storage = SecureStorageService.instance;
  // text field values
  String oldPassword = '';
  String newPassword = '';
  String confirmPassword = '';

  Future<void> updatePassword() async {
    return await provider.updatePassword(
      oldPassword: oldPassword,
      newPassword: newPassword,
    );
  }

  void checkUpdatePassword() async {
    var isValid = changePasswordFormKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    changePasswordFormKey.currentState!.save();
    // if (networkController.isConnected.value == true) {
    //   EasyLoading.show(status: 'loading'.tr);
    //   await updatePassword();
    // } else {
    //   Dialogs.connectionErrorDialog(Get.context!);
    // }
    EasyLoading.show(status: 'loading'.tr);
    updatePassword();
    update();
  }

  @override
  void onInit() {
    super.onInit();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    oldPasswordController = TextEditingController();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  var isObscure = true.obs;
  var isObscureNew = true.obs;
  var isObscureConfirm = true.obs;
}
