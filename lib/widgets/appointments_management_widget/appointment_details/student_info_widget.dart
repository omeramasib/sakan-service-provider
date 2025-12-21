import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../app/modules/MyAppointments/controllers/appointment_detailes_controller.dart';
import '../../../constants/colors_manager.dart';
import '../../../constants/fonts_manager.dart';
import '../../../constants/images_manager.dart';
import '../../../constants/styles_manager.dart';

studentInfoWidget(BuildContext context) {
  final controller = Get.find<AppointmentDetailesController>();
  final booking = controller.booking;

  if (booking == null) {
    return Center(child: Text('no_student_data'.tr));
  }

  return SingleChildScrollView(
    child: Column(
      children: [
        SizedBox(height: 30),
        Container(
          width: 315,
          padding: EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: ColorsManager.whiteColor,
            border: Border.all(
              color: ColorsManager.borderColor,
            ),
            boxShadow: [
              BoxShadow(
                color: ColorsManager.shadowColor,
                blurRadius: 7,
                offset: Offset(0, 0),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20, top: 10),
                    child: Text(
                      'main_info'.tr,
                      style: getMediumStyle(
                        color: ColorsManager.mainColor,
                        fontSize: FontSizeManager.s15,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              _buildStudentInfoRow(
                icon: ImagesManager.id,
                label: 'customer_name'.tr,
                value: booking.customerName ?? '-',
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Divider(),
              ),
              SizedBox(height: 20),
              _buildStudentInfoRow(
                icon: ImagesManager.booking,
                label: 'customer_type'.tr,
                value: booking.customerType ?? '-',
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Divider(),
              ),
              SizedBox(height: 20),
              _buildStudentInfoRow(
                icon: ImagesManager.room_type,
                label: 'status'.tr,
                value: (booking.bookingStatus ?? 'pending').tr,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Divider(),
              ),
            ],
          ),
        ),
        if (booking.invoiceReceipt != null &&
            booking.invoiceReceipt!.isNotEmpty) ...[
          SizedBox(height: 15),
          Container(
            width: 315,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: ColorsManager.whiteColor,
              border: Border.all(
                color: ColorsManager.borderColor,
              ),
              boxShadow: [
                BoxShadow(
                  color: ColorsManager.shadowColor,
                  blurRadius: 7,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 20, top: 10),
                  child: Row(
                    children: [
                      Text(
                        'invoice_receipt'.tr,
                        style: getMediumStyle(
                          color: ColorsManager.mainColor,
                          fontSize: FontSizeManager.s15,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    'https://sakan-sd.com${booking.invoiceReceipt}',
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.broken_image, size: 100, color: Colors.grey),
                  ),
                ),
              ],
            ),
          )
        ],
      ],
    ),
  );
}

Widget _buildStudentInfoRow(
    {required String icon, required String label, required String value}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Row(
      children: [
        SvgPicture.asset(
          icon,
          height: 14,
          width: 18,
          color: ColorsManager.mainColor,
        ),
        SizedBox(width: 10),
        Text(
          label,
          style: getRegularStyle(
            color: ColorsManager.defaultGreyColor,
            fontSize: FontSizeManager.s12,
          ),
        ),
        Spacer(),
        Text(
          value,
          style: getRegularStyle(
            color: ColorsManager.blackColor,
            fontSize: FontSizeManager.s12,
          ),
        )
      ],
    ),
  );
}
