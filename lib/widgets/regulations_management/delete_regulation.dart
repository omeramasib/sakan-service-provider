import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sakan/constants/images_manager.dart';

import '../../app/modules/regulations_management/controllers/regulations_management_controller.dart';
import '../../constants/colors_manager.dart';
import '../../constants/fonts_manager.dart';
import '../../constants/styles_manager.dart';

deleteRegulation(BuildContext context) {
  var isArabic = Get.locale!.languageCode == 'ar';
  var controller = Get.put(RegulationsManagementController());
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    constraints: BoxConstraints(
      maxHeight: Get.height,
    ),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20.0),
      ),
    ),
    builder: (BuildContext context) {
      return Container(
        width: Get.width,
        height: Get.height * 0.5,
        decoration: const BoxDecoration(
          color: ColorsManager.whiteColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 20,
              ),
              child: Container(
                width: 44,
                height: 8,
                decoration: const BoxDecoration(
                  color: ColorsManager.lightGreyColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(4),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 30,
              ),
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  color: ColorsManager.lightGreyColor,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    ImagesManager.delete,
                    height: 50,
                    width: 50,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'delete_regulation_finally'.tr,
              style: getMediumStyle(
                color: ColorsManager.errorColor,
                fontSize: FontSizeManager.s16,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Padding(
                padding: isArabic
                    ? const EdgeInsets.only(
                        right: 30,
                      )
                    : const EdgeInsets.only(
                        left: 30,
                      ),
                child: Text(
                  'delete_regulation_des'.tr,
                  style: getRegularStyle(
                    color: ColorsManager.fontColor,
                    fontSize: FontSizeManager.s14,
                    height: 2,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: Get.locale!.languageCode == 'ar'
                    ? EdgeInsets.only(
                        right: Get.width / 5,
                        bottom: 40,
                      )
                    : EdgeInsets.only(
                        left: Get.width / 5,
                        bottom: 40,
                      ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        height: 50,
                        width: Get.locale!.languageCode == 'ar' ? 124 : 155,
                        decoration: BoxDecoration(
                          color: ColorsManager.mainColor,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Center(
                          child: Text(
                            'to-retreat'.tr,
                            style: getRegularStyle(
                              color: ColorsManager.whiteColor,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        controller.deleteLaw();
                      },
                      child: Container(
                        height: 50,
                        width: Get.locale!.languageCode == 'ar' ? 124 : 155,
                        decoration: BoxDecoration(
                          color: ColorsManager.whiteColor,
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                            color: ColorsManager.defaultGreyColor,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'remove'.tr,
                            style: getMediumStyle(
                              color: ColorsManager.defaultGreyColor,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      );
    },
  );
}
