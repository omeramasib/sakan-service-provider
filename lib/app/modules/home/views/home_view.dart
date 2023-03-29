import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sakan/app/routes/app_pages.dart';
import 'package:sakan/constants/colors_manager.dart';
import 'package:sakan/constants/fonts_manager.dart';
import 'package:sakan/constants/images_manager.dart';
import 'package:sakan/constants/styles_manager.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var isArabic = Get.locale?.languageCode == 'ar';
    var storage = GetStorage();
    return Scaffold(
      backgroundColor: ColorsManager.lightGreyColor,
      body: Column(children: [
        SizedBox(height: 80),
        Padding(
          padding:
              isArabic ? EdgeInsets.only(right: 20) :
               EdgeInsets.only(left: 20),
          child: Row(
            children: [
              SizedBox(
                width: 140,
              ),
              Text(
                'home'.tr,
                style: getRegularStyle(
                  color: ColorsManager.blackColor,
                  fontSize: FontSizeManager.s16,
                ),
              ),
              SizedBox(
                width: 130,
              ),
              GestureDetector(
                onTap: () {
                  Get.toNamed('/notifications');
                },
                child: SvgPicture.asset(
                  ImagesManager.notification,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 50,
        ),

        // 1st Row
        Container(
          height: 171,
          width: double.infinity,
          child: LayoutBuilder(
            builder: (BuildContext, BoxConstraints constraints) {
              return Row(
                children: [
                  Padding(
                    padding:
                    isArabic ? EdgeInsets.only(right: Get.width * 0.07):
                     EdgeInsets.only(left: Get.width * 0.07),
                    child: GestureDetector(
                      onTap: () {
                        // Get.toNamed(Routes.COMPLETE_DAKLIA_ACCOUNT1);
                        if (storage.read('dakliaId') == null) {
                          Get.toNamed(Routes.COMPLETE_DAKLIA_ACCOUNT1);
                        } else {
                          Get.toNamed(Routes.DAKLIA_PROFILE);
                        }
                      },
                      child: Container(
                        height: 171,
                        width: 164,
                        decoration: BoxDecoration(
                          color: ColorsManager.whiteColor,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: ColorsManager.shadowColor,
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 30,
                              ),
                              SvgPicture.asset(
                                ImagesManager.building,
                                height: 65,
                                width: 60,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                'daklia_management'.tr,
                                style: getRegularStyle(
                                  color: ColorsManager.fontColor,
                                  fontSize: FontSizeManager.s15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: isArabic ? EdgeInsets.only(right: 10):
                     EdgeInsets.only(left: 10),
                    child: GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.ROOM_MANAGEMENT);
                      },
                      child: Container(
                        height: 171,
                        width: 164,
                        decoration: BoxDecoration(
                          color: ColorsManager.whiteColor,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: ColorsManager.shadowColor,
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 30,
                              ),
                              SvgPicture.asset(
                                ImagesManager.rooms,
                                height: 65,
                                width: 60,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                'rooms_management'.tr,
                                style: getRegularStyle(
                                  color: ColorsManager.fontColor,
                                  fontSize: FontSizeManager.s15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        SizedBox(
          height: 20,
        ),

        // 2st Row
          Container(
          height: 171,
          width: double.infinity,
          child: LayoutBuilder(
            builder: (BuildContext, BoxConstraints constraints) {
              return Row(
                children: [
                  Padding(
                    padding:
                    isArabic ? EdgeInsets.only(right: Get.width * 0.07):
                     EdgeInsets.only(left: Get.width * 0.07),
                    child: GestureDetector(
                      onTap:(){
                        Get.toNamed(Routes.MY_APPOINTMENTS);
                      },
                      child: Container(
                        height: 171,
                        width: 164,
                        decoration: BoxDecoration(
                          color: ColorsManager.whiteColor,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: ColorsManager.shadowColor,
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 30,
                              ),
                              SvgPicture.asset(
                               ImagesManager.booking,
                                height: 65,
                                width: 60,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                'appointments_management'.tr,
                                style: getRegularStyle(
                                  color: ColorsManager.fontColor,
                                  fontSize: FontSizeManager.s15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // SizedBox(
                  //   width: 10,
                  // ),
                  Padding(
                    padding: isArabic ? EdgeInsets.only(right: 10) :
                     EdgeInsets.only(left: 10),
                    child: GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.SERVICES_MANAGEMENT);
                      },
                      child: Container(
                        height: 171,
                        width: 164,
                        decoration: BoxDecoration(
                          color: ColorsManager.whiteColor,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: ColorsManager.shadowColor,
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 30,
                              ),
                              SvgPicture.asset(
                                ImagesManager.service,
                                height: 65,
                                width: 60,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                'services_management'.tr,
                                style: getRegularStyle(
                                  color: ColorsManager.fontColor,
                                  fontSize: FontSizeManager.s15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        SizedBox(
          height: 20,
        ),

        // 3st Row
         GestureDetector(
          onTap: () {
            Get.toNamed(Routes.REGULATIONS_MANAGEMENT);
          },
           child: Container(
            height: 171,
            width: double.infinity,
            child: LayoutBuilder(
              builder: (BuildContext, BoxConstraints constraints) {
                return Row(
                  children: [
                    Padding(
                      padding:
                      isArabic ? EdgeInsets.only(right: Get.width * 0.07):
                       EdgeInsets.only(left: Get.width * 0.07),
                      child: Container(
                        height: 171,
                        width: 164,
                        decoration: BoxDecoration(
                          color: ColorsManager.whiteColor,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: ColorsManager.shadowColor,
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 30,
                              ),
                              SvgPicture.asset(
                              ImagesManager.terms,
                                height: 65,
                                width: 60,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                'terms'.tr,
                                style: getRegularStyle(
                                  color: ColorsManager.fontColor,
                                  fontSize: FontSizeManager.s15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: isArabic ? EdgeInsets.only(right: 10) :
                       EdgeInsets.only(left: 10),
                      child: GestureDetector(
                        onTap: () {
                          Get.toNamed(Routes.MORE_SCREEN);
                        },
                        child: Container(
                          height: 171,
                          width: 164,
                          decoration: BoxDecoration(
                            color: ColorsManager.whiteColor,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: ColorsManager.shadowColor,
                                blurRadius: 6,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 30,
                                ),
                                SvgPicture.asset(
                                 ImagesManager.setting,
                                  height: 65,
                                  width: 60,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                   'settings'.tr,
                                  style: getRegularStyle(
                                    color: ColorsManager.fontColor,
                                    fontSize: FontSizeManager.s15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
                 ),
         ),
      ]),
    );
  }
}
