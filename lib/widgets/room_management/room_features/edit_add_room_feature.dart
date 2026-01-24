import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sakan/constants/buttons_manager.dart';
import 'package:sakan/constants/fonts_manager.dart';
import 'package:sakan/constants/styles_manager.dart';

import '../../../app/modules/room_management/controllers/room_management_controller.dart';
import '../../../constants/colors_manager.dart';
import '../../../constants/values_manager.dart';
import '../../text_form_fields.dart';

editAddRoomFeatures(BuildContext context) {
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
        height: Get.height * 0.6,
        decoration: const BoxDecoration(
          color: ColorsManager.whiteColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Form(
              key: controller.editAddFeaturesFormKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
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
                      'add_room_features'.tr,
                      style: getMediumStyle(
                          color: ColorsManager.blackColor,
                          fontSize: FontSizeManager.s15),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: isEnglish
                            ? const EdgeInsets.only(
                                top: AppPadding.p20, left: AppPadding.p40)
                            : const EdgeInsets.only(
                                top: AppPadding.p20, right: AppPadding.p30),
                        child: Text(
                          'feature'.tr,
                          style: getRegularStyle(
                            color: ColorsManager.mainColor,
                            fontSize: FontSizeManager.s14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  featureWidget(context, controller, 'feature_des'.tr),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: isEnglish
                            ? const EdgeInsets.only(
                                top: AppPadding.p20, left: AppPadding.p40)
                            : const EdgeInsets.only(
                                top: AppPadding.p20, right: AppPadding.p30),
                        child: Text(
                          'otherDetails'.tr,
                          style: getRegularStyle(
                            color: ColorsManager.mainColor,
                            fontSize: FontSizeManager.s14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  otherDetailsWidget(context, controller),
                  SizedBox(
                    height: Get.height * 0.1,
                  ),
                  ButtonsManager.primaryButton(
                    text: 'add_feature'.tr,
                    onPressed: () {
                      final success = controller.checkEditAddRoomFeature();
                      if (success) {
                        Get.back();
                      }
                    },
                    context: context,
                    minimumSize: Size(287, 50),
                    maximumSize: Size(287, 50),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
