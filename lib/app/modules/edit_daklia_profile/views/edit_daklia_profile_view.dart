import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../constants/colors_manager.dart';
import '../../../../constants/fonts_manager.dart';
import '../../../../constants/styles_manager.dart';
import '../../../../constants/values_manager.dart';
import '../controllers/edit_daklia_profile_controller.dart';

class EditDakliaProfileView extends GetView<EditDakliaProfileController> {
  const EditDakliaProfileView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final isEnglish = Get.locale!.languageCode == 'en';
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: AppBar(
            title: Text(
              'edit_profile'.tr,
              style: getMediumStyle(
                fontSize: FontSizeManager.s15,
                color: ColorsManager.whiteColor,
              ),
            ),
            centerTitle: true,
            backgroundColor: ColorsManager.mainColor,
            leading: Padding(
              padding: const EdgeInsets.only(
                right: 25,
              ),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: ColorsManager.whiteColor,
                ),
                onPressed: () => Get.back(),
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: isEnglish
                      ? const EdgeInsets.only(
                          top: AppPadding.p20, left: AppPadding.p20)
                      : EdgeInsets.only(
                          top: AppPadding.p20, right: AppPadding.p20),
                  child: Text(
                    'warning_edit_profile'.tr,
                    style: getRegularStyle(
                      fontSize: FontSizeManager.s14,
                      color: ColorsManager.blackColor,
                      height: 2,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: isEnglish
                      ? const EdgeInsets.only(
                          top: AppPadding.p30, left: AppPadding.p20)
                      : const EdgeInsets.only(
                          top: AppPadding.p30, right: AppPadding.p20),
                  child: Text(
                    'daklia_image'.tr,
                    style: getRegularStyle(
                      color: ColorsManager.mainColor,
                      fontSize: FontSizeManager.s14,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
