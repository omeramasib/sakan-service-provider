import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:sakan/constants/images_manager.dart';

import '../../../../constants/buttons_manager.dart';
import '../../../../constants/colors_manager.dart';
import '../../../../constants/fonts_manager.dart';
import '../../../../constants/styles_manager.dart';
import '../../../../constants/values_manager.dart';
import '../../../../widgets/text_form_fields.dart';
import '../../../routes/app_pages.dart';
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
              Expanded(
                child: Padding(
                  padding: isEnglish
                      ? const EdgeInsets.only(
                          top: AppPadding.p20,
                          left: AppPadding.p20,
                        )
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
          SizedBox(
            height: 15,
          ),
          Row(
            children: [
              SizedBox(
                width: 20,
              ),
              dakliaImageWidget(context, controller, "add_photo".tr),
              SizedBox(
                width: 10,
              ),
              Container(
                width: 105,
                height: 94,
                decoration: BoxDecoration(
                  color: ColorsManager.whiteColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 5,
                      left: 5,
                      child: SvgPicture.asset(
                        ImagesManager.delete,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                width: 105,
                height: 94,
                decoration: BoxDecoration(
                  color: ColorsManager.whiteColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 5,
                      left: 5,
                      child: SvgPicture.asset(
                        ImagesManager.delete,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
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
                  'daklia_description'.tr,
                  style: getRegularStyle(
                    color: ColorsManager.mainColor,
                    fontSize: FontSizeManager.s14,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: isEnglish
                ? const EdgeInsets.only(left: AppPadding.p20)
                : const EdgeInsets.only(right: AppPadding.p20),
            child: Row(
              children: [
                Container(
                  height: 101,
                  width: 329,
                  decoration: BoxDecoration(
                    color: ColorsManager.whiteColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: ColorsManager.shadowColor,
                        blurRadius: 7,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: isEnglish
                            ? const EdgeInsets.only(left: AppPadding.p20)
                            : const EdgeInsets.only(right: AppPadding.p20),
                        child: Text(
                          'daklia_description_description'.tr,
                          style: getRegularStyle(
                            color: ColorsManager.blackColor,
                            fontSize: FontSizeManager.s13,
                            height: 2,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Padding(
                padding: isEnglish
                    ? const EdgeInsets.only(
                        top: AppPadding.p20, left: AppPadding.p20)
                    : const EdgeInsets.only(
                        top: AppPadding.p20, right: AppPadding.p20),
                child: Text(
                  'room_count'.tr,
                  style: getRegularStyle(
                    color: ColorsManager.mainColor,
                    fontSize: FontSizeManager.s14,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: isEnglish
                ? const EdgeInsets.only(left: AppPadding.p20)
                : const EdgeInsets.only(right: AppPadding.p20),
            child: Row(
              children: [
                roomCountWidget(
                  context,
                  controller,
                  'room_count'.tr,
                ),
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: Container(
        width: Get.width,
        height: 78,
        decoration: BoxDecoration(
          color: ColorsManager.whiteColor,
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            right: 50,
          ),
          child: Row(
            children: [
              ButtonsManager.primaryButton(
                text: 'Save_changes'.tr,
                onPressed: () {
                  Get.toNamed(Routes.HOME);
                },
                context: context,
                maximumSize: Size(287, 50),
                minimumSize: Size(287, 50),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
