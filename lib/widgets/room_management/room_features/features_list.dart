import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sakan/constants/colors_manager.dart';
import 'package:sakan/constants/styles_manager.dart';

import '../../../constants/fonts_manager.dart';
import '../../../constants/images_manager.dart';
import '../edit_or_delete_room.dart';
import 'edit_or_delete_feature.dart';

featuresList(BuildContext context, dynamic controller) {
  return Container(
    width: Get.width,
    height: Get.height * 0.6,
    child: Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Container(
          width: 330,
          height: 73,
          decoration: BoxDecoration(
            color: ColorsManager.greyColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  editOrDeleteFeature(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 15,
                        top: 10,
                      ),
                      child: Text(
                        controller.getFeatures.featureName!,
                        style: getRegularStyle(
                          color: ColorsManager.mainColor,
                          fontSize: FontSizeManager.s14,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 13,
                        left: 15,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          editOrDeleteFeature(context);
                        },
                        child: SvgPicture.asset(
                          ImagesManager.more,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  right: 20,
                ),
                child: Row(
                  children: [
                    Text(
                      'feature1'.tr,
                      style: getRegularStyle(
                        color: ColorsManager.blackColor,
                        fontSize: FontSizeManager.s12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          width: 330,
          height: 73,
          decoration: BoxDecoration(
            color: ColorsManager.greyColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 15,
                      top: 10,
                    ),
                    child: Text(
                      'feature2'.tr,
                      style: getRegularStyle(
                        color: ColorsManager.mainColor,
                        fontSize: FontSizeManager.s14,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 13,
                      left: 15,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        editOrDeleteFeature(context);
                      },
                      child: SvgPicture.asset(
                        ImagesManager.more,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  right: 20,
                ),
                child: Row(
                  children: [
                    Text(
                      'feature2'.tr,
                      style: getRegularStyle(
                        color: ColorsManager.blackColor,
                        fontSize: FontSizeManager.s12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    ),
  );
}
