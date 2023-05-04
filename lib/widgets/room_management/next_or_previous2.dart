import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sakan/app/routes/app_pages.dart';
import 'package:sakan/widgets/room_management/room_features/room_features.dart';

import '../../constants/buttons_manager.dart';
import '../../constants/colors_manager.dart';

nextOrPrevious2Button(BuildContext context) {
  return Container(
    width: Get.width,
    height: 78,
    decoration: BoxDecoration(
      color: ColorsManager.whiteColor,
    ),
    child: Padding(
      padding: const EdgeInsets.only(
        right: 50,
      ),
      child: Row(
        children: [
          ButtonsManager.primaryButton(
            text: 'next'.tr,
            onPressed: () {
              Get.offAllNamed(Routes.ROOM_MANAGEMENT);
            },
            context: context,
            maximumSize: Size(174, 50),
            minimumSize: Size(174, 50),
          ),
          SizedBox(
            width: 15,
          ),
          ButtonsManager.primaryButton(
            text: 'previous'.tr,
            onPressed: () {
              Get.back();
            },
            context: context,
            maximumSize: Size(134, 50),
            minimumSize: Size(134, 50),
            buttonColor: ColorsManager.greyColor,
            textColor: ColorsManager.blackColor,
          )
        ],
      ),
    ),
  );
}
