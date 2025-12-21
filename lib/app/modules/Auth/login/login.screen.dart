import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../constants/buttons_manager.dart';
import '../../../../constants/colors_manager.dart';
import '../../../../constants/fonts_manager.dart';
import '../../../../constants/styles_manager.dart';
import '../../../../constants/responsive_helper.dart';
import '../../../../widgets/text_form_fields.dart';
import '../../../../widgets/responsive_builder.dart';
import '../forget_password/forget_password.dart';
import '../controllers/login.controller.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    var isEnglish = Get.locale!.languageCode == 'en';
    final labelPadding = ResponsiveHelper.wp(5);

    return GetBuilder(
      init: controller,
      builder: (ctx) {
        return Form(
          key: controller.loginFormKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 500),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: labelPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Phone Number Label
                    _buildLabel('phone_number'.tr, isEnglish, labelPadding),
                    ResponsiveSpacing(
                        mobileHeight: 12, tabletHeight: 15, desktopHeight: 18),

                    // Phone number text field widget
                    phoneNumberFormField(
                      context,
                      controller,
                      ColorsManager.greyColor,
                      'phone_number'.tr,
                      ColorsManager.hintStyleColor,
                    ),

                    // Password Label
                    _buildLabel('password'.tr, isEnglish, labelPadding),
                    ResponsiveSpacing(
                        mobileHeight: 12, tabletHeight: 15, desktopHeight: 18),

                    // Password text field widget
                    passwordFormField(
                      context,
                      controller,
                      ColorsManager.greyColor,
                      'password'.tr,
                      ColorsManager.hintStyleColor,
                    ),

                    // Forget Password Link
                    Padding(
                      padding: EdgeInsets.only(
                        top: ResponsiveHelper.hp(2.5),
                        left: isEnglish ? labelPadding : 0,
                        right: isEnglish ? 0 : labelPadding,
                      ),
                      child: GestureDetector(
                        onTap: () => Get.offAll(ForgetPasswordScreen()),
                        child: Text(
                          'forget_password'.tr,
                          style: getRegularStyle(
                            color: ColorsManager.mainColor,
                            fontSize: ResponsiveHelper.responsiveFontSize(
                                FontSizeManager.s14),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),

                    ResponsiveSpacing(
                        mobileHeight: 60, tabletHeight: 70, desktopHeight: 80),

                    // Login Button
                    Center(
                      child: ButtonsManager.secondaryButton(
                        text: 'login'.tr,
                        onPressed: () => controller.checkLogin(),
                        context: context,
                      ),
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLabel(String text, bool isEnglish, double padding) {
    return Padding(
      padding: EdgeInsets.only(
        top: ResponsiveHelper.hp(2.5),
        left: isEnglish ? padding : 0,
        right: isEnglish ? 0 : padding,
      ),
      child: Text(
        text,
        style: getRegularStyle(
          color: ColorsManager.fontColor,
          fontSize: ResponsiveHelper.responsiveFontSize(FontSizeManager.s14),
        ),
      ),
    );
  }
}
