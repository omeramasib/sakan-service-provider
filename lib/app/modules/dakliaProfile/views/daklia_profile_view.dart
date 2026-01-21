import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:sakan/constants/buttons_manager.dart';
import 'package:sakan/constants/images_manager.dart';
import 'package:sakan/constants/values_manager.dart';
import 'package:shimmer/shimmer.dart';
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
    var controller = Get.put(DakliaProfileController());
    return Scaffold(
      backgroundColor: ColorsManager.greyColor,
      body: GetBuilder(
        init: controller,
        builder: (controller) {
          if (controller.isLoading.value == true) {
            EasyLoading.show(status: 'loading'.tr);
          }
          return SizedBox(
              height: Get.height,
              child: controller.profileList.isEmpty
                  ? Padding(
                      padding: EdgeInsets.only(
                        top: Get.height * 0.5,
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            Text(
                              "error_occured".tr,
                              style: getMediumStyle(
                                fontSize: FontSizeManager.s15,
                                color: ColorsManager.blackColor,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            ButtonsManager.primaryButton(
                              text: 'try_again'.tr,
                              onPressed: () {
                                controller.getDakliaProfile();
                              },
                              context: context,
                              minimumSize: const Size(150, 40),
                              maximumSize: const Size(150, 40),
                            )
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: controller.profileList.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Container(
                              height: 244,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                image:
                                    controller.profileList[0].fullDakliaImage !=
                                            null
                                        ? DecorationImage(
                                            image: NetworkImage(controller
                                                .profileList[0]
                                                .fullDakliaImage!),
                                            fit: BoxFit.cover,
                                            colorFilter: ColorFilter.mode(
                                              ColorsManager.blackColor
                                                  .withOpacity(0.4),
                                              BlendMode.darken,
                                            ),
                                          )
                                        : null,
                                color:
                                    controller.profileList[0].fullDakliaImage ==
                                            null
                                        ? ColorsManager.greyColor
                                        : null,
                              ),
                              child: Column(
                                children: [
                                  // Show placeholder when no image
                                  if (controller
                                          .profileList[0].fullDakliaImage ==
                                      null)
                                    Expanded(
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.image_not_supported,
                                              size: 64,
                                              color: ColorsManager.whiteColor
                                                  .withOpacity(0.7),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'no_image_available'.tr,
                                              style: getMediumStyle(
                                                fontSize: FontSizeManager.s16,
                                                color: ColorsManager.whiteColor
                                                    .withOpacity(0.8),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: AppPadding.p30,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            Icons.arrow_back,
                                            color: ColorsManager.whiteColor,
                                          ),
                                          onPressed: () =>
                                              Get.offAllNamed(Routes.HOME),
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
                                            Get.toNamed(
                                                Routes.EDIT_DAKLIA_PROFILE);
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
                                                top: AppPadding.p20,
                                                left: AppPadding.p20,
                                              )
                                            : const EdgeInsets.only(
                                                top: AppPadding.p20,
                                                right: AppPadding.p20,
                                              ),
                                        child: Text(
                                          controller.profileList[index]
                                                  .dakliaName ??
                                              'no_name_available'.tr,
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
                                            if (controller.profileList[index]
                                                    .accountStatus ==
                                                0) ...[
                                              SvgPicture.asset(
                                                ImagesManager.unVerified,
                                                height: 20,
                                                width: 20,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                'under_documentation'.tr,
                                                style: getRegularStyle(
                                                  color:
                                                      ColorsManager.blueColor,
                                                  fontSize: FontSizeManager.s14,
                                                ),
                                              ),
                                            ] else if (controller
                                                    .profileList[index]
                                                    .accountStatus ==
                                                1) ...[
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
                                                  color:
                                                      ColorsManager.greenColor,
                                                  fontSize: FontSizeManager.s14,
                                                ),
                                              ),
                                            ] else ...[
                                              SvgPicture.asset(
                                                ImagesManager.unVerified,
                                                color: ColorsManager.errorColor,
                                                height: 20,
                                                width: 20,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                'un_verified'.tr,
                                                style: getRegularStyle(
                                                  color:
                                                      ColorsManager.errorColor,
                                                  fontSize: FontSizeManager.s14,
                                                ),
                                              ),
                                            ],
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
                                        ? const EdgeInsets.only(
                                            left: AppPadding.p20)
                                        : const EdgeInsets.only(
                                            right: AppPadding.p20),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            controller.profileList[index]
                                                    .dakliaDescription ??
                                                'no_description_available'.tr,
                                            style: getRegularStyle(
                                              color: ColorsManager.blackColor,
                                              fontSize: FontSizeManager.s13,
                                              height: 2,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              width: 345,
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
                                              top: AppPadding.p20),
                                          child: Text(
                                            (controller.profileList[index]
                                                        .roomCount ??
                                                    0)
                                                .toString(),
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
                                              fontSize: FontSizeManager.s14),
                                        )
                                      ],
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
                                    child: Column(children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: AppPadding.p20),
                                        child: Text(
                                          (controller.profileList[index]
                                                      .serviceCount ??
                                                  0)
                                              .toString(),
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
                                            fontSize: FontSizeManager.s14),
                                      )
                                    ]),
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
                                              top: AppPadding.p20),
                                          child: Text(
                                            (controller.profileList[index]
                                                        .lawCount ??
                                                    0)
                                                .toString(),
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
                                              fontSize: FontSizeManager.s14),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ));
        },
      ),
    );
  }
}
