import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/modules/completeDakliaAccount2/controllers/complete_daklia_account2_controller.dart';
import '../../constants/buttons_manager.dart';
import '../../constants/colors_manager.dart';
import '../../constants/fonts_manager.dart';
import '../../constants/styles_manager.dart';
import '../../constants/values_manager.dart';
import '../text_form_fields.dart';

additionalAddress(BuildContext context) {
  final isEnglish = Get.locale!.languageCode == 'en';
  final controller = Get.put(CompleteDakliaAccount2Controller());
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
        height: Get.height * 0.4,
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
                      top: 20,
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
                    height: Get.height * 0.05,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      right: Get.width * 0.1,
                    ),
                    child: Row(
                      children: [
                        ButtonsManager.primaryButton(
                          text: 'next'.tr,
                          onPressed: () {
                            controller.checkSendAddress();
                            // Get.toNamed(Routes.COMPLETE_DAKLIA_ACCOUNT3);
                            // print('clicked');
                          },
                          context: context,
                          maximumSize: Size(174, 50),
                          minimumSize: Size(174, 50),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        ButtonsManager.primaryButton(
                          text: 'previous'.tr,
                          onPressed: () {
                            Get.back();
                          },
                          context: context,
                          maximumSize: Size(134, 50),
                          minimumSize: Size(134, 50),
                          buttonColor: ColorsManager.greyColor,
                          textColor: ColorsManager.blackColor,
                        )
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
