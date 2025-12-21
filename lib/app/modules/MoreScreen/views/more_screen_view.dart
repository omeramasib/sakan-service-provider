import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:sakan/constants/images_manager.dart';

import '../../../../constants/colors_manager.dart';
import '../../../../constants/fonts_manager.dart';
import '../../../../constants/styles_manager.dart';
import '../../../../constants/values_manager.dart';
import '../../Auth/change_password/change_password.dart';
import '../controllers/more_screen_controller.dart';

class MoreScreenView extends GetView<MoreScreenController> {
  const MoreScreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var controller = MoreScreenController();
    var isArabic = Get.locale!.languageCode == 'ar';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsManager.greyColor,
        elevation: 0,
        title: Text(
          'settings'.tr,
          style: getMediumStyle(
            color: ColorsManager.mainColor,
            fontSize: FontSizeManager.s16,
          ),
        ),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(
            right: AppPadding.p20,
          ),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: ColorsManager.blackColor,
            ),
            onPressed: () => Get.back(),
          ),
        ),
      ),
      body: Scaffold(
        backgroundColor: ColorsManager.greyColor,
        body: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 500),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 30,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: ColorsManager.whiteColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        // Change Password field
                        GestureDetector(
                          onTap: () {
                            // Get.toNamed(Routes.CHANGE_PASSWORD);
                            Get.to(ChangePasswordView());
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: isArabic
                                    ? const EdgeInsets.only(top: 20, right: 20)
                                    : const EdgeInsets.only(top: 20, left: 15),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      ImagesManager.lockIcon,
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      'change_password'.tr,
                                      style: getRegularStyle(
                                        color: ColorsManager.fontColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: isArabic
                                    ? const EdgeInsets.only(top: 10)
                                    : const EdgeInsets.only(top: 10),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: isArabic
                                          ? const EdgeInsets.only(
                                              top: 10, left: 30)
                                          : const EdgeInsets.only(
                                              top: 10, right: 30),
                                      child: const Icon(
                                        Icons.arrow_forward_ios,
                                        color: ColorsManager.mainColor,
                                        size: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: isArabic
                              ? const EdgeInsets.only(
                                  top: 5, left: 20, right: 20)
                              : const EdgeInsets.only(
                                  top: 5, left: 20, right: 20),
                          child: const Divider(
                            color: ColorsManager.mainColor,
                            thickness: 0.1,
                          ),
                        ),

                        // Notification Field
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: isArabic
                                  ? const EdgeInsets.only(top: 20, right: 20)
                                  : const EdgeInsets.only(top: 20, left: 15),
                              child: Row(
                                children: [
                                  SvgPicture.asset(ImagesManager.notification),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    'notifications'.tr,
                                    style: getRegularStyle(
                                      color: ColorsManager.fontColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: isArabic
                                      ? const EdgeInsets.only(top: 20, left: 20)
                                      : const EdgeInsets.only(
                                          top: 20, right: 20),
                                  child: Obx(
                                    () => CupertinoSwitch(
                                      value: controller.toogleStatus.value,
                                      activeColor: const Color(0xff2ECC71),
                                      onChanged: (value) {
                                        controller.changeToogleStatus(value);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Padding(
                          padding: isArabic
                              ? const EdgeInsets.only(left: 20, right: 20)
                              : const EdgeInsets.only(left: 20, right: 20),
                          child: const Divider(
                            color: ColorsManager.primaryColor,
                            thickness: 0.1,
                          ),
                        ),

                        // Contact Support field
                        GestureDetector(
                          onTap: () {
                            // addNewTicketWidget(context);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: isArabic
                                    ? const EdgeInsets.only(top: 20, right: 15)
                                    : const EdgeInsets.only(top: 20, left: 15),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      ImagesManager.callcenterIcon,
                                      color: ColorsManager.mainColor,
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      'connect_with_support'.tr,
                                      style: getRegularStyle(
                                        color: ColorsManager.fontColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: isArabic
                                    ? const EdgeInsets.only(top: 20)
                                    : const EdgeInsets.only(top: 20),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: isArabic
                                          ? const EdgeInsets.only(
                                              top: 5, left: 30)
                                          : const EdgeInsets.only(
                                              top: 5, right: 30),
                                      child: GestureDetector(
                                        onTap: () {
                                          // addNewTicketWidget(context);
                                        },
                                        child: const Icon(
                                          Icons.arrow_forward_ios,
                                          color: ColorsManager.mainColor,
                                          size: 10,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: isArabic
                              ? const EdgeInsets.only(
                                  top: 5, left: 20, right: 20)
                              : const EdgeInsets.only(
                                  top: 5, left: 20, right: 20),
                          child: const Divider(
                            color: ColorsManager.mainColor,
                            thickness: 0.1,
                          ),
                        ),

                        // Terms and Conditon field
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: isArabic
                                  ? const EdgeInsets.only(top: 20, right: 15)
                                  : const EdgeInsets.only(top: 20, left: 15),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    ImagesManager.fileIcon,
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    'conditions_and_terms'.tr,
                                    style: getRegularStyle(
                                      color: ColorsManager.fontColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: isArabic
                                  ? const EdgeInsets.only(top: 20)
                                  : const EdgeInsets.only(top: 20),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: isArabic
                                        ? const EdgeInsets.only(
                                            top: 5, left: 30)
                                        : const EdgeInsets.only(
                                            top: 5, right: 30),
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: const Icon(
                                        Icons.arrow_forward_ios,
                                        color: ColorsManager.mainColor,
                                        size: 10,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: isArabic
                              ? const EdgeInsets.only(
                                  top: 5, left: 20, right: 20)
                              : const EdgeInsets.only(
                                  top: 5, left: 20, right: 20),
                          child: const Divider(
                            color: ColorsManager.primaryColor,
                            thickness: 0.1,
                          ),
                        ),

                        // Privacy Policiy field
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: isArabic
                                  ? const EdgeInsets.only(top: 20, right: 15)
                                  : const EdgeInsets.only(top: 20, left: 15),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    ImagesManager.fileIcon,
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    'privacy_policy'.tr,
                                    style: getRegularStyle(
                                      color: ColorsManager.fontColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: isArabic
                                  ? const EdgeInsets.only(top: 20)
                                  : const EdgeInsets.only(top: 20),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: isArabic
                                        ? const EdgeInsets.only(
                                            top: 5, left: 30)
                                        : const EdgeInsets.only(
                                            top: 5, right: 30),
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: const Icon(
                                        Icons.arrow_forward_ios,
                                        color: ColorsManager.mainColor,
                                        size: 10,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: isArabic
                              ? const EdgeInsets.only(
                                  top: 5, left: 20, right: 20)
                              : const EdgeInsets.only(
                                  top: 5, left: 20, right: 20),
                          child: const Divider(
                            color: ColorsManager.primaryColor,
                            thickness: 0.1,
                          ),
                        ),

                        // Rate App field
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: isArabic
                                  ? const EdgeInsets.only(top: 20, right: 20)
                                  : const EdgeInsets.only(top: 20, left: 20),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    ImagesManager.starIcon,
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    'rate_app'.tr,
                                    style: getRegularStyle(
                                      color: ColorsManager.fontColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: isArabic
                                  ? const EdgeInsets.only(top: 20)
                                  : const EdgeInsets.only(top: 20),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: isArabic
                                        ? const EdgeInsets.only(
                                            top: 5, left: 30)
                                        : const EdgeInsets.only(
                                            top: 5, right: 30),
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: const Icon(
                                        Icons.arrow_forward_ios,
                                        color: ColorsManager.mainColor,
                                        size: 10,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: isArabic
                              ? const EdgeInsets.only(
                                  top: 5, left: 20, right: 20)
                              : const EdgeInsets.only(
                                  top: 5, left: 20, right: 20),
                          child: const Divider(
                            color: ColorsManager.mainColor,
                            thickness: 0.1,
                          ),
                        ),

                        // Logout Field
                        GestureDetector(
                          onTap: () async {
                            await controller.submitLogot();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: isArabic
                                    ? const EdgeInsets.only(top: 10, right: 20)
                                    : const EdgeInsets.only(top: 10, left: 15),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(ImagesManager.logoutIcon),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'logout'.tr,
                                      style: getRegularStyle(
                                        color: ColorsManager.errorColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: isArabic
                              ? const EdgeInsets.only(
                                  top: 5, left: 20, right: 20)
                              : const EdgeInsets.only(
                                  top: 5, left: 20, right: 20),
                          child: const Divider(
                            color: ColorsManager.primaryColor,
                            thickness: 0.1,
                          ),
                        ),

                        // Delete Account Field
                        GestureDetector(
                          onTap: () {
                            // deleteAccount(context);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: isArabic
                                    ? const EdgeInsets.only(top: 10, right: 20)
                                    : const EdgeInsets.only(top: 10, left: 15),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(ImagesManager.trashIcon),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'delete_account'.tr,
                                      style: getRegularStyle(
                                        color: ColorsManager.errorColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: isArabic
                              ? const EdgeInsets.only(
                                  top: 5, left: 20, right: 20)
                              : const EdgeInsets.only(
                                  top: 5, left: 20, right: 20),
                          child: const Divider(
                            color: ColorsManager.primaryColor,
                            thickness: 0.1,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
