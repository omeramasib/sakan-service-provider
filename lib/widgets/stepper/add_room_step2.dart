import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sakan/constants/colors_manager.dart';
import 'package:sakan/constants/fonts_manager.dart';
import 'package:sakan/constants/styles_manager.dart';

Widget addRoomStep2(BuildContext context){
  return Container(
    width: 341,
    height: 78,
    decoration: BoxDecoration(
      color: ColorsManager.whiteColor,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
       BoxShadow(
        color: ColorsManager.borderColor,
       offset: Offset(0, 0),
       blurRadius: 7,
    )]
    ),
    child: LayoutBuilder(
      builder: (BuildContext , BoxConstraints constraints) {
         return SizedBox(
          height: 78,
          width: constraints.maxWidth,
           child: Column(
           children: [
            Padding(
              padding: EdgeInsets.only(
                top: 25,
                right: 10,
              ),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                Column(
                  children: [
                    Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                        color: ColorsManager.mainColor,
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'room_detailes'.tr,
                      style: getRegularStyle(
                        fontSize: FontSizeManager.s13,
                        color: ColorsManager.fontColor,
                        )
                    ),
                  ]
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 20,
                  ),
                  child: SizedBox(
                    width: Get.width * 0.4,
                    child: Divider(
                          color: ColorsManager.mainColor,
                          thickness: 4,
                          height: 10,
                        ),
                  ),
                ),
                Column(
                  children: [
                    Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: ColorsManager.mainColor,
                          width: 1,
                        )
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'room_features'.tr,
                      style: getRegularStyle(
                        fontSize: FontSizeManager.s13,
                        color: ColorsManager.fontColor,
                        )
                    ),
                  ]
                ),
                ],
              ),
            ),
        ],
      ),
         );
        },
    )
  );
}