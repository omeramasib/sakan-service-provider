import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sakan/app/routes/app_pages.dart';

import '../../../../constants/buttons_manager.dart';
import '../../../../constants/colors_manager.dart';
import '../../../../constants/fonts_manager.dart';
import '../../../../constants/styles_manager.dart';
import '../../../../constants/values_manager.dart';
import '../../../../widgets/text_form_fields.dart';
import '../forget_password/forget_password.dart';
import '../otp/otp.screen.dart';
import '../controllers/login.controller.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    var isEnglish = Get.locale!.languageCode == 'en';
    return GetBuilder(
        init: controller,
        builder: (ctx) {
          return Form(
            key: controller.loginFormKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Expanded(
              child: SizedBox(
                height: Get.height,
                width: Get.width,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: isEnglish
                                ? const EdgeInsets.only(
                                    top: AppPadding.p20, left: AppPadding.p65)
                                : const EdgeInsets.only(
                                    top: AppPadding.p20, right: AppPadding.p40),
                            child: Text(
                              'phone_number'.tr,
                              style: getRegularStyle(
                                color: ColorsManager.fontColor,
                                fontSize: FontSizeManager.s14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),

                      // Phone number text field widget
                      phoneNumberFormField(
                          context,
                          controller,
                          ColorsManager.greyColor,
                          'phone_number'.tr,
                          ColorsManager.hintStyleColor),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: isEnglish
                                ? const EdgeInsets.only(
                                    top: AppPadding.p20, left: AppPadding.p65)
                                : const EdgeInsets.only(
                                    top: AppPadding.p20, right: AppPadding.p40),
                            child: Text(
                              'password'.tr,
                              style: getRegularStyle(
                                color: ColorsManager.fontColor,
                                fontSize: FontSizeManager.s14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),

                      // Password text field widget
                      passwordFormField(
                          context,
                          controller,
                          ColorsManager.greyColor,
                          'password'.tr,
                          ColorsManager.hintStyleColor),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: isEnglish
                                ? const EdgeInsets.only(
                                    top: AppPadding.p20, left: AppPadding.p65)
                                : const EdgeInsets.only(
                                    top: AppPadding.p20, right: AppPadding.p40),
                            child: GestureDetector(
                              onTap: () {
                                Get.offAll(ForgetPasswordScreen());
                              },
                              child: Text(
                                'forget_password'.tr,
                                style: getRegularStyle(
                                  color: ColorsManager.mainColor,
                                  fontSize: FontSizeManager.s14,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 80,
                      ),
                      ButtonsManager.secondaryButton(
                        text: 'login'.tr,
                        onPressed: () {
                          controller.checkLogin();
                        },
                        context: context,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
