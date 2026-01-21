import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sakan/constants/styles_manager.dart';

import '../../../../constants/colors_manager.dart';
import '../../../../constants/values_manager.dart';
import '../controllers/auth_controller.dart';

Widget loginOrRegister(BuildContext context) {
  var controller = Get.put(AuthController());
  return Padding(
    padding: const EdgeInsets.only(top: AppPadding.p40),
    child: Obx(
      () => GestureDetector(
        onTap: () {
          controller.selectLoginOrRegister = false;
        },
        child: Container(
          width: 315,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSize.s50),
            color: ColorsManager.greyColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 157,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSize.s50),
                  color: controller.selectValue.value == false
                      ? ColorsManager.mainColor
                      : ColorsManager.lightGreyColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'login'.tr,
                      style: getRegularStyle(
                            fontSize: AppSize.s14,
                            color: controller.selectValue.value == false
                                ? ColorsManager.whiteColor
                                : ColorsManager.fontColor,
                          ),
                    ),
                    const SizedBox(
                      width: 12.0,
                    ),
                  ],
                ),
              ),
              Obx(
                (() => GestureDetector(
                      onTap: () {
                        controller.selectLoginOrRegister = true;
                      },
                      child: Container(
                        width: 157,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(AppSize.s50),
                          color: controller.selectValue.value == true
                              ? ColorsManager.mainColor
                              : ColorsManager.lightGreyColor,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'create account'.tr,
                              style: getRegularStyle(
                                    fontSize: AppSize.s14,
                                    color: controller.selectValue.value == true
                                        ? ColorsManager.whiteColor
                                        : ColorsManager.fontColor,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    )),
              )
            ],
          ),
        ),
      ),
    ),
  );
}