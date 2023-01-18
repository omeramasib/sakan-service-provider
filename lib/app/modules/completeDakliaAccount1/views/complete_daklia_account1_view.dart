import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sakan/constants/colors_manager.dart';

import '../../../../constants/fonts_manager.dart';
import '../../../../constants/styles_manager.dart';
import '../../../../widgets/stepper/step1.dart';
import '../controllers/complete_daklia_account1_controller.dart';

class CompleteDakliaAccount1View
    extends GetView<CompleteDakliaAccount1Controller> {
  const CompleteDakliaAccount1View({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorsManager.lightGreyColor,
        // appBar: AppBar(
        //   title: const Text('CompleteDakliaAccount1View'),
        //   centerTitle: true,
        // ),
        body: Column(
          children: [
            Container(
              height: 120,
              width: Get.width,
              decoration: BoxDecoration(
                color: ColorsManager.mainColor,
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 20,
                  right: 25,
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: ColorsManager.whiteColor,
                      ),
                      onPressed: () => Get.back(),
                    ),
                    SizedBox(
                      width: 90,
                    ),
                    Text(
                     'daklia_management'.tr,
                      style: getMediumStyle(
                        fontSize: FontSizeManager.s15,
                        color: ColorsManager.whiteColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(
                right: 30,
                left: 40,
              ),
              child: step1(context, "daklia_information".tr, "address".tr,
                  "daklia_documentation".tr),
            ),
          ],
        ));
  }
}
