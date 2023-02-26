import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sakan/constants/styles_manager.dart';

import '../../../constants/colors_manager.dart';
import '../../../constants/fonts_manager.dart';

appointmentDetailsWidget(BuildContext context) {
  return Container(
    width: Get.width,
    height: Get.height,
    color: ColorsManager.lightGreyColor,
    child: Column(
      children: [
        SizedBox(
          height: 30,
        ),
        Container(
          width: 341,
          height: 301,
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
                offset: Offset(0, 0), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: 15,
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 20,
                            top: 10,
                          ),
                          child: Text(
                            "booking_number".tr,
                            style: getMediumStyle(
                              color: ColorsManager.mainColor,
                              fontSize: FontSizeManager.s15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 15,
                      left: 20,
                    ),
                    child: Container(
                      height: 27,
                      width: 78,
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Text(
                          'paid'.tr,
                          style: getRegularStyle(
                            color: Colors.green,
                            fontSize: FontSizeManager.s13,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        )
      ],
    ),
  );
}
