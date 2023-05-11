import 'package:flutter/material.dart';
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
        preferredSize: Size.fromHeight(10),
        child: AppBar(
          backgroundColor: ColorsManager.lightGreyColor,
          elevation: 0,
        ),
      ),
      body: Column(
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
                    color: ColorsManager.mainColor,
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
            height: 30,
          ),
          Container(
            height: 100,
            width: double.infinity,
            child: LayoutBuilder(
              builder: (BuildContext, BoxConstraints constraints) {
                return Padding(
                  padding: isEnglish
                      ? EdgeInsets.only(
                          right: Get.width * 0.080,
                        )
                      : EdgeInsets.only(
                          right: Get.width * 0.080,
                        ),
                  child: Row(
                    children: [
                      Container(
                        width: 105,
                        height: 100,
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
                        child: Column(children: [
                          Padding(
                            padding: const EdgeInsets.only(top: AppPadding.p20),
                            child: Text(
                              '0',
                              style: getSemiBoldStyle(
                                color: ColorsManager.mainColor,
                                fontSize: FontSizeManager.s18,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'all_rooms'.tr,
                            style: getRegularStyle(
                                color: ColorsManager.fontColor,
                                fontSize: FontSizeManager.s14),
                          )
                        ]),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Container(
                        width: 105,
                        height: 100,
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
                        child: Column(children: [
                          Padding(
                            padding: const EdgeInsets.only(top: AppPadding.p20),
                            child: Text(
                              '0',
                              style: getSemiBoldStyle(
                                color: ColorsManager.mainColor,
                                fontSize: FontSizeManager.s18,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'occupied_rooms'.tr,
                            style: getRegularStyle(
                                color: ColorsManager.fontColor,
                                fontSize: FontSizeManager.s14),
                          )
                        ]),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Container(
                        width: 105,
                        height: 100,
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
                        child: Column(children: [
                          Padding(
                            padding: const EdgeInsets.only(top: AppPadding.p20),
                            child: Text(
                              '0',
                              style: getSemiBoldStyle(
                                color: ColorsManager.mainColor,
                                fontSize: FontSizeManager.s18,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'available_rooms'.tr,
                            style: getRegularStyle(
                              color: ColorsManager.fontColor,
                              fontSize: FontSizeManager.s14,
                            ),
                          ),
                        ]),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Obx(
            () {
              if (controller.isLoading.value) {
                return Center(
                  child: CircularProgressIndicator(
                    color: ColorsManager.mainColor,
                  ),
                );
              } else {
                return controller.roomsList.isEmpty
                    ? emptyRoom(context)
                    : roomsList(context, controller.roomsList);
              }
            },
          ),
        ],
      ),
    );
  }
}
