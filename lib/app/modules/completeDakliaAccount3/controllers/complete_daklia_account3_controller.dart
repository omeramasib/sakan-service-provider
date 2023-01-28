import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CompleteDakliaAccount3Controller extends GetxController {

  RxString confirmationPath = ''.obs;
  RxString ownerIdPath = ''.obs;
  File? image;

  final count = 0.obs;

  void getConfirmationImage(ImageSource imageSource) async {
    final pickedFile = await ImagePicker().pickImage(source: imageSource);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      confirmationPath.value = pickedFile.path;
      update();
    }
    update();
  }

  void getOwnerIdImage(ImageSource imageSource) async {
    final pickedFile = await ImagePicker().pickImage(source: imageSource);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      ownerIdPath.value = pickedFile.path;
      update();
    }
    update();
  }
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
