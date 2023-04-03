import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sakan/app/modules/Auth/resetpassword/views/reset_password_view.dart';
import 'package:sakan/app/routes/app_pages.dart';

import '../../../../constants/dialogs.dart';
import '../../network/controllers/network_controller.dart';
import '../models/verify_otp_model.dart';
import '../providers/verify_otp_provider.dart';

class OtpController extends GetxController {
  // form key
  final GlobalKey<FormState> otpCodeFormKey = GlobalKey<FormState>();
  // var networkController = Get.put(NetworkController());

  RxString otp = ''.obs;
  // change otp value
  void changeOtp(String value) => otp.value = value;

  TextEditingController otpController = TextEditingController();

  // get the sing_up provider here
  var verifyOtpProvider = VerifyOtpProvider.instance;

  var networkController = NetworkController.instance;
  // storage insialisations
  GetStorage storage = GetStorage();
  // text field values
  String code = '';

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
        if (number != null) {
          if (number == 0) {
            Get.to(ResetpasswordView());
          } else if (number == 1) {
            Get.toNamed(Routes.COMPLETE_DAKLIA_ACCOUNT1);
            Dialogs.successDialog(Get.context!, 'sucsses_register'.tr);
          } else if (number == 2){
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
    otpController = TextEditingController();
  }

  @override
  void onClose() {
    super.onClose();
    // otpController.dispose();
  }
}
