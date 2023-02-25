import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../app/modules/MyAppointments/controllers/my_appointments_controller.dart';
import '../../constants/colors_manager.dart';
import '../../constants/fonts_manager.dart';
import '../../constants/styles_manager.dart';
import '../../constants/values_manager.dart';

Widget chooseMyAppointmentType(BuildContext context) {
  var controller = Get.put(MyAppointmentsController());
  int index = controller.tabIndex.value;
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
              controller.changeTabIndex(index);
            },
            child: Container(
              width: 341,
              height: 40,
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
                      controller.changeTabIndex(index = 0);
                    },
                    child: Container(
                      width: 168,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppSize.s50),
                        color: controller.tabIndex.value == 0
                            ? ColorsManager.mainColor
                            : ColorsManager.whiteColor,
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'new_bookings'.tr,
                              style: getRegularStyle(
                                color: controller.tabIndex.value == 0
                                    ? ColorsManager.whiteColor
                                    : ColorsManager.fontColor,
                                fontSize: FontSizeManager.s14,
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
                      controller.changeTabIndex(index = 1);
                    },
                    child: Container(
                      width: 168,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppSize.s50),
                        color: controller.tabIndex.value == 1
                            ? ColorsManager.mainColor
                            : ColorsManager.whiteColor,
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'previous_bookings'.tr,
                              style: getRegularStyle(
                                color: controller.tabIndex.value == 1
                                    ? ColorsManager.whiteColor
                                    : ColorsManager.fontColor,
                                fontSize: FontSizeManager.s14,
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