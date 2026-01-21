import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../../services/secure_storage_service.dart';
import 'package:sakan/app/modules/Auth/resetpassword/views/reset_password_view.dart';
import 'package:sakan/app/routes/app_pages.dart';
import '../../../helpers/fcm_helper.dart';

import '../../../../constants/dialogs.dart';
import '../../network/controllers/network_controller.dart';
import '../models/verify_otp_model.dart';
import '../providers/verify_otp_provider.dart';
import '../providers/forget_password_provider.dart';

class OtpController extends GetxController {
  // form key
  final GlobalKey<FormState> otpCodeFormKey = GlobalKey<FormState>();
  // var networkController = Get.put(NetworkController());

  RxString otp = ''.obs;
  // change otp value
  void changeOtp(String value) => otp.value = value;

  TextEditingController otpController = TextEditingController();

  var verifyOtpProvider = VerifyOtpProvider.instance;
  var networkController = NetworkController.instance;
  var forgetPasswordProvider = ForgetPasswordProvider.instance;

  // storage insialisations
  final SecureStorageService storage = SecureStorageService.instance;

  // text field values
  String code = '';

  void resendOtp() async {
    String? phone = await storage.read('phone');
    if (phone != null) {
      EasyLoading.show(status: 'loading'.tr);
      await forgetPasswordProvider.forgetPassword(phone: phone);
    } else {
      Dialogs.errorDialog(Get.context!, 'phone_not_found'.tr);
    }
  }

  Future<VerifyOtpModel> verifyCode(int? number) async {
    return await verifyOtpProvider
        .verifyOtp(
      otp_code: code,
    )
        .then((value) {
      Future.delayed(Duration(seconds: 1), () {
        EasyLoading.dismiss();
        // Get.offAllNamed(Routes.HOME);
      });

      if (value.message == 'OTP verified successfully') {
        FCMHelper.instance.updateFCMToken();
        if (number != null) {
          if (number == 0) {
            Get.to(ResetpasswordView());
          } else if (number == 1) {
            Get.toNamed(Routes.COMPLETE_DAKLIA_ACCOUNT1);
            Dialogs.successDialog(Get.context!, 'sucsses_register'.tr);
          } else if (number == 2) {
            Get.toNamed(Routes.HOME);
          }
        }
      }
      // make timeot to stop loading
      return value;
    });
  }

  checkOtp(int? number) async {
    var isValid = otpCodeFormKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    otpCodeFormKey.currentState!.save();
    // if (networkController.isConnected.value == true) {
    //   EasyLoading.show(status: 'loading'.tr);
    //   await verifyCode();
    // } else {
    //   Dialogs.connectionErrorDialog(Get.context!);
    // }
    EasyLoading.show(status: 'loading'.tr);
    await verifyCode(number);
    update();
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    otpController.dispose();
    super.onClose();
  }
}
