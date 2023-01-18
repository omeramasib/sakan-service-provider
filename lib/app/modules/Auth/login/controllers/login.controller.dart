import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LoginController extends GetxController {

  var loginFormKey = GlobalKey<FormState>();

  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

    // storage insialisations
  GetStorage storage = GetStorage();
  // text field values
  String phone = '';
  String password = '';
  RxInt key = 966.obs;
  var isObscure = true.obs;

   void checkLogin() {
    var isValid = loginFormKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    loginFormKey.currentState!.save();
    Get.offAllNamed('/home');
    // if (networkController.isConnected.value == true) {
    //   EasyLoading.show(status: 'loading'.tr);
    //   register();
    // } else {
    //   Dialogs.connectionErrorDialog(Get.context!);
    // }
    update();
  }

  @override
  void onInit() {
    super.onInit();
    phoneNumberController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    phoneNumberController.dispose();
    passwordController.dispose();
  }

}
