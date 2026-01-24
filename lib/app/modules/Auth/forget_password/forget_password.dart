import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sakan/app/routes/app_pages.dart';

import '../../../../constants/buttons_manager.dart';
import '../../../../constants/colors_manager.dart';
import '../../../../constants/fonts_manager.dart';
import '../../../../constants/images_manager.dart';
import '../../../../constants/styles_manager.dart';
import '../../../../constants/values_manager.dart';
import '../../../../widgets/text_form_fields.dart';
import '../controllers/forget_password_controller.dart';
import '../otp/otp.screen.dart';

class ForgetPasswordScreen extends GetView<ForgetPasswordScreen> {
  const ForgetPasswordScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgetPasswordController());
    var isEnglish = Get.locale!.languageCode == 'en';
    return Scaffold(
      backgroundColor: ColorsManager.whiteColor,
      body: SingleChildScrollView(
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
            const SizedBox(
              height: 20,
            ),
            Text(
              'forget_password'.tr,
              style: getRegularStyle(
                color: ColorsManager.mainColor,
                fontSize: FontSizeManager.s16,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: AppPadding.p20,
                right: AppPadding.p40,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'forget_password_description'.tr,
                      style: getRegularStyle(
                        color: ColorsManager.fontColor,
                        fontSize: FontSizeManager.s14,
                        height: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Form(
              key: controller.formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
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
                  const SizedBox(
                    height: 80,
                  ),
                  ButtonsManager.secondaryButton(
                    text: 'send'.tr,
                    onPressed: () {
                      // controller.checkLogin();
                      controller.checkForgetPassword();
                    },
                    context: context,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
