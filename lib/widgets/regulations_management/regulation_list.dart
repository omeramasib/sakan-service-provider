import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sakan/constants/colors_manager.dart';
import 'package:sakan/constants/fonts_manager.dart';
import 'package:sakan/constants/images_manager.dart';
import 'package:sakan/constants/styles_manager.dart';

import 'add_regulations.dart';
import 'edit_or_delete_regulations.dart';

Widget regulationList(BuildContext context) {
  var isEnglish = Get.locale!.languageCode == 'en';
  return Expanded(
    child: Container(
      height: Get.height,
      width: Get.width,
      child: Column(
        children: [
          Padding(
            padding: isEnglish
                ? EdgeInsets.only(
                    left: Get.width * 0.080,
                  )
                : EdgeInsets.only(
                    right: Get.width * 0.080,
                  ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'conditions'.tr,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: isEnglish
                      ? EdgeInsets.only(
                          right: Get.width * 0.060,
                        )
                      : EdgeInsets.only(
                          left: Get.width * 0.060,
                        ),
                  child: Row(children: [
                    GestureDetector(
                      onTap: () {
                        addRegulation(context);
                      },
                      child: SvgPicture.asset(
                        ImagesManager.add,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'add_regulation'.tr,
                      style: getRegularStyle(
                        color: ColorsManager.mainColor,
                        fontSize: FontSizeManager.s12,
                      ),
                    )
                  ]),
                )
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          // Container 1
          Container(
            width: 330,
            decoration: BoxDecoration(
              color: ColorsManager.whiteColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: ColorsManager.shadowColor,
                  // spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 0), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 10,
                        top: 15,
                      ),
                      child: Text(
                        'regulation1'.tr,
                        style: getRegularStyle(
                          color: ColorsManager.mainColor,
                          fontSize: FontSizeManager.s14,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        editOrDeleteRegulation(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 10,
                          top: 15,
                        ),
                        child: SvgPicture.asset(
                          ImagesManager.more,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    right: 10,
                  ),
                  child: Text(
                    'regulation1_des'.tr,
                    style: getRegularStyle(
                      color: ColorsManager.blackColor,
                      fontSize: FontSizeManager.s12,
                      height: 2,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}