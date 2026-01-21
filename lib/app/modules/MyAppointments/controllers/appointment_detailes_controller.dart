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
      await Future.delayed(Duration(milliseconds: 500)); // Wait for snackbar
      // Refresh the selected booking to update UI
      await _refreshSelectedBooking();
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
      await Future.delayed(Duration(milliseconds: 500)); // Wait for snackbar
      Get.back(); // Close rejection dialog
      // Refresh the selected booking to update UI
      await _refreshSelectedBooking();
    }
  }

  /// Refresh the selected booking to get updated status from server
  Future<void> _refreshSelectedBooking() async {
    if (booking?.bookingId != null) {
      await myAppointmentsController.getBookingDetails(booking!.bookingId!);
      update(); // Trigger UI rebuild
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
