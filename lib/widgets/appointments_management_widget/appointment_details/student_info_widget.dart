import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../constants/colors_manager.dart';
import '../../../constants/fonts_manager.dart';
import '../../../constants/images_manager.dart';
import '../../../constants/styles_manager.dart';

studentInfoWidget(BuildContext context) {
  return Container(
    child: Column(
      children: [
        SizedBox(
          height: 30,
        ),
        Container(
          width: 315,
          height: 202,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: ColorsManager.whiteColor,
            border: Border.all(
              color: ColorsManager.borderColor,
            ),
            boxShadow: [
              BoxShadow(
                color: ColorsManager.shadowColor,
                blurRadius: 7,
                offset: Offset(0, 0), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 20,
                      top: 10,
                    ),
                    child: Text(
                      'main_info'.tr,
                      style: getMediumStyle(
                        color: ColorsManager.mainColor,
                        fontSize: FontSizeManager.s15,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 20,
                    ),
                    child: SvgPicture.asset(
                      ImagesManager.id,
                      height: 14,
                      width: 18,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'id'.tr,
                    style: getRegularStyle(
                      color: ColorsManager.defaultGreyColor,
                      fontSize: FontSizeManager.s12,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    ": 406070664",
                    style: getRegularStyle(
                      color: ColorsManager.blackColor,
                      fontSize: FontSizeManager.s12,
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Divider(),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 20,
                    ),
                    child: SvgPicture.asset(
                      ImagesManager.id,
                      height: 14,
                      width: 18,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'guardian_id'.tr,
                    style: getRegularStyle(
                      color: ColorsManager.defaultGreyColor,
                      fontSize: FontSizeManager.s12,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    ": 406070664",
                    style: getRegularStyle(
                      color: ColorsManager.blackColor,
                      fontSize: FontSizeManager.s12,
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Divider(),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 20,
                    ),
                    child: SvgPicture.asset(
                      ImagesManager.building,
                      height: 20,
                      width: 20,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'university/workplace'.tr,
                    style: getRegularStyle(
                      color: ColorsManager.defaultGreyColor,
                      fontSize: FontSizeManager.s12,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    ": جامعة الرباط",
                    style: getRegularStyle(
                      color: ColorsManager.blackColor,
                      fontSize: FontSizeManager.s12,
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Divider(),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Container(
          width: 315,
          // height: 229,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: ColorsManager.whiteColor,
            border: Border.all(
              color: ColorsManager.borderColor,
            ),
            boxShadow: [
              BoxShadow(
                color: ColorsManager.shadowColor,
                blurRadius: 7,
                offset: Offset(0, 0), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 20,
                      top: 10,
                    ),
                    child: Text(
                      'ID_photo'.tr,
                      style: getMediumStyle(
                        color: ColorsManager.mainColor,
                        fontSize: FontSizeManager.s15,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Image(
                image: AssetImage(ImagesManager.omerId),
                height: 202,
                width: 315,
              ),
            ],
          ),
        )
      ],
    ),
  );
}
