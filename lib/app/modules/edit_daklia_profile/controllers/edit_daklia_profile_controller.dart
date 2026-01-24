import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../constants/dialogs.dart';
import '../../dakliaProfile/controllers/daklia_profile_controller.dart';
import '../provider/update_profile_provider.dart';

class EditDakliaProfileController extends GetxController {
  TextEditingController roomCountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  var provider = UpdateProfileProvider();
  var profileController = Get.put(DakliaProfileController());
  RxString imagePath = ''.obs;
  File image = File('');
  String dakliaDescription = '';
  int roomCount = 0;

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
    print('this is the daklia description: ${dakliaDescription}');

    print('this is the number of rooms: ${roomCount}');
    // EasyLoading.show(status: 'loading'.tr);
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return Dialogs.errorDialog(
        Get.context!, 'please_select_at_least_one_field'.tr
      );
    }

    formKey.currentState!.save();
    return await provider
        .updateProfile(
      dakliaDescription: dakliaDescription == ''
          ? dakliaDescription =
              profileController.profileList[0].dakliaDescription!
          : dakliaDescription,
      numberOfRooms: roomCount == 0
          ? roomCount = profileController.profileList[0].numberOfRooms!
          : roomCount,
      image: image
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
