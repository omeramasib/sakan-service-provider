import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/modules/room_management/controllers/room_management_controller.dart';
import '../../constants/buttons_manager.dart';
import '../../constants/colors_manager.dart';

nextOrPreviousButton(BuildContext context, int number) {
  var controller = Get.put(RoomManagementController());
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
              if (number == 0){
                controller.checkAddRoom();
              }
              else if (number == 1){
                controller.checkAddSingleRoom();
              }
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
