import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sakan/constants/fonts_manager.dart';
import 'package:sakan/constants/styles_manager.dart';

import '../../../app/modules/room_management/controllers/room_management_controller.dart';
import '../../../constants/colors_manager.dart';
import '../../../constants/images_manager.dart';
import '../../stepper/add_room_step2.dart';
import '../next_or_previous2.dart';
import 'add_room_feature.dart';
import 'edit_add_room_feature.dart';
import 'features_list.dart';
import 'no_features.dart';

roomFeatures(BuildContext context) {
  final isEnglish = Get.locale!.languageCode == 'en';
  final controller = Get.put(RoomManagementController());
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    constraints: BoxConstraints(
      maxHeight: Get.height,
    ),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20.0),
      ),
    ),
    builder: (context) {
      return Container(
        width: Get.width,
        height: Get.height * 0.9,
        decoration: const BoxDecoration(
          color: ColorsManager.whiteColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SingleChildScrollView(
          child:

        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 20,
              ),
              child: Container(
                width: 44,
                height: 8,
                decoration: const BoxDecoration(
                  color: ColorsManager.lightGreyColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(4),
                  ),
               ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                'add_room'.tr,
                style: getMediumStyle(
                    color: ColorsManager.blackColor,
                    fontSize: FontSizeManager.s15),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            addRoomStep2(context),
            SizedBox(
              height: 20,
            ),
            Container(
              width: Get.width,
              height: Get.height * 0.6,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // This is row 1
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
                            'room_features'.tr,
                            style: getRegularStyle(
                              color: ColorsManager.blackColor,
                              fontSize: FontSizeManager.s16,
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
                                  editAddRoomFeatures(context);
                                },
                                child: SvgPicture.asset(
                                  ImagesManager.add,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'add_feature'.tr,
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
                    // featuresList(context, controller),
                    // no_features(context),
                    Obx(() {
                      if (controller.isLoading.value) {
                        return Center(
                            child: CircularProgressIndicator(
                          color: ColorsManager.mainColor,
                        ));
                      } else {
                        return controller.featuresList.isEmpty
                            ? no_features(context)
                            : featuresList(context, controller);
                      }
                    }),
                  ],
                ),
              ),
            ),
            nextOrPrevious2Button(context),
          ],
        ),
        ),
      );
    },
  );
}
