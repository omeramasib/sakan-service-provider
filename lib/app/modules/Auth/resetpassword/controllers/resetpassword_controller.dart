import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sakan/app/modules/Auth/login/login.screen.dart';
import 'package:sakan/app/routes/app_pages.dart';

import '../../login/login.screen.dart';
import '../../login/login.screen.dart';

class ResetpasswordController extends GetxController {
  final GlobalKey<FormState> resetPasswordFormKey = GlobalKey<FormState>();
  // var resetPasswordProvider = Get.put(ResetPasswordProvider());
  // var networkController = Get.put(NetworkController());
  var storage = GetStorage();
  late TextEditingController passwordController,
      confirmPasswordController,
      otpController,
      newPasswordController;
  String newPassword = '';
  String confirmPassword = '';
  var isObscure = true.obs;
  var isObscureConfirm = true.obs;
  // Future resetPassword() async {
  //   await resetPasswordProvider.resetPassword(
  //     phone: storage.read('phone'),
  //     code: storage.read('code').toString(),
  //     newPassword: newPassword,
  //     confirmPassword: confirmPassword,
  //   );
  // }

  checkResetPassword() async {
    var isValid = resetPasswordFormKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    resetPasswordFormKey.currentState!.save();
    Get.offAllNamed(Routes.AUTH, arguments: 0);
    // if (networkController.isConnected.value == true) {
    //   EasyLoading.show(status: 'loading'.tr);
    //   await resetPassword(); 
    // } else {
    //   Dialogs.connectionErrorDialog(Get.context!);
    // }
    // update();
  }

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
    super.onClose();
  }
}
