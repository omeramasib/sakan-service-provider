import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sakan/constants/fonts_manager.dart';
import 'package:sakan/constants/styles_manager.dart';

import '../../app/modules/room_management/controllers/room_management_controller.dart';
import '../../app/routes/app_pages.dart';
import '../../constants/buttons_manager.dart';
import '../../constants/colors_manager.dart';
import '../../constants/values_manager.dart';
import '../stepper/add_room_step1.dart';
import '../text_form_fields.dart';
import 'next_or_previus.dart';

addSingleRoom(BuildContext context) {
  final isEnglish = Get.locale!.languageCode == 'en';
  final controller = Get.put(RoomManagementController());
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
    builder: (context) {
      return Container(
        width: Get.width,
        height: Get.height * 0.9,
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
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                'add_single_room'.tr,
                style: getMediumStyle(
                    color: ColorsManager.blackColor,
                    fontSize: FontSizeManager.s15),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            addRoomStep1(context),
            Container(
              width: Get.width,
              height: Get.height * 0.6,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // This is row 1
                    Row(
                      children: [
                        Padding(
                          padding: isEnglish
                              ? const EdgeInsets.only(
                                  top: AppPadding.p20, left: AppPadding.p40)
                              : const EdgeInsets.only(
                                  top: AppPadding.p20, right: AppPadding.p30),
                          child: Text(
                            'room_number'.tr,
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
                    roomNumberWidget(
                      context,
                      controller,
                      'room_number'.tr,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    // This is row 2
                    Row(
                      children: [
                        Padding(
                          padding: isEnglish
                              ? const EdgeInsets.only(
                                  top: AppPadding.p10, left: AppPadding.p40)
                              : const EdgeInsets.only(
                                  top: AppPadding.p10, right: AppPadding.p30),
                          child: Text(
                            'daily_bed_price'.tr,
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
                    dailyBedPriceWidget(
                      context,
                      controller,
                      'bed_price'.tr,
                    ),
                    // This is row 3
                    Row(
                      children: [
                        Padding(
                          padding: isEnglish
                              ? const EdgeInsets.only(
                                  top: AppPadding.p10, left: AppPadding.p40)
                              : const EdgeInsets.only(
                                  top: AppPadding.p10, right: AppPadding.p30),
                          child: Text(
                            'monthly_bed_price'.tr,
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
                    monthlyBedPriceWidget(
                      context,
                      controller,
                      'bed_price'.tr,
                    ),
                    // This is row 4
                    Row(
                      children: [
                        Padding(
                          padding: isEnglish
                              ? const EdgeInsets.only(
                                  top: AppPadding.p10, left: AppPadding.p30)
                              : const EdgeInsets.only(
                                  top: AppPadding.p10, right: AppPadding.p30),
                          child: Text(
                            'room_image'.tr,
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
                    // widget for add image
                    addRoomPhotoWidget(
                      context,
                      controller,
                      'room_image'.tr,
                    ),

                    // This is row 5
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: isEnglish
                                  ? const EdgeInsets.only(
                                      top: 5, left: AppPadding.p30)
                                  : const EdgeInsets.only(
                                      top: 5, right: AppPadding.p30),
                              child: Obx(
                                () => Checkbox(
                                  value: controller.isAvailable.value,
                                  checkColor: ColorsManager.whiteColor,
                                  fillColor: MaterialStateProperty.all(
                                      ColorsManager.mainColor),
                                  onChanged: (value) {
                                    controller.chooseIsAvailable(value!);
                                  },
                                ),
                              ),
                            ),
                            Text(
                              'empty_room'.tr,
                              style: getRegularStyle(
                                color: ColorsManager.fontColor,
                                fontSize: FontSizeManager.s14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // This is row 6
                    Row(
                      children: [
                        Padding(
                          padding: isEnglish
                              ? const EdgeInsets.only(
                                  top: AppPadding.p10, left: AppPadding.p65)
                              : const EdgeInsets.only(
                                  top: AppPadding.p10, right: AppPadding.p50),
                          child: Text(
                            'booking_type_available'.tr,
                            style: getRegularStyle(
                              color: ColorsManager.mainColor,
                              fontSize: FontSizeManager.s14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Row for booking type
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: isEnglish
                                  ? const EdgeInsets.only(
                                      top: 5, left: AppPadding.p30)
                                  : const EdgeInsets.only(
                                      top: 5, right: AppPadding.p30),
                              child: Obx(
                                () => Checkbox(
                                  value: controller.dailyBooking.value,
                                  checkColor: ColorsManager.whiteColor,
                                  fillColor: MaterialStateProperty.all(
                                      ColorsManager.mainColor),
                                  onChanged: (value) {
                                    controller.chooseDailyBooking(value!);
                                  },
                                ),
                              ),
                            ),
                            Text(
                              'daily_booking'.tr,
                              style: getRegularStyle(
                                color: ColorsManager.fontColor,
                                fontSize: FontSizeManager.s14,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: isEnglish
                              ? const EdgeInsets.only(
                                  bottom: 5, right: AppPadding.p60)
                              : const EdgeInsets.only(
                                  bottom: 5, left: AppPadding.p60),
                          child: Row(
                            children: [
                              Padding(
                                padding: isEnglish
                                    ? const EdgeInsets.only(
                                        top: 5, left: AppPadding.p30)
                                    : const EdgeInsets.only(
                                        top: 5, right: AppPadding.p30),
                                child: Obx(
                                  () => Checkbox(
                                    value: controller.monthlyBooking.value,
                                    checkColor: ColorsManager.whiteColor,
                                    fillColor: MaterialStateProperty.all(
                                        ColorsManager.mainColor),
                                    onChanged: (value) {
                                      controller.chooseMonthlyBooking(value!);
                                    },
                                  ),
                                ),
                              ),
                              Text(
                                'monthly_booking'.tr,
                                style: getRegularStyle(
                                  color: ColorsManager.fontColor,
                                  fontSize: FontSizeManager.s14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            nextOrPreviousButton(context),
          ],
        ),
      );
    },
  );
}
