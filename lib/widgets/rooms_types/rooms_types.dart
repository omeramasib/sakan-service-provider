import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sakan/constants/images_manager.dart';

import '../../constants/colors_manager.dart';
import '../../constants/fonts_manager.dart';
import '../../constants/styles_manager.dart';
import '../room_management/add_multi_room.dart';
import '../room_management/add_single_room.dart';

selectRoomTypes(BuildContext context){
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
    ), builder: (BuildContext context) {
      return Container(
        width: Get.width,
        height: Get.height * 0.2,
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
            Padding(
              padding: const EdgeInsets.only(
                right: 40,
                top: 40,
              ),
              child: GestureDetector(
                onTap: () {
                  addMultiRoom(context, 'multiple');
                },
                child: Row(
                  children: [
                    SvgPicture.asset(
                      ImagesManager.room_type,
                      width: 16,
                      height: 20,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      'shared_room'.tr,
                      style: getRegularStyle(
                        color: ColorsManager.blackColor,
                        fontSize: FontSizeManager.s14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
          Divider(
            color: ColorsManager.lightGreyColor,
            thickness: 1,
          ),
          SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.only(
                right: 40,
                // top: 10,
              ),
              child: GestureDetector(
                onTap: () {
                  addSingleRoom(context, 'single');
                },
                child: Row(
                  children: [
                    SvgPicture.asset(
                      ImagesManager.room_type,
                      width: 16,
                      height: 20,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      'single_room'.tr,
                      style: getRegularStyle(
                        color: ColorsManager.blackColor,
                        fontSize: FontSizeManager.s14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Divider(
              color: ColorsManager.lightGreyColor,
              thickness: 1,
            ),
          ],
        ),
      );
     },
  );
}