import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sakan/constants/images_manager.dart';

import '../../../../../constants/buttons_manager.dart';
import '../../../../../constants/colors_manager.dart';
import '../../../../../constants/fonts_manager.dart';
import '../../../../../constants/styles_manager.dart';
import '../../../../../constants/values_manager.dart';
import '../../../../../language_controller/language_controller.dart';
import '../../../../../widgets/text_form_fields.dart';
import '../../controllers/reset_password_controller.dart';

class ResetpasswordView extends GetView {
  const ResetpasswordView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ResetpasswordController());
    return Scaffold(
      backgroundColor: ColorsManager.greyColor,
      body: Form(
        key: controller.resetPasswordFormKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
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
                        'reset_password'.tr,
                        style: getMediumStyle(color: ColorsManager.mainColor),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: LanguageController.instance.getLocale == 'en'
                              ? const EdgeInsets.only(
                                  top: AppPadding.p20, left: AppPadding.p65)
                              : const EdgeInsets.only(
                                  top: AppPadding.p20, right: AppPadding.p40),
                          child: Text(
                            'new_password'.tr,
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
                    // New Password text field widget
                    newPasswordFormField(
                        context,
                        ColorsManager.greyColor,
                        'new_password'.tr,
                        ColorsManager.hintStyleColor,
                        controller
                    ),

                    const SizedBox(
                      height: 15,
                    ),
                    // confirm password
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: LanguageController.instance.getLocale == 'en'
                              ? const EdgeInsets.only(
                                  top: AppPadding.p20, left: AppPadding.p65)
                              : const EdgeInsets.only(
                                  top: AppPadding.p20, right: AppPadding.p40),
                          child: Text(
                            'confirm_new_password'.tr,
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
                    // confirm new password text field widget
                    confirmPasswordFormField(context, controller),
                    const SizedBox(
                      height: 30,
                    ),
                    ButtonsManager.primaryButton(
                      text: 'save'.tr,
                      onPressed: () async {
                        await controller.checkResetPassword();
                      },
                      context: context,
                      maximumSize: const Size(315, 50),
                      minimumSize: const Size(315, 50),
                    ),
                  ],
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
