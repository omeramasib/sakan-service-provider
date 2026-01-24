import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sakan/constants/colors_manager.dart';
import 'package:sakan/constants/fonts_manager.dart';
import 'package:sakan/constants/styles_manager.dart';

Widget step3(BuildContext context , String title1, String title2, String title3){
  return Container(
    width: Get.width,
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
                right: Get.width * 0.05,
              ),
              child: Row(
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
                      title1,
                      style: getRegularStyle(
                        fontSize: FontSizeManager.s10,
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
                    width: 60,
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
                        color: ColorsManager.mainColor,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      title2,
                      style: getRegularStyle(
                        fontSize: FontSizeManager.s10,
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
                    width: 60,
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
                      title3,
                      style: getRegularStyle(
                        fontSize: FontSizeManager.s10,
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