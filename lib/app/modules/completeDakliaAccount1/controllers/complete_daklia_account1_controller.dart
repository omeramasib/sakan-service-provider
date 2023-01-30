import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CompleteDakliaAccount1Controller extends GetxController {

  RxString imagePath = ''.obs;
  File? image;

  TextEditingController descriptionController = TextEditingController();
  TextEditingController roomCountController = TextEditingController();

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

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    descriptionController = TextEditingController();
    roomCountController = TextEditingController();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    descriptionController.dispose();
    roomCountController.dispose();
  }

  void increment() => count.value++;
}
