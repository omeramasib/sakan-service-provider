import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:sakan/constants/fonts_manager.dart';

import '../../../../constants/colors_manager.dart';
import '../../../../constants/images_manager.dart';
import '../../../../constants/styles_manager.dart';
import '../../../../constants/values_manager.dart';
import '../../../../widgets/services_management/empty_services.dart';
import '../../../../widgets/services_management/services_list.dart';
import '../../../routes/app_pages.dart';
import '../controllers/services_management_controller.dart';

class ServicesManagementView extends GetView<ServicesManagementController> {
  const ServicesManagementView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var isEnglish = Get.locale!.languageCode == 'en';
    var controller = Get.put(ServicesManagementController());
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
            children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: ColorsManager.blackColor,
                ),
                onPressed: () => Get.offAllNamed(Routes.HOME),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    'services_management'.tr,
                    style: getMediumStyle(
                      fontSize: FontSizeManager.s15,
                      color: ColorsManager.mainColor,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 48), // Balance the back button
            ],
          ),
          SizedBox(
            height: 30,
          ),
          // Container(
          //   height: 100,
          //   width: double.infinity,
          //   child: LayoutBuilder(
          //     builder: (BuildContext, BoxConstraints constraints) {
          //       return Padding(
          //         padding: isEnglish
          //             ? EdgeInsets.only(
          //                 right: Get.width * 0.080,
          //               )
          //             : EdgeInsets.only(
          //                 right: Get.width * 0.080,
          //               ),
          //         child: Row(
          //           children: [
          //             Container(
          //               width: 105,
          //               height: 100,
          //               decoration: BoxDecoration(
          //                 color: ColorsManager.whiteColor,
          //                 borderRadius: BorderRadius.circular(10),
          //                 boxShadow: [
          //                   BoxShadow(
          //                     color: ColorsManager.shadowColor,
          //                     blurRadius: 6,
          //                     offset: Offset(0, 3),
          //                   ),
          //                 ],
          //               ),
          //               child: Column(children: [
          //                 Padding(
          //                   padding: const EdgeInsets.only(top: AppPadding.p20),
          //                   child: Text(
          //                     '0',
          //                     style: getSemiBoldStyle(
          //                       color: ColorsManager.mainColor,
          //                       fontSize: FontSizeManager.s18,
          //                     ),
          //                   ),
          //                 ),
          //                 SizedBox(
          //                   height: 10,
          //                 ),
          //                 Text(
          //                   'all_services'.tr,
          //                   style: getRegularStyle(
          //                       color: ColorsManager.fontColor,
          //                       fontSize: FontSizeManager.s14),
          //                 )
          //               ]),
          //             ),
          //             SizedBox(
          //               width: 15,
          //             ),
          //             Container(
          //               width: 105,
          //               height: 100,
          //               decoration: BoxDecoration(
          //                 color: ColorsManager.whiteColor,
          //                 borderRadius: BorderRadius.circular(10),
          //                 boxShadow: [
          //                   BoxShadow(
          //                     color: ColorsManager.shadowColor,
          //                     blurRadius: 6,
          //                     offset: Offset(0, 3),
          //                   ),
          //                 ],
          //               ),
          //               child: Column(children: [
          //                 Padding(
          //                   padding: const EdgeInsets.only(top: AppPadding.p20),
          //                   child: Text(
          //                     '0',
          //                     style: getSemiBoldStyle(
          //                       color: ColorsManager.mainColor,
          //                       fontSize: FontSizeManager.s18,
          //                     ),
          //                   ),
          //                 ),
          //                 SizedBox(
          //                   height: 10,
          //                 ),
          //                 Text(
          //                   'active_services'.tr,
          //                   style: getRegularStyle(
          //                       color: ColorsManager.fontColor,
          //                       fontSize: FontSizeManager.s14),
          //                 )
          //               ]),
          //             ),
          //             SizedBox(
          //               width: 15,
          //             ),
          //             Container(
          //               width: 105,
          //               height: 100,
          //               decoration: BoxDecoration(
          //                 color: ColorsManager.whiteColor,
          //                 borderRadius: BorderRadius.circular(10),
          //                 boxShadow: [
          //                   BoxShadow(
          //                     color: ColorsManager.shadowColor,
          //                     blurRadius: 6,
          //                     offset: Offset(0, 3),
          //                   ),
          //                 ],
          //               ),
          //               child: Column(children: [
          //                 Padding(
          //                   padding: const EdgeInsets.only(top: AppPadding.p20),
          //                   child: Text(
          //                     '0',
          //                     style: getSemiBoldStyle(
          //                       color: ColorsManager.mainColor,
          //                       fontSize: FontSizeManager.s18,
          //                     ),
          //                   ),
          //                 ),
          //                 SizedBox(
          //                   height: 10,
          //                 ),
          //                 Text(
          //                   'inactive_services'.tr,
          //                   style: getRegularStyle(
          //                       color: ColorsManager.fontColor,
          //                       fontSize: FontSizeManager.s14),
          //                 ),
          //               ]),
          //             ),
          //           ],
          //         ),
          //       );
          //     },
          //   ),
          // ),
          // SizedBox(
          //   height: 20,
          // ),
          Obx(() {
            if (controller.isLoading.value) {
              return Center(
                  child: CircularProgressIndicator(
                color: ColorsManager.mainColor,
              ));
            } else {
              return controller.servicesList.isEmpty
                  ? emptyServices(context)
                  : servicesList(context);
            }
          }),
        ],
      ),
    );
  }
}
