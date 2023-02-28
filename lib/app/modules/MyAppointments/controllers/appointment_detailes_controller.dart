import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppointmentDetailesController extends GetxController {
  RxInt tabIndex = 0.obs;

  var appointmentRejectController = TextEditingController();

  void changeTabIndex(int index) {
    tabIndex.value = index;
    update();
  }


  RxInt selectIndex = 0.obs;
  void changeSelectIndex(int i) {
    selectIndex.value = i;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    appointmentRejectController = TextEditingController();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    appointmentRejectController.dispose();
  }
}
