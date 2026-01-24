import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/modules/MyAppointments/controllers/my_appointments_controller.dart';
import '../../app/modules/MyAppointments/models/booking_model.dart';
import '../../app/modules/MyAppointments/views/appointment_detailes_view.dart';
import '../../constants/colors_manager.dart';
import '../../constants/fonts_manager.dart';
import '../../constants/images_manager.dart';
import '../../constants/styles_manager.dart';

Widget previousAppointment(BuildContext context) {
  final controller = Get.put(MyAppointmentsController());

  return Container(
    width: Get.width,
    height: Get.height,
    color: ColorsManager.lightGreyColor,
    child: Obx(() {
      if (controller.isLoading.value) {
        return Center(
          child: CircularProgressIndicator(
            color: ColorsManager.mainColor,
          ),
        );
      }

      final bookings = controller.previousBookings;

      if (bookings.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.history,
                size: 80,
                color: ColorsManager.defaultGreyColor,
              ),
              SizedBox(height: 20),
              Text(
                'no_previous_bookings'.tr,
                style: getRegularStyle(
                  color: ColorsManager.defaultGreyColor,
                  fontSize: FontSizeManager.s16,
                ),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () => controller.refreshBookings(),
        color: ColorsManager.mainColor,
        child: ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          itemCount: bookings.length,
          itemBuilder: (context, index) {
            return _PreviousBookingCard(booking: bookings[index]);
          },
        ),
      );
    }),
  );
}

class _PreviousBookingCard extends StatelessWidget {
  final BookingModel booking;

  const _PreviousBookingCard({Key? key, required this.booking})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MyAppointmentsController());

    return GestureDetector(
      onTap: () {
        controller.setSelectedBooking(booking);
        Get.to(() => AppointmentDetailesView());
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: ColorsManager.borderColor),
          boxShadow: [
            BoxShadow(
              color: ColorsManager.shadowColor,
              blurRadius: 7,
              offset: Offset(0, 0),
            ),
          ],
        ),
        child: Row(
          children: [
            // Room image
            Container(
              width: 100,
              height: 110,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
                image: DecorationImage(
                  image: booking.firstRoomImageUrl != null &&
                          booking.firstRoomImageUrl!.isNotEmpty
                      ? NetworkImage(booking.firstRoomImageUrl!)
                      : AssetImage(ImagesManager.room_example) as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Booking info
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${'booking_number'.tr}: #${booking.bookingId ?? ''}',
                          style: getMediumStyle(
                            color: ColorsManager.mainColor,
                            fontSize: FontSizeManager.s14,
                          ),
                        ),
                        _buildStatusBadge(booking.bookingStatus ?? ''),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.person_outline,
                            size: 16, color: ColorsManager.defaultGreyColor),
                        SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            booking.customerName ?? 'unknown'.tr,
                            style: getRegularStyle(
                              color: ColorsManager.blackColor,
                              fontSize: FontSizeManager.s12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(Icons.phone,
                            size: 16, color: ColorsManager.defaultGreyColor),
                        SizedBox(width: 5),
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
                            '${'customer_phone'.tr}: ${booking.formattedCustomerPhone ?? '-'}',
                            style: getRegularStyle(
                              color: ColorsManager
                                  .mainColor, // Make it look clickable/important
                              fontSize: FontSizeManager.s12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        SvgPicture.asset(
                          ImagesManager.room_type,
                          height: 16,
                          width: 16,
                        ),
                        SizedBox(width: 5),
                        Text(
                          '${'room_number'.tr}: ${booking.roomNumber ?? '-'}',
                          style: getRegularStyle(
                            color: ColorsManager.defaultGreyColor,
                            fontSize: FontSizeManager.s12,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(Icons.attach_money,
                            size: 16, color: ColorsManager.defaultGreyColor),
                        SizedBox(width: 5),
                        Text(
                          '${booking.totalPrice?.toStringAsFixed(0) ?? '0'} ${'sdg'.tr}',
                          style: getRegularStyle(
                            color: ColorsManager.blackColor,
                            fontSize: FontSizeManager.s12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
