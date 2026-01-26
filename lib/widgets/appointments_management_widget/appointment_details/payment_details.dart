import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../app/modules/MyAppointments/models/booking_model.dart';
import '../../../constants/colors_manager.dart';
import '../../../constants/fonts_manager.dart';
import '../../../constants/images_manager.dart';
import '../../../constants/styles_manager.dart';

Widget paymentDetails(BuildContext context, BookingModel booking) {
  // Calculate payment details from booking
  final double roomPrice = booking.totalPrice ?? 0.0;
  final double deposit = 0.0; // Fixed deposit amount
  final double discount =
      0.0; // Default discount, can be updated if discount data is available
  final double totalAmount = roomPrice + deposit - discount;

  return Container(
    width: 341,
    height: 206,
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
        SizedBox(
          height: 10,
        ),
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
                      'payment_informaton'.tr,
                      style: getMediumStyle(
                        color: ColorsManager.mainColor,
                        fontSize: FontSizeManager.s15,
                      ),
                    ),
                  ),
                ],
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
                right: 20,
              ),
              child: SvgPicture.asset(
                ImagesManager.cash,
                height: 18,
                width: 18,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'cost'.tr,
              style: getRegularStyle(
                color: ColorsManager.defaultGreyColor,
                fontSize: FontSizeManager.s12,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              ": ${roomPrice.toStringAsFixed(0)}",
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
                ImagesManager.cash,
                height: 18,
                width: 18,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'deposit'.tr,
              style: getRegularStyle(
                color: ColorsManager.defaultGreyColor,
                fontSize: FontSizeManager.s12,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              ": ${deposit.toStringAsFixed(0)}",
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
                ImagesManager.cash,
                height: 18,
                width: 18,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'discount'.tr,
              style: getRegularStyle(
                color: ColorsManager.defaultGreyColor,
                fontSize: FontSizeManager.s12,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              ": ${discount.toStringAsFixed(0)}",
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
                ImagesManager.cash,
                height: 18,
                width: 18,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'total_amount_payment'.tr,
              style: getRegularStyle(
                color: ColorsManager.defaultGreyColor,
                fontSize: FontSizeManager.s12,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              ": ${totalAmount.toStringAsFixed(0)}",
              style: getRegularStyle(
                color: ColorsManager.blackColor,
                fontSize: FontSizeManager.s12,
              ),
            )
          ],
        ),
      ],
    ),
  );
}
