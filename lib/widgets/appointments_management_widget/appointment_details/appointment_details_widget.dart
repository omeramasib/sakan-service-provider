import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sakan/constants/styles_manager.dart';
import 'package:sakan/widgets/appointments_management_widget/appointment_details/payment_details.dart';

import '../../../constants/colors_manager.dart';
import '../../../constants/fonts_manager.dart';
import '../../../constants/images_manager.dart';

appointmentDetailsWidget(BuildContext context) {
  return Column(
    children: [
      SizedBox(
        height: 30,
      ),
      Container(
        width: 341,
        height: 301,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: ColorsManager.whiteColor,
          border: Border.all(
            color: ColorsManager.borderColor,
          ),
          boxShadow: [
            BoxShadow(
              color: ColorsManager.shadowColor,
              blurRadius: 7,
              offset: Offset(0, 0), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: 15,
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          right: 20,
                          top: 10,
                        ),
                        child: Text(
                          "booking_number".tr,
                          style: getMediumStyle(
                            color: ColorsManager.mainColor,
                            fontSize: FontSizeManager.s15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 15,
                    left: 20,
                  ),
                  child: Container(
                    height: 27,
                    width: 78,
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Text(
                        'paid'.tr,
                        style: getRegularStyle(
                          color: Colors.green,
                          fontSize: FontSizeManager.s13,
                        ),
                      ),
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
                Padding(
                  padding: const EdgeInsets.only(
                    right: 20,
                  ),
                  child: SvgPicture.asset(
                    ImagesManager.room_type,
                    height: 25,
                    width: 25,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "room_type".tr,
                  style: getRegularStyle(
                    color: ColorsManager.defaultGreyColor,
                    fontSize: FontSizeManager.s12,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  ": ${'single_room'.tr}",
                  style: getRegularStyle(
                    color: ColorsManager.blackColor,
                    fontSize: FontSizeManager.s12,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    right: 20,
                  ),
                  child: SvgPicture.asset(
                    ImagesManager.room_type,
                    height: 25,
                    width: 25,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "room_number".tr,
                  style: getRegularStyle(
                    color: ColorsManager.defaultGreyColor,
                    fontSize: FontSizeManager.s12,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  ': 123445'.tr,
                  style: getRegularStyle(
                    color: ColorsManager.blackColor,
                    fontSize: FontSizeManager.s12,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    right: 20,
                  ),
                  child: SvgPicture.asset(
                    ImagesManager.rooms,
                    height: 14,
                    width: 16,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'beds_number_in_room'.tr,
                  style: getRegularStyle(
                    color: ColorsManager.defaultGreyColor,
                    fontSize: FontSizeManager.s12,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  ': 1'.tr,
                  style: getRegularStyle(
                    color: ColorsManager.blackColor,
                    fontSize: FontSizeManager.s12,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    right: 20,
                  ),
                  child: SvgPicture.asset(
                    ImagesManager.rooms,
                    height: 14,
                    width: 16,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'room_price'.tr,
                  style: getRegularStyle(
                    color: ColorsManager.defaultGreyColor,
                    fontSize: FontSizeManager.s12,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  ': 1000'.tr,
                  style: getRegularStyle(
                    color: ColorsManager.blackColor,
                    fontSize: FontSizeManager.s12,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    right: 18,
                  ),
                  child: SvgPicture.asset(
                    ImagesManager.booking,
                    height: 20,
                    width: 20,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'booking_type'.tr,
                  style: getRegularStyle(
                    color: ColorsManager.defaultGreyColor,
                    fontSize: FontSizeManager.s12,
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Text(
                  ':',
                  style: getRegularStyle(
                    color: ColorsManager.blackColor,
                    fontSize: FontSizeManager.s12,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Container(
                  height: 27,
                  width: 95,
                  decoration: BoxDecoration(
                    color: ColorsManager.mainColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Text(
                      "${'monthly_booking'.tr}",
                      style: getRegularStyle(
                        color: ColorsManager.mainColor,
                        fontSize: FontSizeManager.s13,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    right: 18,
                  ),
                  child: SvgPicture.asset(
                    ImagesManager.booking_number,
                    height: 14,
                    width: 18,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "booking_number".tr,
                  style: getRegularStyle(
                    color: ColorsManager.defaultGreyColor,
                    fontSize: FontSizeManager.s12,
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Text(
                  ': 14',
                  style: getRegularStyle(
                    color: ColorsManager.blackColor,
                    fontSize: FontSizeManager.s12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      SizedBox(
        height: 15,
      ),
      paymentDetails(context),
    ],
  );
}
