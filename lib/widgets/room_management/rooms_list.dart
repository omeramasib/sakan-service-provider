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
           width: 341,
           height: 115,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: ColorsManager.borderColor,
              ),
              boxShadow: [
                BoxShadow(
                  color: ColorsManager.shadowColor,
                  // spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 0), // changes position of shadow
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 119,
                  height: 115,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    image: DecorationImage(
                      image: AssetImage(ImagesManager.room_example),
                      fit: BoxFit.cover,
                    ),
                  ),
                  ),
                  // child: Image.asset(
                  //   ImagesManager.room_example,
                  //   fit: BoxFit.cover,
                  // ),
                  SizedBox(
                    width: 15,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                        ),
                        child: Text(
                          'room_number'.tr,
                          style: getRegularStyle(
                            color: ColorsManager.mainColor,
                            fontSize: FontSizeManager.s14,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(
                            ImagesManager.room_type,
                            height: 25,
                            width: 25,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'room_type'.tr,
                            style: getRegularStyle(
                              color: ColorsManager.defaultGreyColor,
                              fontSize: FontSizeManager.s12,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'multi_room'.tr,
                            style: getRegularStyle(
                              color: ColorsManager.blackColor,
                              fontSize: FontSizeManager.s12,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(
                            ImagesManager.rooms,
                            height: 15,
                            width: 10,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'beds_number'.tr,
                            style: getRegularStyle(
                              color: ColorsManager.defaultGreyColor,
                              fontSize: FontSizeManager.s12,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            ': 4',
                            style: getRegularStyle(
                              color: ColorsManager.blackColor,
                              fontSize: FontSizeManager.s12,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  // Container(
                  //   height: 22,
                  //   width: 73,
                  //   decoration: BoxDecoration(
                  //     color: ColorsManager.blueColor,
                  //     borderRadius: BorderRadius.circular(11),
                  //   ),
                  // )
              ],
            ),
          )
        ],
      ),
    ),
  );
}