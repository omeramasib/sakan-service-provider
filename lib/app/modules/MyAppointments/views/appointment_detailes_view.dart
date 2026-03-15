import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sakan/constants/buttons_manager.dart';

import '../../../../constants/colors_manager.dart';
import '../../../../constants/fonts_manager.dart';
import '../../../../constants/styles_manager.dart';
import '../../../../constants/values_manager.dart';
import '../../../../widgets/appointments_management_widget/appointment_details/appointment_details_widget.dart';
import '../../../../widgets/appointments_management_widget/appointment_details/choose_appointment_or_student_info.dart';
import '../../../../widgets/appointments_management_widget/appointment_details/student_info_widget.dart';
import '../../../../widgets/appointments_management_widget/appointment_reject_widget.dart';
import '../controllers/appointment_detailes_controller.dart';

class AppointmentDetailesView extends GetView {
  const AppointmentDetailesView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var controller = Get.put(AppointmentDetailesController());
    return Scaffold(
        backgroundColor: ColorsManager.lightGreyColor,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(10),
          child: AppBar(
            backgroundColor: ColorsManager.lightGreyColor,
            elevation: 0,
          ),
        ),
        body: Column(
          children: [
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    right: AppPadding.p20,
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: ColorsManager.blackColor,
                    ),
                    onPressed: () => Get.back(),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    right: Get.width * 0.2,
                  ),
                  child: Center(
                    child: Text(
                      'booking_details'.tr,
                      style: getMediumStyle(
                        fontSize: FontSizeManager.s15,
                        color: ColorsManager.blackColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            chooseAppointmentOrStudentInfo(context),
            Container(
              height: Get.height * 0.65,
              width: Get.width,
              color: ColorsManager.lightGreyColor,
              child: Obx(
                () => controller.tabIndex.value == 0
                    ? appointmentDetailsWidget(context)
                    : studentInfoWidget(context),
              ),
            ),
            Obx(() {
              final booking = controller.booking;
              final status = booking?.bookingStatus;

              // Pending: show Accept, Reject, Cancel (smaller)
              if (status == 'pending') {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ButtonsManager.primaryButton(
                        text: 'accept'.tr,
                        onPressed: () => controller.acceptBooking(),
                        context: context,
                        buttonColor: ColorsManager.greenColor,
                        minimumSize: Size(90, 48),
                        maximumSize: Size(100, 48),
                      ),
                      SizedBox(width: 8),
                      ButtonsManager.primaryButton(
                        text: 'reject'.tr,
                        onPressed: () => appointmentReject(context),
                        context: context,
                        buttonColor: ColorsManager.errorColor,
                        minimumSize: Size(90, 48),
                        maximumSize: Size(100, 48),
                      ),
                      SizedBox(width: 8),
                      ButtonsManager.primaryButton(
                        text: 'cancel_booking'.tr,
                        onPressed: () => controller.showCancelBookingConfirmation(),
                        context: context,
                        buttonColor: ColorsManager.greyColor,
                        textColor: ColorsManager.blackColor,
                        minimumSize: Size(90, 48),
                        maximumSize: Size(100, 48),
                      ),
                    ],
                  ),
                );
              }

              // Approved: show only Cancel button
              if (status == 'approved') {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: ButtonsManager.primaryButton(
                    text: 'cancel_booking'.tr,
                    onPressed: () => controller.showCancelBookingConfirmation(),
                    context: context,
                    buttonColor: ColorsManager.errorColor,
                    textColor: ColorsManager.whiteColor,
                    minimumSize: Size(150, 50),
                    maximumSize: Size(150, 50),
                  ),
                );
              }

              return const SizedBox.shrink();
            })
          ],
        ));
  }
}
