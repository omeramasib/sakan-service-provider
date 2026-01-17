import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sakan/constants/styles_manager.dart';
import 'package:sakan/widgets/appointments_management_widget/appointment_details/payment_details.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/modules/MyAppointments/controllers/appointment_detailes_controller.dart';
import '../../../constants/colors_manager.dart';
import '../../../constants/fonts_manager.dart';
import '../../../constants/images_manager.dart';

appointmentDetailsWidget(BuildContext context) {
  final controller = Get.find<AppointmentDetailesController>();
  final booking = controller.booking;

  if (booking == null) {
    return Center(child: Text('no_booking_data'.tr));
  }

  return SingleChildScrollView(
    child: Column(
      children: [
        SizedBox(height: 30),
        Container(
          width: 341,
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${'booking_number'.tr}: #${booking.bookingId ?? ''}",
                      style: getMediumStyle(
                        color: ColorsManager.mainColor,
                        fontSize: FontSizeManager.s15,
                      ),
                    ),
                    _buildStatusBadge(booking.bookingStatus ?? 'pending'),
                  ],
                ),
              ),
              SizedBox(height: 15),
              _buildInfoRow(
                icon: ImagesManager.room_type,
                label: "booking_type".tr,
                value: booking.dailyBooking == true ? 'daily'.tr : 'monthly'.tr,
              ),
              SizedBox(height: 15),
              _buildInfoRow(
                icon: ImagesManager.room_type,
                label: "room_number".tr,
                value: booking.roomNumber?.toString() ?? '-',
              ),
              SizedBox(height: 20),
              _buildInfoRow(
                icon: ImagesManager.rooms,
                label: 'beds_booked'.tr,
                value: '${booking.bedsBooked ?? 1}',
              ),
              SizedBox(height: 20),
              _buildInfoRow(
                icon: ImagesManager.rooms,
                label: 'room_price'.tr,
                value:
                    '${booking.totalPrice?.toStringAsFixed(0) ?? '0'} ${'sdg'.tr}',
              ),
              SizedBox(height: 20),
              _buildInfoRow(
                icon: ImagesManager.booking,
                label: 'dates'.tr,
                value: '${booking.startDate ?? ''} - ${booking.endDate ?? ''}',
              ),
              SizedBox(height: 25),
              // Customer Information Section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'main_info'.tr,
                    style: getMediumStyle(
                      color: ColorsManager.mainColor,
                      fontSize: FontSizeManager.s14,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
              _buildInfoRow(
                icon: ImagesManager.room_type,
                label: 'customer_name'.tr,
                value: booking.customerName ?? 'unknown'.tr,
              ),
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      ImagesManager
                          .room_type, // Using same icon as other info rows if appropriate, or could be a phone icon
                      height: 20,
                      width: 20,
                      color: ColorsManager.mainColor,
                    ),
                    SizedBox(width: 15),
                    Text(
                      'customer_phone'.tr,
                      style: getRegularStyle(
                        color: ColorsManager.defaultGreyColor,
                        fontSize: FontSizeManager.s12,
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () async {
                        final Uri phoneUri = Uri(
                          scheme: 'tel',
                          path: booking.customerPhone ?? '',
                        );
                        if (await canLaunchUrl(phoneUri)) {
                          await launchUrl(phoneUri);
                        }
                      },
                      child: Text(
                        booking.formattedCustomerPhone ?? '-',
                        style: getRegularStyle(
                          color: ColorsManager.mainColor,
                          fontSize: FontSizeManager.s12,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 15),
              _buildInfoRow(
                icon: ImagesManager.room_type,
                label: 'customer_type'.tr,
                value: booking.isStudent == true ? 'student'.tr : 'employee'.tr,
              ),
              if (booking.rejectionReason != null &&
                  booking.rejectionReason!.isNotEmpty) ...[
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'rejection_reason'.tr,
                        style: getRegularStyle(
                          color: ColorsManager.errorColor,
                          fontSize: FontSizeManager.s12,
                        ),
                      ),
                      Text(
                        booking.rejectionReason!,
                        style: getRegularStyle(
                          color: ColorsManager.blackColor,
                          fontSize: FontSizeManager.s12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        SizedBox(height: 15),
        paymentDetails(context),
      ],
    ),
  );
}

Widget _buildInfoRow(
    {required String icon, required String label, required String value}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Row(
      children: [
        SvgPicture.asset(
          icon,
          height: 20,
          width: 20,
          color: ColorsManager.mainColor,
        ),
        SizedBox(width: 15),
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

Widget _buildStatusBadge(String status) {
  Color bgColor;
  Color textColor;
  String label;

  switch (status.toLowerCase()) {
    case 'approved':
      bgColor = Colors.green.shade100;
      textColor = Colors.green.shade700;
      label = 'approved'.tr;
      break;
    case 'rejected':
      bgColor = Colors.red.shade100;
      textColor = Colors.red.shade700;
      label = 'rejected'.tr;
      break;
    case 'cancelled':
      bgColor = Colors.grey.shade200;
      textColor = Colors.grey.shade700;
      label = 'cancelled'.tr;
      break;
    default:
      bgColor = Colors.orange.shade100;
      textColor = Colors.orange.shade700;
      label = 'pending'.tr;
  }

  return Container(
    height: 27,
    padding: EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(15),
    ),
    child: Center(
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}
