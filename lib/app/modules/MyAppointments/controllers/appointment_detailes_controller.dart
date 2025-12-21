import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/my_appointments_controller.dart';
import '../models/booking_model.dart';

class AppointmentDetailesController extends GetxController {
  final MyAppointmentsController myAppointmentsController =
      Get.put(MyAppointmentsController());

  RxInt tabIndex = 0.obs;
  var appointmentRejectController = TextEditingController();

  BookingModel? get booking => myAppointmentsController.selectedBooking.value;

  void changeTabIndex(int index) {
    tabIndex.value = index;
    update();
  }

  RxInt selectIndex = 0.obs;
  void changeSelectIndex(int i) {
    selectIndex.value = i;
    update();
  }

  Future<void> acceptBooking() async {
    if (booking?.bookingId == null) return;

    final success =
        await myAppointmentsController.approveBooking(booking!.bookingId!);
    if (success) {
      await Future.delayed(
          Duration(milliseconds: 500)); // Wait for snackbar to show
      Get.back(); // Return to list after success
    }
  }

  Future<void> rejectBooking() async {
    if (booking?.bookingId == null) return;
    if (appointmentRejectController.text.isEmpty) {
      Get.snackbar('error'.tr, 'please_enter_rejection_reason'.tr);
      return;
    }

    final success = await myAppointmentsController.rejectBooking(
        booking!.bookingId!, appointmentRejectController.text);
    if (success) {
      await Future.delayed(
          Duration(milliseconds: 500)); // Wait for snackbar to show
      Get.back(); // Close dialog
      Get.back(); // Return to list
    }
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    appointmentRejectController.dispose();
    super.onClose();
  }
}
