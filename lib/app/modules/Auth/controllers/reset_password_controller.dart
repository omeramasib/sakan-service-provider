import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../../services/secure_storage_service.dart';
import 'package:sakan/app/modules/Auth/providers/reset_password_provider.dart';

import '../../../../constants/dialogs.dart';

class ResetpasswordController extends GetxController {
  final GlobalKey<FormState> resetPasswordFormKey = GlobalKey<FormState>();

  final SecureStorageService storage = SecureStorageService.instance;
  var resetPasswordPr = ResetPasswordProvider();
  late TextEditingController passwordController,
      confirmPasswordController,
      otpController,
      newPasswordController;
  String newPassword = '';
  String confirmPassword = '';
  var isObscure = true.obs;
  var isObscureNew = true.obs;
  var isObscureConfirm = true.obs;

  Future<void> resetPassword() async {
    return await resetPasswordPr
        .resetPassword(
      password: newPassword,
    )
        .timeout(
      Duration(seconds: 1),
      onTimeout: () {
        EasyLoading.dismiss();
        return;
      },
    );
  }

  checkResetPassword() {
    var isValid = resetPasswordFormKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    resetPasswordFormKey.currentState!.save();
    // if (networkController.isConnected.value == true) {
    //   EasyLoading.show(status: 'loading'.tr);
    //   login();
    // } else {
    //   Dialogs.connectionErrorDialog(Get.context!);
    // }
    EasyLoading.show(status: 'loading'.tr);
    resetPassword();
    update();
  }
  // Future resetPassword() async {
  //   await resetPasswordProvider.resetPassword(
  //     phone: storage.read('phone'),
  //     code: storage.read('code').toString(),
  //     newPassword: newPassword,
  //     confirmPassword: confirmPassword,
  //   );
  // }

  // checkResetPassword() async {
  //   var isValid = resetPasswordFormKey.currentState!.validate();
  //   if (!isValid) {
  //     return;
  //   }
  //   resetPasswordFormKey.currentState!.save();
  //   Get.offAllNamed(Routes.AUTH, arguments: 0);
  //   // if (networkController.isConnected.value == true) {
  //   //   EasyLoading.show(status: 'loading'.tr);
  //   //   await resetPassword();
  //   // } else {
  //   //   Dialogs.connectionErrorDialog(Get.context!);
  //   // }
  //   // update();
  // }

  @override
  void onInit() {
    super.onInit();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    otpController = TextEditingController();
    newPasswordController = TextEditingController();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    otpController.dispose();
    newPasswordController.dispose();
    super.onClose();
  }
}
