import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../constants/buttons_manager.dart';
import '../../../../constants/colors_manager.dart';
import '../../../../constants/fonts_manager.dart';
import '../../../../constants/styles_manager.dart';
import '../../../../constants/responsive_helper.dart';
import '../../../../widgets/text_form_fields.dart';
import '../../../../widgets/responsive_builder.dart';
import '../controllers/register.controller.dart';

class RegisterScreen extends GetView<RegisterController> {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RegisterController());
    var isEnglish = Get.locale!.languageCode == 'en';
    final labelPadding = ResponsiveHelper.wp(5);

    return Form(
      key: controller.registerFormKey,
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
                // Daklia Name Label
                _buildLabel('daklia_name'.tr, isEnglish, labelPadding),
                ResponsiveSpacing(
                    mobileHeight: 10, tabletHeight: 12, desktopHeight: 14),

                // Daklia Name Field
                dakliaNameFormField(
                  context,
                  controller,
                  ColorsManager.greyColor,
                  'daklia_name'.tr,
                  ColorsManager.hintStyleColor,
                ),
                ResponsiveSpacing(
                    mobileHeight: 10, tabletHeight: 12, desktopHeight: 14),

                // Phone Number Label
                _buildLabel('phone_number'.tr, isEnglish, labelPadding),
                ResponsiveSpacing(
                    mobileHeight: 12, tabletHeight: 14, desktopHeight: 16),

                // Phone number text field widget
                phoneNumberFormField(
                  context,
                  controller,
                  ColorsManager.greyColor,
                  'phone_number'.tr,
                  ColorsManager.hintStyleColor,
                ),
                ResponsiveSpacing(
                    mobileHeight: 12, tabletHeight: 14, desktopHeight: 16),

                // Password Label
                _buildLabel('password'.tr, isEnglish, labelPadding),
                ResponsiveSpacing(
                    mobileHeight: 12, tabletHeight: 14, desktopHeight: 16),

                // Password text field widget
                passwordFormField(
                  context,
                  controller,
                  ColorsManager.greyColor,
                  'password'.tr,
                  ColorsManager.hintStyleColor,
                ),
                ResponsiveSpacing(
                    mobileHeight: 12, tabletHeight: 14, desktopHeight: 16),

                // Confirm Password Label
                _buildLabel('confirm_password'.tr, isEnglish, labelPadding),
                ResponsiveSpacing(
                    mobileHeight: 12, tabletHeight: 14, desktopHeight: 16),

                // Confirm password text field widget
                confirmPasswordFormField(context, controller),

                ResponsiveSpacing(
                    mobileHeight: 40, tabletHeight: 50, desktopHeight: 60),

                // Register Button
                Center(
                  child: ButtonsManager.secondaryButton(
                    text: 'register'.tr,
                    onPressed: () => controller.checkRegister(),
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
