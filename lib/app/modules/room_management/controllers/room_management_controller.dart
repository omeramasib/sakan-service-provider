import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class RoomManagementController extends GetxController {

  RxString imagePath = ''.obs;
  File? image;

  var roomNumberController = TextEditingController();
  var allBedsNumberController = TextEditingController();
  var emptyBedsNumberController = TextEditingController();
  var dailyBedPriceController = TextEditingController();
  var monthlyBedPriceController = TextEditingController();
  final count = 0.obs;

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
  
  @override
  void onInit() {
    super.onInit();
    roomNumberController = TextEditingController();
    allBedsNumberController = TextEditingController();
    emptyBedsNumberController = TextEditingController();
    dailyBedPriceController = TextEditingController();
    monthlyBedPriceController = TextEditingController();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    roomNumberController.dispose();
    allBedsNumberController.dispose();
    emptyBedsNumberController.dispose();
    dailyBedPriceController.dispose();
    monthlyBedPriceController.dispose();
    super.onClose();
  }

  void increment() => count.value++;
}
