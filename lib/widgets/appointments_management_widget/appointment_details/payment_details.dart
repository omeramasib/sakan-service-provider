import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../constants/colors_manager.dart';
import '../../../constants/fonts_manager.dart';
import '../../../constants/images_manager.dart';
import '../../../constants/styles_manager.dart';

Widget paymentDetails(BuildContext context) {
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
              ": 1000",
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
              ": 20",
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
              ": 0",
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
              ": 1020",
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
