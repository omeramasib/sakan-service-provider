import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sakan/constants/images_manager.dart';

import '../../constants/colors_manager.dart';
import '../../constants/fonts_manager.dart';
import '../../constants/styles_manager.dart';
import 'delete_regulation.dart';
import 'edite_regulation.dart';

editOrDeleteRegulation(BuildContext context) {
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
                right: 30,
                top: 30,
              ),
              child: GestureDetector(
                onTap: () {
                  editRegulation(context);
                },
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        editRegulation(context);
                      },
                      child: SvgPicture.asset(
                        ImagesManager.editRoom,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      'edit_regulation'.tr,
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
              child: GestureDetector(
                onTap: () {
                      deleteRegulation(context);
                    },
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        deleteRegulation(context);
                      },
                      child: SvgPicture.asset(
                        ImagesManager.delete,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      'delete_regulation'.tr,
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
