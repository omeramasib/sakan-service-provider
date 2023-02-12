import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sakan/constants/fonts_manager.dart';
import 'package:sakan/constants/styles_manager.dart';

import '../../constants/colors_manager.dart';
import '../stepper/add_room_step1.dart';

addMultiRoom(BuildContext context){
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
                'add_multi_room'.tr,
                style:getMediumStyle(
                  color: ColorsManager.blackColor,
                  fontSize: FontSizeManager.s15
                  )
              ),
            ),
            SizedBox(
              height: 15,
            ),
            addRoomStep1(context),
          ],
        ),
     );
    },
  );
}