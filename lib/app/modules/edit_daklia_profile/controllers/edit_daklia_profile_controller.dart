import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../dakliaProfile/controllers/daklia_profile_controller.dart';
import '../provider/update_profile_provider.dart';

class EditDakliaProfileController extends GetxController {
  TextEditingController roomCountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  var provider = UpdateProfileProvider();
  var profileController = Get.put(DakliaProfileController());
  RxString imagePath = ''.obs;
  File? image;
  RxString dakliaDescription = ''.obs;
  RxInt roomCount = 0.obs;

  void getImageFromGallery(ImageSource imageSource) async {
    final pickedFile = await ImagePicker().pickImage(source: imageSource);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      imagePath.value = pickedFile.path;
      update();
      Get.back();
    }
    update();
  }

  void getImageFromCamera(ImageSource imageSource) async {
    final pickedFile = await ImagePicker().pickImage(source: imageSource);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      imagePath.value = pickedFile.path;
      update();
      Get.back();
    }
    update();
  }

  Future<void> sendUpdateProfile() async {
    print(
        'this is the old image: ${profileController.profileList[0].dakliaImage!.split('/').last}');
    print('this is the daklia description: $dakliaDescription');
    // EasyLoading.show(status: 'loading'.tr);
    return await provider
        .updateProfile(
      dakliaDescription: dakliaDescription.value == ''
          ? dakliaDescription.value =
              profileController.profileList[0].dakliaDescription!
          : dakliaDescription.value,
      numberOfRooms: roomCount.value == 0
          ? roomCount.value = profileController.profileList[0].numberOfRooms!
          : roomCount.value,
      image: imagePath.value == ''
          ? image = File(
              profileController.profileList[0].dakliaImage!.split('/').last)
          : image = image!,
    )
        .timeout(
      Duration(seconds: 3),
      onTimeout: () {
        EasyLoading.dismiss();
      },
    );
  }

  @override
  void onInit() {
    super.onInit();
    roomCountController = TextEditingController();
    descriptionController = TextEditingController();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    roomCountController.dispose();
    descriptionController.dispose();
  }
}
