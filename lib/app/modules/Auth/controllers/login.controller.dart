import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../../services/secure_storage_service.dart';

import '../../../../constants/dialogs.dart';
import '../../network/controllers/network_controller.dart';
import '../models/login_model.dart';
import '../providers/login_provider.dart';

class LoginController extends GetxController {
  var loginFormKey = GlobalKey<FormState>();

  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // storage insialisations
  final SecureStorageService storage = SecureStorageService.instance;
  // text field values
  String phone = '';
  String password = '';
  RxInt key = 249.obs;
  var isObscure = true.obs;

  var loginProvider = LoginProvider();

  var networkController = NetworkController();

  Future<LoginModel> login() async {
    log('Login called with phone: $phone, password: $password');
    return await loginProvider
        .loginUser(
      phone: phone,
      password: password,
    )
        .timeout(
      Duration(seconds: 30),
      onTimeout: () {
        log('Login timeout!');
        EasyLoading.dismiss();
        return LoginModel();
      },
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
    EasyLoading.show(status: 'loading'.tr);
    login();
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
