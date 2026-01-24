import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../constants/colors_manager.dart';
import '../../../constants/fonts_manager.dart';
import '../../../constants/images_manager.dart';
import '../../../constants/styles_manager.dart';

no_features(BuildContext context) {
  return Column(
    children: [
      SizedBox(
        height: Get.height * 0.10,
      ),
      Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: ColorsManager.greyColor,
        ),
        child: Center(
            child: SvgPicture.asset(
          ImagesManager.rooms,
          width: 40,
          height: 40,
        )),
      ),
      SizedBox(
        height: 10,
      ),
      Text(
        'no_features'.tr,
        style: getMediumStyle(
          color: ColorsManager.blackColor,
          fontSize: FontSizeManager.s14,
        ),
      ),
    ],
  );
}
