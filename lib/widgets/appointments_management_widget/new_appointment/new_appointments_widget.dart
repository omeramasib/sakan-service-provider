import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sakan/constants/colors_manager.dart';

import '../../../app/modules/MyAppointments/views/appointment_detailes_view.dart';
import '../../../constants/fonts_manager.dart';
import '../../../constants/images_manager.dart';
import '../../../constants/styles_manager.dart';
import 'choose_pending_appointment_type.dart';

Widget nextAppointment(BuildContext context){
  return Container(
    width: Get.width,
    height: Get.height,
    color: ColorsManager.lightGreyColor,
    child: Column(
      children: [
        SizedBox(
          height: 10,
        ),
        chooseApprovalType(context),
        SizedBox(
          height: 30,
        ),
        GestureDetector(
          onTap: () => Get.to(AppointmentDetailesView()),
          child: Container(
            width: 341,
            height: 115,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: ColorsManager.borderColor,
              ),
              boxShadow: [
                BoxShadow(
                  color: ColorsManager.shadowColor,
                  // spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 0), // changes position of shadow
                ),
              ],
            ),
            child: Stack(
              children: [
                Container(
                  width: 119,
                  height: 115,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    image: DecorationImage(
                      image: AssetImage(ImagesManager.room_example),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    right: 140,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                        ),
                        child: Text(
                          "booking_number".tr,
                          style: getRegularStyle(
                            color: ColorsManager.mainColor,
                            fontSize: FontSizeManager.s14,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(
                            ImagesManager.room_type,
                            height: 25,
                            width: 25,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "room_number".tr,
                            style: getRegularStyle(
                              color: ColorsManager.defaultGreyColor,
                              fontSize: FontSizeManager.s12,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            ': 123445'.tr,
                            style: getRegularStyle(
                              color: ColorsManager.blackColor,
                              fontSize: FontSizeManager.s12,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(
                            ImagesManager.booking,
                            height: 20,
                            width: 20,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'booking_type'.tr,
                            style: getRegularStyle(
                              color: ColorsManager.defaultGreyColor,
                              fontSize: FontSizeManager.s12,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            ": ${'monthly_booking'.tr}",
                            style: getRegularStyle(
                              color: ColorsManager.blackColor,
                              fontSize: FontSizeManager.s12,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        // Container2
          Container(
          width: 341,
          height: 115,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: ColorsManager.borderColor,
            ),
            boxShadow: [
              BoxShadow(
                color: ColorsManager.shadowColor,
                // spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 0), // changes position of shadow
              ),
            ],
          ),
          child: Stack(
            children: [
              Container(
                width: 119,
                height: 115,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  image: DecorationImage(
                    image: AssetImage(ImagesManager.room_example),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  // top: 10,
                  right: 140,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                      ),
                      child: Text(
                        "booking_number".tr,
                        style: getRegularStyle(
                          color: ColorsManager.mainColor,
                          fontSize: FontSizeManager.s14,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(
                          ImagesManager.room_type,
                          height: 25,
                          width: 25,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "room_number".tr,
                          style: getRegularStyle(
                            color: ColorsManager.defaultGreyColor,
                            fontSize: FontSizeManager.s12,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          ': 123445'.tr,
                          style: getRegularStyle(
                            color: ColorsManager.blackColor,
                            fontSize: FontSizeManager.s12,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(
                          ImagesManager.booking,
                          height: 20,
                          width: 20,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'booking_type'.tr,
                          style: getRegularStyle(
                            color: ColorsManager.defaultGreyColor,
                            fontSize: FontSizeManager.s12,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          ": ${'daily_booking'.tr}",
                          style: getRegularStyle(
                            color: ColorsManager.blackColor,
                            fontSize: FontSizeManager.s12,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}