import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sakan/constants/colors_manager.dart';
import 'package:sakan/constants/fonts_manager.dart';
import 'package:sakan/constants/images_manager.dart';
import 'package:sakan/constants/styles_manager.dart';

import '../../app/modules/services_management/controllers/services_management_controller.dart';
import 'add_service.dart';
import 'edit_or_delete_services.dart';

Widget servicesList(BuildContext context) {
  var isEnglish = Get.locale!.languageCode == 'en';
  var controller = Get.put(ServicesManagementController());
  return Expanded(
    child: Container(
      height: Get.height,
      width: Get.width,
      child: Column(
        children: [
          Padding(
            padding: isEnglish
                ? EdgeInsets.only(
                    left: Get.width * 0.080,
                  )
                : EdgeInsets.only(
                    right: Get.width * 0.080,
                  ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'the_services'.tr,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: isEnglish
                      ? EdgeInsets.only(
                          right: Get.width * 0.060,
                        )
                      : EdgeInsets.only(
                          left: Get.width * 0.060,
                        ),
                  child: Row(children: [
                    GestureDetector(
                      onTap: () {
                        addService(context);
                      },
                      child: SvgPicture.asset(
                        ImagesManager.add,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'add_service'.tr,
                      style: getRegularStyle(
                        color: ColorsManager.mainColor,
                        fontSize: FontSizeManager.s12,
                      ),
                    )
                  ]),
                )
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            width: 341,
            height: Get.height * 0.6,
            child: RefreshIndicator(
              color: ColorsManager.mainColor,
              onRefresh: () async {
                await controller.refresServiceList();
              },
              child: ListView.separated(
                itemCount: controller.servicesList.length,
                itemBuilder: (context, index) => Column(
                  children: [
                    Container(
                      width: 341,
                      height: 68,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: ColorsManager.shadowColor,
                            blurRadius: 7,
                            offset: Offset(0, 0), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 20,
                              right: 20,
                            ),
                            child: Text(
                              controller.servicesList[index].serviceName!,
                              style: getRegularStyle(
                                color: ColorsManager.blackColor,
                                fontSize: FontSizeManager.s13,
                              ),
                            ),
                          ),
                          Obx(
                            () => controller.servicesList[index].isAvailable!
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                      top: 20,
                                      right: 210,
                                    ),
                                    child: Container(
                                      width: 75,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: ColorsManager.greenColor
                                            .withOpacity(
                                          0.2,
                                        ),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 5,
                                          ),
                                          SvgPicture.asset(
                                            ImagesManager.confirmation,
                                            color: ColorsManager.greenColor,
                                            height: 20,
                                            width: 20,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            'active_services'.tr,
                                            style: getRegularStyle(
                                              color: ColorsManager.greenColor,
                                              fontSize: FontSizeManager.s13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : SizedBox(),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 25,
                              right: 315,
                            ),
                            child: InkWell(
                              onTap: () {
                                controller.setServices =
                                    controller.servicesList[index];
                                editOrDeleteService(context);
                              },
                              child: SvgPicture.asset(
                                ImagesManager.more,
                              ),
                            ),
                          ),
                          // Obx(
                          //   () => Checkbox(
                          //     value: controller.isAvailable.value,
                          //     checkColor: ColorsManager.whiteColor,
                          //     fillColor: MaterialStateProperty.all(
                          //         ColorsManager.mainColor),
                          //     onChanged: (value) {
                          //       controller.chooseIsAvailable(value!);
                          //     },
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
                separatorBuilder: (context, index) => SizedBox(
                  height: 15,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
        ],
      ),
    ),
  );
}
