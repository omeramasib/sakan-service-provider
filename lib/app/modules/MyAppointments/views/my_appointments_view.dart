import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:sakan/widgets/appointments_management_widget/new_appointment/new_appointments_widget.dart';

import '../../../../constants/colors_manager.dart';
import '../../../../constants/fonts_manager.dart';
import '../../../../constants/images_manager.dart';
import '../../../../constants/styles_manager.dart';
import '../../../../constants/values_manager.dart';
import '../../../../widgets/appointments_management_widget/choose_my_appointments_type.dart';
import '../../../../widgets/appointments_management_widget/previous__appointments_widget.dart';
import '../controllers/my_appointments_controller.dart';

class MyAppointmentsView extends GetView<MyAppointmentsController> {
  const MyAppointmentsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.lightGreyColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(10),
        child: AppBar(
          backgroundColor: ColorsManager.lightGreyColor,
          elevation: 0,
        ),
      ),
      body:Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                padding: const EdgeInsets.only(
                  left: AppPadding.p40,
                ),
                child: Text(
                  'my_appointments'.tr,
                  style: getMediumStyle(
                    fontSize: FontSizeManager.s15,
                    color: ColorsManager.blackColor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: AppPadding.p20,
                ),
                child: GestureDetector(
                  onTap: () {},
                  child: SvgPicture.asset(
                    ImagesManager.search,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(
            height: 20,
          ),
          chooseMyAppointmentType(context),
          SizedBox(
            height: 20,
          ),

          Expanded(
            child: Container(
              height: Get.height,
              width: Get.width,
              child: Obx(
                () => controller.tabIndex.value == 0
                    ? nextAppointment(context)
                    : previousAppointment(context),
              ),
            ),
          )
        ],
      )
    );
  }
}
