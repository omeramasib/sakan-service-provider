import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../../../constants/dialogs.dart';
import '../../network/controllers/network_controller.dart';
import '../models/forget_password_model.dart';
import '../providers/forget_password_provider.dart';

class ForgetPasswordController extends GetxController {
  var formKey = GlobalKey<FormState>();

  TextEditingController phoneNumberController = TextEditingController();

  String phone = '';
  String password = '';
  RxInt key = 249.obs;
  var isObscure = true.obs;

  var forgetPasswordP = ForgetPasswordProvider();

  var networkController = NetworkController();

  Future<ForgetPasswordModel> forgetPassword() async {
    return await forgetPasswordP
        .forgetPassword(
      phone: phone,
    )
        .timeout(
      Duration(seconds: 1),
      onTimeout: () {
        EasyLoading.dismiss();
        return ForgetPasswordModel();
      },
    );
  }

  void checkForgetPassword() {
    var isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    formKey.currentState!.save();
    // if (networkController.isConnected.value == true) {
    //   EasyLoading.show(status: 'loading'.tr);
    //   login();
    // } else {
    //   Dialogs.connectionErrorDialog(Get.context!);
    // }
    EasyLoading.show(status: 'loading'.tr);
    forgetPassword();
    update();
  }

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    phoneNumberController = TextEditingController();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    phoneNumberController.dispose();
  }

  void increment() => count.value++;
}
