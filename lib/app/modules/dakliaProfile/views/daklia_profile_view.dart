import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:sakan/constants/images_manager.dart';
import 'package:sakan/constants/values_manager.dart';

import '../../../../constants/colors_manager.dart';
import '../../../../constants/fonts_manager.dart';
import '../../../../constants/styles_manager.dart';
import '../../../routes/app_pages.dart';
import '../controllers/daklia_profile_controller.dart';

class DakliaProfileView extends GetView<DakliaProfileController> {
  const DakliaProfileView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var isEnglish = Get.locale!.languageCode == 'en';
    return Scaffold(
      backgroundColor: ColorsManager.greyColor,
      body: Column(
        children: [
          Container(
            height: 244,
            width: double.infinity,
            color: Colors.red,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: AppPadding.p50,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: ColorsManager.whiteColor,
                        ),
                        onPressed: () => Get.back(),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 40,
                        ),
                        child: Text(
                          'daklia_management'.tr,
                          style: getMediumStyle(
                            fontSize: FontSizeManager.s15,
                            color: ColorsManager.whiteColor,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(Routes.EDIT_DAKLIA_PROFILE);
                        },
                        child: SvgPicture.asset(
                          ImagesManager.edit,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: 150,
            width: 340,
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
                Row(
                  children: [
                    Padding(
                      padding: isEnglish
                          ? const EdgeInsets.only(
                              top: AppPadding.p20, left: AppPadding.p20)
                          : const EdgeInsets.only(
                              top: AppPadding.p20, right: AppPadding.p20),
                      child: Text(
                        'daklia_name'.tr,
                        style: getRegularStyle(
                          color: ColorsManager.mainColor,
                          fontSize: FontSizeManager.s14,
                        ),
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: isEnglish
                          ? const EdgeInsets.only(
                              top: AppPadding.p20,
                              right: AppPadding.p20,
                            )
                          : const EdgeInsets.only(
                              top: AppPadding.p20,
                              left: AppPadding.p20,
                            ),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            ImagesManager.confirmation,
                            height: 20,
                            width: 20,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'confirmed'.tr,
                            style: getRegularStyle(
                              color: ColorsManager.greenColor,
                              fontSize: FontSizeManager.s13,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
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
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: isEnglish
                ?  EdgeInsets.only(
                    left: Get.width * 0.1,
                  )
                :  EdgeInsets.only(
                    right: Get.width * 0.1,
                  ),
            child: Row(
              children: [
                Container(
                  width: 105,
                  height: 100,
                  decoration: BoxDecoration(
                    color: ColorsManager.whiteColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: ColorsManager.shadowColor,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top:  AppPadding.p20
                        ),
                        child: Text(
                          '0',
                          style: getSemiBoldStyle(
                            color: ColorsManager.mainColor,
                            fontSize: FontSizeManager.s18,
                            ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'room'.tr,
                        style: getRegularStyle(
                          color: ColorsManager.fontColor,
                          fontSize: FontSizeManager.s14
                          ),
                      )
                    ]
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Container(
                  width: 105,
                  height: 100,
                  decoration: BoxDecoration(
                    color: ColorsManager.whiteColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: ColorsManager.shadowColor,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top:  AppPadding.p20
                        ),
                        child: Text(
                          '0',
                          style: getSemiBoldStyle(
                            color: ColorsManager.mainColor,
                            fontSize: FontSizeManager.s18,
                            ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'services'.tr,
                        style: getRegularStyle(
                          color: ColorsManager.fontColor,
                          fontSize: FontSizeManager.s14
                          ),
                      )
                    ]
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Container(
                  width: 105,
                  height: 100,
                  decoration: BoxDecoration(
                    color: ColorsManager.whiteColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: ColorsManager.shadowColor,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top:  AppPadding.p20
                        ),
                        child: Text(
                          '0',
                          style: getSemiBoldStyle(
                            color: ColorsManager.mainColor,
                            fontSize: FontSizeManager.s18,
                            ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'conditions'.tr,
                        style: getRegularStyle(
                          color: ColorsManager.fontColor,
                          fontSize: FontSizeManager.s14
                          ),
                      )
                    ]
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
