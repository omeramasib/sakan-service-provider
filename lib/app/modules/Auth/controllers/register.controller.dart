import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:sakan/app/modules/Auth/providers/register_provider.dart';
import 'package:sakan/app/routes/app_pages.dart';

import '../../../../constants/dialogs.dart';
import '../../network/controllers/network_controller.dart';
import '../models/register_model.dart';

class RegisterController extends GetxController {

  var registerFormKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  String username = '';
  String phone = '';
  String password = '';
  String confirmPassword = '';

  RxInt key = 249.obs;
  var isObscure = true.obs;
  var isObscureConfirm = true.obs;

  var registerProvider = RegisterProvider();

  RxBool isConnected = false.obs;

  var networkController = NetworkController();

  Future<RegisterModel> register() async {
    return await registerProvider.register(
      dakliaName: username,
      phone: phone,
      password: password,
      confirmPassword: confirmPassword,
    ).timeout(
      Duration(seconds: 1),
      onTimeout: () {
        EasyLoading.dismiss();
        return RegisterModel();
      },
    );
  }

    void checkRegister() {
    var isValid = registerFormKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    registerFormKey.currentState!.save();
    // if (networkController.isConnected.value == true) {
    //   log('this is the network value : ${networkController.isConnected.value}');
    //   EasyLoading.show(status: 'loading'.tr);
    //   register();
    // } else {
    //   Dialogs.connectionErrorDialog(Get.context!);
    // }
    EasyLoading.show(status: 'loading'.tr);
    register();
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
