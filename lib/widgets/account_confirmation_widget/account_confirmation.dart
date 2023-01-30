import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sakan/app/routes/app_pages.dart';
import 'package:sakan/constants/buttons_manager.dart';
import 'package:sakan/constants/images_manager.dart';
import 'package:sakan/constants/styles_manager.dart';

import '../../constants/colors_manager.dart';
import '../../constants/fonts_manager.dart';

accountConfirmation(BuildContext context) {
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
    builder: (BuildContext context) {
      return Container(
        width: Get.width,
        height: Get.height * 0.5,
        decoration: const BoxDecoration(
          color: ColorsManager.whiteColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 20,
              ),
              child: Container(
                width: 44,
                height: 6,
                decoration: const BoxDecoration(
                  color: ColorsManager.lightGreyColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(4),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 30,
              ),
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  color: ColorsManager.lightGreyColor,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    ImagesManager.confirmation,
                    height: 50,
                    width: 50,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text('confirm_account'.tr,
                style: getMediumStyle(
                  color: ColorsManager.greenColor,
                  fontSize: FontSizeManager.s16,
                )),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.only(
                right: Get.width * 0.15,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text('confirm_account_des'.tr,
                        style: getRegularStyle(
                            color: ColorsManager.blackColor,
                            fontSize: FontSizeManager.s14,
                            height: 2)),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            ButtonsManager.primaryButton(
              text: 'daklia_page'.tr,
              onPressed: () {
                Get.offAllNamed(Routes.DAKLIA_PROFILE);
              },
              context: context,
              maximumSize: Size(287, 50),
              minimumSize: Size(287, 50),
            )
          ],
        ),
      );
    },
  );
}
