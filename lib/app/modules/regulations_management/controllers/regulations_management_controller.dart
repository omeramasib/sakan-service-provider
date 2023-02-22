import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegulationsManagementController extends GetxController {

  var regulationTextController = TextEditingController();
  var regulationDescriptionController = TextEditingController();
  final count = 0.obs;
  @override
  void onInit() {
    regulationTextController = TextEditingController();
    regulationDescriptionController = TextEditingController();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    regulationTextController.dispose();
    regulationDescriptionController.dispose();
  }

  void increment() => count.value++;
}
