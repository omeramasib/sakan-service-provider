import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sakan/constants/images_manager.dart';

import '../../../../constants/buttons_manager.dart';
import '../../../../constants/colors_manager.dart';
import '../../../../constants/fonts_manager.dart';
import '../../../../constants/styles_manager.dart';
import '../../../../constants/validations.dart';
import '../../../../constants/values_manager.dart';
import '../resetpassword/views/resetpassword_view.dart';
import 'controllers/otp.controller.dart';

class OtpScreen extends GetView<OtpController> {
  const OtpScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    int? number = Get.arguments;
    var controller = Get.put(OtpController());
    return Scaffold(
      backgroundColor: ColorsManager.whiteColor,
      body: Form(
        key: controller.otpCodeFormKey,
        child: Column(
          children: [
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
                    PinCodeTextField(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    length: 4,
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
                      selectedColor: ColorsManager.primaryColor,
                      selectedFillColor: ColorsManager.whiteColor,
                      activeFillColor: ColorsManager.greyColor,
                      inactiveFillColor: ColorsManager.greyColor,
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
                  // OtpTextField(
                  //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //   numberOfFields: 4,
                  //   fieldWidth: 50,
                  //   autoFocus: false,
                  //   keyboardType: TextInputType.number,
                  //   cursorColor: ColorsManager.mainColor,
                  //   borderColor: ColorsManager.greyColor,
                  //   borderRadius: BorderRadius.circular(7),
                  //   decoration: const InputDecoration(
                  //     fillColor: ColorsManager.fontColor,
                  //     filled: true,
                  //     border: OutlineInputBorder(
                  //       borderSide: BorderSide.none,
                  //       borderRadius: BorderRadius.all(
                  //         Radius.circular(7),
                  //       ),
                  //     ),
                  //   ),
                  //   textStyle: getRegularStyle(
                  //     color: ColorsManager.fontColor,
                  //     fontSize: FontSizeManager.s14,
                  //   ),
                  //   showFieldAsBox: true,
                  //   onCodeChanged: (String code) {
                  //     Validations().validateOtp(code);
                  //     //handle validation or checks here
                  //   },
                  //   //runs when every textfield is filled
                  //   onSubmit: (String verificationCode) {
                  //     // showDialog(
                  //     //     context: context,
                  //     //     builder: (context) {
                  //     //       return AlertDialog(
                  //     //         title: Text("Verification Code"),
                  //     //         content: Text('Code entered is $verificationCode'),
                  //     //       );
                  //     //     });
                  //   }, // end onSubmit
                  // ),
                  const SizedBox(
                    height: 50,
                  ),
                  ButtonsManager.primaryButton(
                    text: 'confirm'.tr,
                    onPressed: () {
                      if (number == 0) {
                        Get.to(const ResetpasswordView());
                      } else if (number == 1) {
                        Get.offNamed('/home');
                      }
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
                        onPressed: () {},
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
        ]),
      ),
    );
  }
}
