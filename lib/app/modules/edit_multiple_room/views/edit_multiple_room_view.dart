import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import '../../../../constants/buttons_manager.dart';
import '../../../../constants/colors_manager.dart';
import '../../../../constants/fonts_manager.dart';
import '../../../../constants/images_manager.dart';
import '../../../../constants/styles_manager.dart';
import '../../../../constants/values_manager.dart';
import '../../../../widgets/choose_image/choose_image.dart';
import '../../../../widgets/room_management/next_or_previus.dart';
import '../../../../widgets/stepper/add_room_step1.dart';
import '../../../../widgets/text_form_fields.dart';
import '../../room_management/controllers/room_management_controller.dart';
import '../controllers/edit_multiple_room_controller.dart';

class EditMultipleRoomView extends GetView<EditMultipleRoomController> {
  const EditMultipleRoomView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final isEnglish = Get.locale!.languageCode == 'en';
    var roomController = Get.put(RoomManagementController());
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          title: Text(
           'edit_multiple_room_info'.tr,
            style: getRegularStyle(
              color: ColorsManager.whiteColor,
              fontSize: FontSizeManager.s15,
            ),
          ),
          centerTitle: true,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: Get.width,
          height: Get.height,
          decoration: const BoxDecoration(
            color: ColorsManager.whiteColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Form(
            // key: controller.formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                SizedBox(
                  height: 10,
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
                          roomController,
                          roomController.getRooms.roomNumber.toString(),
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
                                'all_beds_number'.tr,
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
                        allBedsNumberWidget(
                          context,
                          roomController,
                          roomController.getRooms.numberOfBeds.toString(),
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
                                'empty_beds_number'.tr,
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
                        emptyBedsNumberWidget(
                          context,
                          roomController,
                          roomController.getRooms.numAvailableBeds.toString()
                        ),
                        // This is row 6
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
                        // widget for edit room image
                        Obx(
                (() => Padding(
                      padding: isEnglish
                          ? const EdgeInsets.only(left: AppPadding.p40)
                          : const EdgeInsets.only(right: AppPadding.p40),
                      child: Row(
                        children: [
                          controller.imagePath.value == ''
                              ? Container(
                                  height: 95,
                                  width: 317,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        roomController.getRooms.roomImage.toString()
                                          ),
                                      fit: BoxFit.cover,
                                      colorFilter: ColorFilter.mode(
                                        ColorsManager.blackColor.withOpacity(0.4),
                                        BlendMode.darken,
                                      ),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(
                                          AppPadding.p10,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                selectImage(context, controller);
                                              },
                                              child: SvgPicture.asset(
                                                ImagesManager.edit_profile_icon,
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              : Padding(
                                  padding: isEnglish
                                      ? const EdgeInsets.only(
                                          left: AppPadding.p10)
                                      : const EdgeInsets.only(
                                          right: AppPadding.p10),
                                  child: Container(
                                    height: 94,
                                    width: 315,
                                    decoration: BoxDecoration(
                                      color: ColorsManager.whiteColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Image.file(
                                        File(controller.imagePath.value),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    )),
              ),
                        // addRoomPhotoWidget(
                        //   context,
                        //   roomController,
                        //   'room_image'.tr,
                        // ),

                        // This is row 7
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
                        SizedBox(
                          height: 5,
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
                                      value: roomController.dailyBooking.value ||
                                          roomController.getRooms.dailyBooking!,
                                      checkColor: ColorsManager.whiteColor,
                                      fillColor: MaterialStateProperty.all(
                                          ColorsManager.mainColor),
                                      onChanged: (value) {
                                        roomController.chooseDailyBooking(value!);
                                        roomController.getRooms.dailyBooking = !roomController.getRooms.dailyBooking!;
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
                                        value: roomController.monthlyBooking.value ||
                                            roomController.getRooms.monthlyBooking!,
                                        checkColor: ColorsManager.whiteColor,
                                        fillColor: MaterialStateProperty.all(
                                            ColorsManager.mainColor),
                                        onChanged: (value) {
                                          roomController.chooseMonthlyBooking(value!);
                                          roomController.getRooms.monthlyBooking = !roomController.getRooms.monthlyBooking!;
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
                        Obx(
                          () =>  Visibility(
                            visible: roomController.dailyBooking.value == true ||
                                roomController.getRooms.dailyBooking == true,
                            child: Row(
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
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Obx(
                          ()=> Visibility(
                            visible: roomController.dailyBooking.value == true ||
                                roomController.getRooms.dailyBooking == true,
                            child: dailyBedPriceWidget(
                              context,
                              roomController,
                              'bed_price'.tr,
                            ),
                          ),
                        ),
                        // This is row 5
                        Obx(
                          ()=> Visibility(
                            visible: roomController.monthlyBooking.value == true ||
                                roomController.getRooms.monthlyBooking == true,
                            child: Row(
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
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Obx(
                          ()=> Visibility(
                            visible: roomController.monthlyBooking.value == true ||
                                roomController.getRooms.monthlyBooking == true,
                            child: monthlyBedPriceWidget(
                              context,
                              roomController,
                              'bed_price'.tr,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                // nextOrPreviousButton(context, 0),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        width: Get.width,
        height: 78,
        decoration: BoxDecoration(
          color: ColorsManager.whiteColor,
          boxShadow: [
            BoxShadow(
              color: ColorsManager.shadowColor,
              blurRadius: 7,
              offset: Offset(0, 0),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            right: 50,
          ),
          child: Row(
            children: [
              ButtonsManager.primaryButton(
                text: 'save_changes'.tr,
                onPressed: () async {
                  // await controller.sendUpdateProfile();
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
