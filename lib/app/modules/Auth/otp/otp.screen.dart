import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import '../../../services/secure_storage_service.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sakan/constants/images_manager.dart';

import '../../../../constants/buttons_manager.dart';
import '../../../../constants/colors_manager.dart';
import '../../../../constants/dialogs.dart';
import '../../../../constants/fonts_manager.dart';
import '../../../../constants/styles_manager.dart';
import '../../../../constants/validations.dart';
import '../../../../constants/values_manager.dart';
import '../../../routes/app_pages.dart';
import '../resetpassword/views/reset_password_view.dart';
import '../controllers/otp.controller.dart';

class OtpScreen extends GetView<OtpController> {
  const OtpScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    int? number = Get.arguments;
    final SecureStorageService storage = SecureStorageService.instance;
    return Scaffold(
      backgroundColor: ColorsManager.whiteColor,
      body: Form(
        key: controller.otpCodeFormKey,
        child: Column(children: [
          Container(
            height: 205,
            width: Get.width,
            decoration: const BoxDecoration(
              color: ColorsManager.mainColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(AppPadding.p25),
                bottomRight: Radius.circular(AppPadding.p25),
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: AppPadding.p30,
                ),
                child: Image.asset(
                  ImagesManager.logo,
                  height: 129,
                  width: 128,
                  color: ColorsManager.whiteColor,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: Get.height,
              width: Get.width,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: AppSize.s20),
                      child: Text(
                        'enter_otp'.tr,
                        style: getMediumStyle(
                          color: ColorsManager.mainColor,
                          fontSize: FontSizeManager.s16,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'description1_otp'.tr,
                      style: getRegularStyle(
                        color: ColorsManager.fontColor,
                        fontSize: FontSizeManager.s14,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'description2_otp'.tr,
                      style: getRegularStyle(
                        color: ColorsManager.fontColor,
                        fontSize: FontSizeManager.s14,
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: PinCodeTextField(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        length: 6,
                        obscureText: false,
                        animationType: AnimationType.fade,
                        textStyle: getMediumStyle(
                          color: ColorsManager.fontColor,
                          fontSize: FontSizeManager.s14,
                        ),
                        pinTheme: PinTheme(
                          activeColor: ColorsManager.greyColor,
                          inactiveColor: ColorsManager.whiteColor,
                          disabledColor: ColorsManager.whiteColor,
                          selectedColor: ColorsManager.mainColor,
                          selectedFillColor: ColorsManager.whiteColor,
                          activeFillColor: ColorsManager.greyColor,
                          inactiveFillColor: ColorsManager.lightGreyColor,
                          errorBorderColor: ColorsManager.errorColor,
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(5),
                          fieldHeight: 54,
                          fieldWidth: 52,
                          // activeFillColor: Colors.white,
                        ),
                        validator: (value) => Validations().validateOtp(value!),
                        backgroundColor: ColorsManager.whiteColor,
                        enableActiveFill: true,
                        controller: controller.otpController,
                        onCompleted: (v) {
                          controller.code = v;
                        },
                        onChanged: (value) {
                          controller.changeOtp(value);
                        },
                        beforeTextPaste: (text) {
                          print("Allowing to paste $text");
                          return true;
                        },
                        appContext: context,
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    ButtonsManager.primaryButton(
                      text: 'confirm'.tr,
                      onPressed: () {
                        controller.checkOtp(number);
                        // if (number == 0) {
                        //   controller.checkOtp();
                        // }
                        // if (number == 1) {
                        //   if (storage.read('otp') == controller.code) {
                        //     Dialogs.successDialog(
                        //         Get.context!, 'sucsses_register'.tr);
                        //     Get.offNamed(Routes.HOME);
                        //   }

                        //   if (number == 2) {
                        //     controller.checkOtp();
                        //     // if (storage.read('otp') == controller.code) {
                        //     //   Get.offNamed(Routes.HOME);
                        //     // }
                        //   }
                        // }
                      },
                      context: context,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'not_receive_code'.tr,
                          style: getRegularStyle(
                            color: ColorsManager.blackColor,
                            fontSize: FontSizeManager.s14,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            controller.resendOtp();
                          },
                          child: Text(
                            'resend'.tr,
                            style: getRegularStyle(
                              color: ColorsManager.mainColor,
                              fontSize: FontSizeManager.s14,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
