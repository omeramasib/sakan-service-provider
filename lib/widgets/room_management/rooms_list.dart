import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sakan/constants/colors_manager.dart';
import 'package:sakan/constants/fonts_manager.dart';
import 'package:sakan/constants/images_manager.dart';
import 'package:sakan/constants/styles_manager.dart';

Widget roomsList(BuildContext context){
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
                :  EdgeInsets.only(
                    right: Get.width * 0.080,
                  ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'rooms'.tr,
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
                    bottom: 10,
                  )
                :  EdgeInsets.only(
                    left: Get.width * 0.060,
                    bottom: 10,
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        ImagesManager.add,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'add_room'.tr,
                        style: getRegularStyle(
                          color: ColorsManager.mainColor,
                          fontSize: FontSizeManager.s12,
                          ),
                      )
                    ]
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(

          )
        ],
      ),
    ),
  );
}