import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sakan/constants/colors_manager.dart';

import '../../../../constants/fonts_manager.dart';
import '../../../../constants/styles_manager.dart';
import '../../../../constants/values_manager.dart';
import '../../../../widgets/regulations_management/empty_regulations.dart';
import '../../../../widgets/regulations_management/regulation_list.dart';
import '../controllers/regulations_management_controller.dart';

class RegulationsManagementView
    extends GetView<RegulationsManagementController> {
  const RegulationsManagementView({Key? key}) : super(key: key);
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
      body: Column(
        children: [
          Row(
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
                  right: Get.width * 0.20,
                ),
                child: Text(
                  'terms'.tr,
                  style: getMediumStyle(
                    fontSize: FontSizeManager.s15,
                    color: ColorsManager.mainColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Obx(
            () {
              if (controller.isLoading.value) {
                return Center(
                    child: CircularProgressIndicator(
                  color: ColorsManager.mainColor,
                ));
              } else {
                return controller.lawsList.isEmpty
                    ? emptyRegulation(context)
                    : regulationList(context);
              }
            },
          ),
        ],
      ),
    );
  }
}
