import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sakan/constants/images_manager.dart';

import '../../../../constants/buttons_manager.dart';
import '../../../../constants/colors_manager.dart';
import '../../../../constants/fonts_manager.dart';
import '../../../../constants/styles_manager.dart';
import '../../../../constants/values_manager.dart';
import '../../../../language_controller/language_controller.dart';
import '../../../../widgets/text_form_fields.dart';
import '../controllers/change_password_controller.dart';

class ChangePasswordView extends GetView<ChangePasswordController> {
  const ChangePasswordView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ChangePasswordController());
    return Scaffold(
      backgroundColor: ColorsManager.greyColor,
      body: Form(
        key: controller.changePasswordFormKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(children: [
          Row(
            children: [
              Padding(
                padding: Get.locale!.languageCode == 'ar'
                    ? const EdgeInsets.only(right: AppPadding.p10)
                    : const EdgeInsets.only(left: AppPadding.p10),
                child: IconButton(
                  splashColor: Colors.transparent,
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: ColorsManager.blackColor,
                  ),
                ),
              ),
              const SizedBox(
                width: 50,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Image.asset(
                  ImagesManager.logo,
                  height: 121,
                  width: 188,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: Container(
              height: Get.height,
              width: Get.width,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppPadding.p20),
                  topRight: Radius.circular(AppPadding.p20),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Text(
                        'change_password'.tr,
                        style: getMediumStyle(color: ColorsManager.fontColor),
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
                            'old_password'.tr,
                            style: getRegularStyle(
                              color: ColorsManager.mainColor,
                              fontSize: FontSizeManager.s14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),

                    // old password text field widget
                    oldPasswordFormField(
                        context,
                        ColorsManager.greyColor,
                        'old_password'.tr,
                        ColorsManager.hintStyleColor,
                        controller),

                    const SizedBox(
                      height: 15,
                    ),

                    // new password text field widget
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
                              color: ColorsManager.mainColor,
                              fontSize: FontSizeManager.s14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),

                    // new password text field widget
                    newPasswordFormField(
                      context,
                      ColorsManager.greyColor,
                      'new_password'.tr,
                      ColorsManager.hintStyleColor,
                      controller,
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
                            'confirm_password'.tr,
                            style: getRegularStyle(
                              color: ColorsManager.mainColor,
                              fontSize: FontSizeManager.s14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),

                    // confirm password text field widget
                    confirmNewPassword(context, controller),
                    const SizedBox(
                      height: 30,
                    ),
                    ButtonsManager.primaryButton(
                      text: 'save'.tr,
                      onPressed: () {
                        controller.checkUpdatePassword();
                      },
                      context: context,
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
