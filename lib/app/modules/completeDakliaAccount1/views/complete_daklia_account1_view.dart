import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sakan/constants/buttons_manager.dart';
import 'package:sakan/constants/colors_manager.dart';
import 'package:sakan/widgets/text_form_fields.dart';

import '../../../../constants/fonts_manager.dart';
import '../../../../constants/styles_manager.dart';
import '../../../../constants/values_manager.dart';
import '../../../../widgets/stepper/step1.dart';
import '../controllers/complete_daklia_account1_controller.dart';

class CompleteDakliaAccount1View
    extends GetView<CompleteDakliaAccount1Controller> {
  const CompleteDakliaAccount1View({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final isEnglish = Get.locale!.languageCode == 'en';
    return Scaffold(
      backgroundColor: ColorsManager.lightGreyColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: AppBar(
          title: Text(
            'daklia_management'.tr,
            style: getMediumStyle(
              fontSize: FontSizeManager.s15,
              color: ColorsManager.whiteColor,
            ),
          ),
          centerTitle: true,
          backgroundColor: ColorsManager.mainColor,
          leading: Padding(
            padding: const EdgeInsets.only(
              right: 25,
            ),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: ColorsManager.whiteColor,
              ),
              onPressed: () => Get.back(),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        width: Get.width,
        height: 78,
        decoration: BoxDecoration(
          color: ColorsManager.whiteColor,
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            right: 50,
          ),
          child: Row(
            children: [
              ButtonsManager.primaryButton(
                text: 'next'.tr,
                onPressed: () {
                  // Get.toNamed(Routes.COMPLETE_DAKLIA_ACCOUNT2);
                  // print('clicked');
                  controller.checkSendDakliaInfo();
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
      ),
      body: SingleChildScrollView(
        child: Form(
          key: controller.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
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
              SizedBox(
                height: 30,
              ),
              Text(
                'warning'.tr,
                style: getRegularStyle(
                  fontSize: FontSizeManager.s14,
                  color: ColorsManager.blackColor,
                  height: 2.5,
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
                            top: AppPadding.p20, left: AppPadding.p65)
                        : const EdgeInsets.only(
                            top: AppPadding.p20, right: AppPadding.p50),
                    child: Text(
                      'daklia_image'.tr,
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
              // widget for add image
              addPhotoWidget(
                context,
                controller,
                'daklia_image'.tr,
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
                      'daklia_description'.tr,
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
              addDescriptionWidget(context, controller),

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
                      'room_count'.tr,
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
              roomCountWidget(
                context,
                controller,
                'room_count'.tr,
              )
            ],
          ),
        ),
      ),
    );
  }
}
