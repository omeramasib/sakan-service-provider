import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {

  var registerFormKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  String? name;
  String? phone;
  String? password;
  String? confirmPassword;

  RxInt key = 966.obs;
  var isObscure = true.obs;
  var isObscureConfirm = true.obs;

    void checkRegister() {
    var isValid = registerFormKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    registerFormKey.currentState!.save();
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
    nameController = TextEditingController();
    phoneNumberController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    nameController.dispose();
    phoneNumberController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }
}
