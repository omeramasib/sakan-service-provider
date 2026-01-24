import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sakan/constants/colors_manager.dart';
import 'package:sakan/constants/fonts_manager.dart';
import 'package:sakan/constants/httpHelper.dart';
import 'package:sakan/constants/images_manager.dart';
import 'package:sakan/constants/styles_manager.dart';

import '../../app/modules/room_management/controllers/room_management_controller.dart';
import '../rooms_types/rooms_types.dart';
import 'edit_or_delete_room.dart';

Widget roomsList(BuildContext context, List roomsList) {
  var isEnglish = Get.locale!.languageCode == 'en';
  var controller = Get.put(RoomManagementController());
  return Container(
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
                'rooms'.tr,
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
                      selectRoomTypes(context);
                    },
                    child: SvgPicture.asset(
                      ImagesManager.add,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'add_room'.tr,
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
        SizedBox(height: 20),
        RefreshIndicator(
          color: ColorsManager.mainColor,
          onRefresh: () async {
            await controller.refreshRoomsList();
          },
          child: ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: roomsList.length,
              separatorBuilder: (context, index) {
                return SizedBox(
                  height: 10,
                );
              },
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        controller.setRooms = roomsList[index];
                        editOrDelete(context);
                      },
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
                              offset:
                                  Offset(0, 0), // changes position of shadow
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
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.network(
                                  '${roomsList[index].firstImageUrl ?? ''}',
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    // Show fallback image when network image fails
                                    return Image.asset(
                                      ImagesManager.room_example,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        color: ColorsManager.mainColor,
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes!
                                            : null,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                right: 130,
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
                                      '${'room_number'.tr} : ${roomsList[index].roomNumber}',
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
                                        'room_type'.tr,
                                        style: getRegularStyle(
                                          color: ColorsManager.defaultGreyColor,
                                          fontSize: FontSizeManager.s12,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      roomsList[index].roomType == 'multiple'
                                          ? Text(
                                              ': ${'shared_room'.tr}',
                                              style: getRegularStyle(
                                                color: ColorsManager.blackColor,
                                                fontSize: FontSizeManager.s12,
                                              ),
                                            )
                                          : Text(
                                              ': ${'single_room'.tr}',
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
                                        ImagesManager.rooms,
                                        height: 15,
                                        width: 10,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        'beds_number'.tr,
                                        style: getRegularStyle(
                                          color: ColorsManager.defaultGreyColor,
                                          fontSize: FontSizeManager.s12,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        ': ${roomsList[index].numberOfBeds}',
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
                            SizedBox(
                              width: 15,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 10,
                                right: 230,
                              ),
                              child: Container(
                                height: 22,
                                width: 73,
                                decoration: roomsList[index].numAvailableBeds !=
                                        0
                                    ? BoxDecoration(
                                        color: ColorsManager.blueColor
                                            .withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(11),
                                      )
                                    : BoxDecoration(
                                        color: ColorsManager.greenColor
                                            .withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(11),
                                      ),
                                child: roomsList[index].numAvailableBeds != 0
                                    ? Center(
                                        child: Text(
                                          '${roomsList[index].numAvailableBeds} ${'empty'.tr} ',
                                          style: getRegularStyle(
                                            color: ColorsManager.blueColor,
                                            fontSize: FontSizeManager.s11,
                                          ),
                                        ),
                                      )
                                    : Center(
                                        child: Text(
                                          'occupied'.tr,
                                          style: getRegularStyle(
                                            color: ColorsManager.greenColor,
                                            fontSize: FontSizeManager.s11,
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 13,
                                right: 315,
                              ),
                              child: InkWell(
                                onTap: () {
                                  controller.setRooms = roomsList[index];
                                  editOrDelete(context);
                                },
                                child: SvgPicture.asset(
                                  ImagesManager.more,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }),
        ),
        SizedBox(height: 25),
      ],
    ),
  );
}
