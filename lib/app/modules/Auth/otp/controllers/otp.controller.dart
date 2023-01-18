import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sakan/app/routes/app_pages.dart';

class OtpController extends GetxController {
 // form key
  final GlobalKey<FormState> otpCodeFormKey = GlobalKey<FormState>();
  // var networkController = Get.put(NetworkController());

  RxString otp = ''.obs;
  // change otp value
  void changeOtp(String value) => otp.value = value;

  TextEditingController otpController = TextEditingController();

  // get the sing_up provider here
  // final VerifyOtpProvider verifyOtpProvider = Get.put(VerifyOtpProvider());

  // storage insialisations
  GetStorage storage = GetStorage();
  // text field values
  String code = '';

  // Future<VerifyOtpModel> verifyCode() async {
  //   return await verifyOtpProvider.verifyOtp(
  //     phone: storage.read('phone'),
  //     otpCode: code,
  //   );
  // }

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
