import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sakan/constants/images_manager.dart';

import '../../constants/colors_manager.dart';

selectImage(BuildContext context, dynamic controller) {
  var isArabic = Get.locale!.languageCode == 'ar';
  // var controller = Get.put(EditProfileController());
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
        height: Get.height * 0.3,
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
              // padding: const EdgeInsets.only(top: 30, right: 80),
              padding: isArabic
                  ? EdgeInsets.only(top: 50, right: Get.width * 0.25)
                  : EdgeInsets.only(top: 50, left: Get.width * 0.25),
              child: Row(
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        controller.getImageFromCamera(ImageSource.camera);
                      },
                      child: Container(
                        width: 90,
                        height: 80,
                        decoration: const BoxDecoration(
                          color: ColorsManager.lightGreyColor,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Image.asset(
                              ImagesManager.camera,
                              width: 30,
                              height: 30,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text('camera'.tr)
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      controller.getImageFromGallery(ImageSource.gallery);
                    },
                    child: Container(
                      width: 90,
                      height: 80,
                      decoration: const BoxDecoration(
                        color: ColorsManager.lightGreyColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Image.asset(
                            ImagesManager.gallery,
                            width: 30,
                            height: 30,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text('gallery'.tr)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      );
    },
  );
}