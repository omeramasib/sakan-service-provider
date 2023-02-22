import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sakan/constants/buttons_manager.dart';
import 'package:sakan/constants/colors_manager.dart';
import 'package:sakan/constants/fonts_manager.dart';
import 'package:sakan/constants/images_manager.dart';
import 'package:sakan/constants/styles_manager.dart';

import '../rooms_types/rooms_types.dart';
import 'add_regulations.dart';

Widget emptyRegulation(BuildContext context) {
  var isEnglish = Get.locale!.languageCode == 'en';
  return Column(
    children: [
      SizedBox(
        height: Get.height * 0.15,
      ),
      Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: ColorsManager.whiteColor,
        ),
        child: Center(
            child: SvgPicture.asset(
          ImagesManager.terms,
          width: 40,
          height: 40,
        )),
      ),
      SizedBox(
        height: 15,
      ),
      Text(
        'empty_regulation'.tr,
          style: getMediumStyle(
            color: ColorsManager.mainColor,
            fontSize: FontSizeManager.s16,
          )),
      SizedBox(
        height: 10,
      ),
      Padding(
        padding: isEnglish
            ? EdgeInsets.only(
                left: 20,
              )
            : const EdgeInsets.only(
                right: 20,
              ),
        child: Text(
           'empyt_regulation_des'.tr,
            style: getRegularStyle(
              color: ColorsManager.blackColor,
              fontSize: FontSizeManager.s14,
              height: 2,
            )),
      ),
      SizedBox(
        height: 20,
      ),
      ButtonsManager.primaryButton(
        text: 'add_regulation'.tr,
        onPressed: (){
          // selectRoomTypes(context);
          addRegulation(context);
        },
        context: context,
        minimumSize: Size(188, 50),
        maximumSize: Size(188, 50),
        )
    ],
  );
}