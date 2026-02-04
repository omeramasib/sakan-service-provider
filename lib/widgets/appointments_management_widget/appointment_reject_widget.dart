import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sakan/constants/buttons_manager.dart';
import 'package:sakan/constants/fonts_manager.dart';
import 'package:sakan/constants/styles_manager.dart';
import 'package:sakan/widgets/text_form_fields.dart';

import '../../../constants/colors_manager.dart';
import '../../../constants/values_manager.dart';
import '../../app/modules/MyAppointments/controllers/appointment_detailes_controller.dart';

appointmentReject(BuildContext context) {
  final isEnglish = Get.locale!.languageCode == 'en';
  final controller = Get.put(AppointmentDetailesController());
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    constraints: BoxConstraints(
      maxHeight: Get.height,
    ),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20.0),
      ),
    ),
    builder: (context) {
      return Container(
        width: Get.width,
        height: Get.height * 0.8,
        decoration: const BoxDecoration(
          color: ColorsManager.whiteColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20,
                  ),
                  child: Container(
                    width: 44,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: ColorsManager.lightGreyColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(
                    'appointment_reject'.tr,
                    style: getMediumStyle(
                        color: ColorsManager.blackColor,
                        fontSize: FontSizeManager.s15),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                // featureWidget(context, controller, 'feature_des'.tr),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Padding(
                      padding: isEnglish
                          ? const EdgeInsets.only(
                              top: AppPadding.p20, left: AppPadding.p40)
                          : const EdgeInsets.only(
                              top: AppPadding.p20, right: AppPadding.p30),
                      child: Text(
                        'appointment_rejection_reason'.tr,
                        style: getRegularStyle(
                          color: ColorsManager.mainColor,
                          fontSize: FontSizeManager.s14,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                appointmentRejectWidget(context, controller),
                SizedBox(
                  height: 20,
                ),
                ButtonsManager.primaryButton(
                  text: 'send'.tr,
                  onPressed: () => controller.rejectBooking(),
                  context: context,
                  minimumSize: Size(287, 50),
                  maximumSize: Size(287, 50),
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}
