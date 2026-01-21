import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sakan/app/modules/edit_room_feature/views/edit_room_feature_view.dart';
import 'package:sakan/app/routes/app_pages.dart';
import 'package:sakan/constants/images_manager.dart';

import '../../app/modules/edit_room_feature/views/edit_room_feature_view.dart';
import '../../app/modules/edit_room_feature/views/edit_room_feature_view.dart';
import '../../app/modules/room_management/controllers/room_management_controller.dart';
import '../../constants/colors_manager.dart';
import '../../constants/fonts_manager.dart';
import '../../constants/styles_manager.dart';
import 'delete_room.dart';

editOrDelete(BuildContext context) {
  var controller = Get.put(RoomManagementController());
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
    builder: (BuildContext context) {
      return Container(
        width: Get.width,
        height: Get.height * 0.30,
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
                right: 30,
                top: 30,
              ),
              child: GestureDetector(
                onTap: () {
                  if (controller.getRooms.roomType == "multiple") {
                    Get.toNamed(Routes.EDIT_MULTIPLE_ROOM);
                  } else {
                    Get.toNamed(Routes.EDIT_SINGLE_ROOM);
                  }
                },
                child: Row(
                  children: [
                    SvgPicture.asset(
                      ImagesManager.editRoom,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      'edit_room_info'.tr,
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
                right: 30,
                top: 5,
              ),
              child: GestureDetector(
                onTap: () {
                  controller.getRoomFeatures();
                  Get.toNamed(Routes.EDIT_ROOM_FEATURE);
                },
                child: Row(
                  children: [
                    SvgPicture.asset(
                      ImagesManager.editRoom,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      'edit_room_features'.tr,
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
                right: 25,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      deleteRoom(context);
                    },
                    child: SvgPicture.asset(
                      ImagesManager.delete,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    'delete_room'.tr,
                    style: getRegularStyle(
                      color: ColorsManager.blackColor,
                      fontSize: FontSizeManager.s14,
                    ),
                  ),
                ],
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
