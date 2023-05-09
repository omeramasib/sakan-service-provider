import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sakan/constants/buttons_manager.dart';
import 'package:sakan/constants/fonts_manager.dart';
import 'package:sakan/constants/styles_manager.dart';

import '../../../constants/colors_manager.dart';
import '../../../constants/values_manager.dart';
import '../../app/modules/services_management/controllers/services_management_controller.dart';
import '../text_form_fields.dart';

addService(BuildContext context) {
  final isEnglish = Get.locale!.languageCode == 'en';
  final controller = Get.put(ServicesManagementController());
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
              key: controller.formKey,
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
                      'add_new_service'.tr,
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
                          'service_name'.tr,
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
                  serviceNameWidget(context, controller, 'service_name'.tr),
                  // featureWidget(context, controller, 'feature_des'.tr),
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
                          'service_price'.tr,
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
                  servicePriceWidget(context, controller, '0'),
                  SizedBox(
                    height: 20,
                  ),
                  // Service Type Widget
                  Row(
                    children: [
                      Padding(
                        padding: isEnglish
                            ? const EdgeInsets.only(
                                top: AppPadding.p20, left: AppPadding.p40)
                            : const EdgeInsets.only(
                                top: AppPadding.p20, right: AppPadding.p30),
                        child: Text(
                          'service_description'.tr,
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
                  serviceDescriptionWidget(
                      context, controller, 'service_description'.tr),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: isEnglish
                                ? const EdgeInsets.only(
                                    top: 5, left: AppPadding.p30)
                                : const EdgeInsets.only(
                                    top: 5, right: AppPadding.p30),
                            child: Obx(
                              () => Checkbox(
                                value: controller.isAvailable.value,
                                checkColor: ColorsManager.whiteColor,
                                fillColor: MaterialStateProperty.all(
                                  ColorsManager.mainColor,
                                ),
                                onChanged: (value) {
                                  controller.chooseIsAvailable(value!);
                                },
                              ),
                            ),
                          ),
                          Text(
                            'service_active_right_now'.tr,
                            style: getRegularStyle(
                              color: ColorsManager.fontColor,
                              fontSize: FontSizeManager.s14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ButtonsManager.primaryButton(
                    text: 'add_service'.tr,
                    onPressed: () {
                      controller.checkAddService();
                      Get.back();
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
