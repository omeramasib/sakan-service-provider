import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:sakan/constants/images_manager.dart';
import 'package:sakan/widgets/room_management/rooms_list.dart';

import '../../../../constants/colors_manager.dart';
import '../../../../constants/fonts_manager.dart';
import '../../../../constants/styles_manager.dart';
import '../../../../constants/values_manager.dart';
import '../../../../widgets/room_management/empty_room.dart';
import '../../../routes/app_pages.dart';
import '../controllers/room_management_controller.dart';

class RoomManagementView extends GetView<RoomManagementController> {
  const RoomManagementView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var isEnglish = Get.locale!.languageCode == 'en';
    var controller = Get.put(RoomManagementController());
    return Scaffold(
      backgroundColor: ColorsManager.lightGreyColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          backgroundColor: ColorsManager.mainColor,
          elevation: 0,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: ColorsManager.mainColor,
              padding: const EdgeInsets.only(bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      right: AppPadding.p20,
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: ColorsManager.whiteColor,
                      ),
                      onPressed: () => Get.offAllNamed(Routes.HOME),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: AppPadding.p40,
                    ),
                    child: Text(
                      'rooms_management'.tr,
                      style: getMediumStyle(
                        fontSize: FontSizeManager.s15,
                        color: ColorsManager.whiteColor,
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
                        color: ColorsManager.whiteColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Obx(() {
              // We listen to roomsList to trigger rebuilds when the list changes
              // This is necessary because totalRooms, occupiedRooms, availableRooms are computed from roomsList
              // effectively making them dependent on roomsList.
              // Just referencing controller.roomsList.length is enough to register the listener.
              final _ = controller.roomsList.length;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 90,
                        decoration: BoxDecoration(
                          color: ColorsManager.whiteColor,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: ColorsManager.shadowColor,
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${controller.availableRooms}',
                              style: getSemiBoldStyle(
                                color: ColorsManager.mainColor,
                                fontSize: FontSizeManager.s18,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'available_rooms'.tr,
                              style: getRegularStyle(
                                color: ColorsManager.fontColor,
                                fontSize: FontSizeManager.s12,
                              ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        height: 90,
                        decoration: BoxDecoration(
                          color: ColorsManager.whiteColor,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: ColorsManager.shadowColor,
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${controller.occupiedRooms}',
                              style: getSemiBoldStyle(
                                color: ColorsManager.mainColor,
                                fontSize: FontSizeManager.s18,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'occupied_rooms'.tr,
                              style: getRegularStyle(
                                color: ColorsManager.fontColor,
                                fontSize: FontSizeManager.s12,
                              ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        height: 90,
                        decoration: BoxDecoration(
                          color: ColorsManager.whiteColor,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: ColorsManager.shadowColor,
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${controller.totalRooms}',
                              style: getSemiBoldStyle(
                                color: ColorsManager.mainColor,
                                fontSize: FontSizeManager.s18,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'all_rooms'.tr,
                              style: getRegularStyle(
                                color: ColorsManager.fontColor,
                                fontSize: FontSizeManager.s12,
                              ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
            SizedBox(
              height: 20,
            ),
            Obx(() {
              if (controller.isLoading.value) {
                return Center(
                    child: CircularProgressIndicator(
                  color: ColorsManager.mainColor,
                ));
              } else {
                return controller.roomsList.isEmpty
                    ? emptyRoom(context)
                    : roomsList(context, controller.roomsList);
              }
            }),
          ],
        ),
      ),
    );
  }
}
