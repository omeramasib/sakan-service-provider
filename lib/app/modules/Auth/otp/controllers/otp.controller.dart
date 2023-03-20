import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sakan/app/routes/app_pages.dart';

import '../../../../../constants/dialogs.dart';
import '../../models/verify_otp_model.dart';
import '../../providers/verify_otp_provider.dart';

class OtpController extends GetxController {
 // form key
  final GlobalKey<FormState> otpCodeFormKey = GlobalKey<FormState>();
  // var networkController = Get.put(NetworkController());

  RxString otp = ''.obs;
  // change otp value
  void changeOtp(String value) => otp.value = value;

  TextEditingController otpController = TextEditingController();

  // get the sing_up provider here
  final VerifyOtpProvider verifyOtpProvider = Get.put(VerifyOtpProvider());

  // storage insialisations
  GetStorage storage = GetStorage();
  // text field values
  String code = '';

  Future<VerifyOtpModel> verifyCode() async {
    return await verifyOtpProvider.verifyOtp(
      // otp_code: code,
    ).then((value) {
      if(value.message == 'OTP is incorrect'){
        Dialogs.errorDialog(Get.context!, 'wrong_otp'.tr);
    }
    else if (value.message == 'OTP verified successfully'){
     Dialogs.successDialog(Get.context!, 'otp_verified'.tr);
    }
    return value;
    }
    );
  }

   checkOtp() async{
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
    await verifyCode();
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
  }
}
