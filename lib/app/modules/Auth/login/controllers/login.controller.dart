import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../../constants/dialogs.dart';
import '../../../network/controllers/network_controller.dart';
import '../../models/login_model.dart';
import '../../providers/login_provider.dart';
import '../../providers/register_provider.dart';

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

  var loginProvider = LoginProvider();


  var networkController = NetworkController();

    Future<LoginModel> login() async {
    return await loginProvider.loginUser(
      phone: phone,
      password: password,
    );

    }

   void checkLogin() {
    var isValid = loginFormKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    loginFormKey.currentState!.save();
    // if (networkController.isConnected.value == true) {
    //   EasyLoading.show(status: 'loading'.tr);
    //   login();
    // } else {
    //   Dialogs.connectionErrorDialog(Get.context!);
    // }
    login();
    update();
  }


  //   var registerProvider = RegisterProvider();

  // var networkController = NetworkController();

  // Future<RegisterModel> register() async {
  //   return await registerProvider.register(
  //     dakliaName: username,
  //     phone: phone,
  //     password: password,
  //     confirmPassword: confirmPassword,
  //   );
  // }

  //   void checkRegister() {
  //   var isValid = registerFormKey.currentState!.validate();
  //   if (!isValid) {
  //     return;
  //   }
  //   registerFormKey.currentState!.save();
  //   // if (networkController.isConnected.value == true) {
  //   //   EasyLoading.show(status: 'loading'.tr);
  //   //   register();
  //   // } else {
  //   //   Dialogs.connectionErrorDialog(Get.context!);
  //   // }
  //   register();
  //   update();
  // }

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
