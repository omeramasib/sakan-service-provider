import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/modules/ChangeLocationOnMap/controllers/change_location_on_map_controller.dart';
import '../../constants/buttons_manager.dart';
import '../../constants/colors_manager.dart';
import '../../constants/fonts_manager.dart';
import '../../constants/styles_manager.dart';
import '../../constants/values_manager.dart';
import '../text_form_fields.dart';

changeAdditionalAddress(BuildContext context) {
  final isEnglish = Get.locale!.languageCode == 'en';
  final controller = Get.put(ChangeLocationOnMapController());
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
        height: Get.height * 0.6,
        width: Get.width,
        decoration: BoxDecoration(
          color: ColorsManager.whiteColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Form(
          key: controller.formKey,
          child: Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 50,
                    ),
                    child: Text(
                      'other_detailes'.tr,
                      style: getMediumStyle(
                        fontSize: FontSizeManager.s15,
                        color: ColorsManager.fontColor,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: isEnglish
                            ? const EdgeInsets.only(
                                top: AppPadding.p20, left: AppPadding.p65)
                            : const EdgeInsets.only(
                                top: AppPadding.p20, right: AppPadding.p50),
                        child: Text(
                          'address_details_des'.tr,
                          style: getRegularStyle(
                            color: ColorsManager.mainColor,
                            fontSize: FontSizeManager.s14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  addressDetailsWidget(
                      context, controller, 'address_details'.tr),
                  SizedBox(
                    height: Get.height * 0.09,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      right: Get.width * 0.1,
                    ),
                    child: Row(
                      children: [
                        ButtonsManager.primaryButton(
                          text: 'save_changes'.tr,
                          onPressed: () {
                            print('DEBUG: Button pressed!');
                            controller.checkChangeAddress();
                          },
                          context: context,
                          maximumSize: Size(315, 50),
                          minimumSize: Size(315, 50),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
