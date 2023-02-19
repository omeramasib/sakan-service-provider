import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ServicesManagementController extends GetxController {
  //TODO: Implement ServicesManagementController

  final count = 0.obs;
  var serviceNameController = TextEditingController();
  var servicePriceController = TextEditingController();
  RxBool isAvailable = false.obs;
  chooseIsAvailable(bool value) {
    isAvailable.value = value;
    update();
  }
  @override
  void onInit() {
    serviceNameController = TextEditingController();
    servicePriceController = TextEditingController();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    serviceNameController.dispose();
    servicePriceController.dispose();
    super.onClose();
  }

  void increment() => count.value++;
}
