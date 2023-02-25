import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/modules/MyAppointments/controllers/my_appointments_controller.dart';
import '../../../constants/colors_manager.dart';
import '../../../constants/fonts_manager.dart';
import '../../../constants/styles_manager.dart';
import '../../../constants/values_manager.dart';

Widget chooseApprovalType(BuildContext context) {
  var controller = Get.put(MyAppointmentsController());
  int index = controller.tabIndex2.value;
  return Stack(
    children: [
      Padding(
        padding: Get.locale!.languageCode == 'ar'
            ? const EdgeInsets.only(
            top: 10,
        )
            : const EdgeInsets.only(
            top: 10,
        ),
        child: Obx(
              () => GestureDetector(
            onTap: () {
              controller.changeTabIndex2(index);
            },
            child: Container(
              width: 275,
              height: 32,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  AppSize.s50,
                ),
                color: ColorsManager.whiteColor,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      controller.changeTabIndex2(index = 0);
                    },
                    child: Container(
                      width: 114,
                      height: 32,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppSize.s50),
                        color: controller.tabIndex2.value == 0
                            ? ColorsManager.mainColor
                            : ColorsManager.whiteColor,
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'awaiting_daklia_approval'.tr,
                              style: getRegularStyle(
                                color: controller.tabIndex2.value == 0
                                    ? ColorsManager.whiteColor
                                    : ColorsManager.fontColor,
                                fontSize: FontSizeManager.s13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      controller.changeTabIndex2(index = 1);
                    },
                    child: Container(
                      width: 155,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppSize.s50),
                        color: controller.tabIndex2.value == 1
                            ? ColorsManager.mainColor
                            : ColorsManager.whiteColor,
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'awaiting_user_approval'.tr,
                              style: getRegularStyle(
                                color: controller.tabIndex2.value == 1
                                    ? ColorsManager.whiteColor
                                    : ColorsManager.fontColor,
                                fontSize: FontSizeManager.s13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ],
  );
}