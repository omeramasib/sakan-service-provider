import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../constants/colors_manager.dart';
import '../../../../constants/fonts_manager.dart';
import '../../../../constants/images_manager.dart';
import '../../../../constants/styles_manager.dart';

Widget noNotificationYet(BuildContext context) {
  return  Column(
    children: [
      Center(
        child: Container(
         height: 100,
         width: 100,
         decoration: BoxDecoration(
         color: ColorsManager.whiteColor,
         borderRadius: BorderRadius.circular(50),
          ),
        child: Center(
          child: SvgPicture.asset(
            ImagesManager.notification,
            height: 50,
            width: 50,
            color: ColorsManager.primaryColor,
          ),
        ),
        ),
      ),
      SizedBox(height: 10,
      ),
      Text(
        'no_notification_yet'.tr,
        style: getMediumStyle(
            color: ColorsManager.fontColor,
            fontSize: FontSizeManager.s16,
            ),
      ),
    ],
  );
}