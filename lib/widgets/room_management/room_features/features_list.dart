import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sakan/constants/colors_manager.dart';
import 'package:sakan/constants/styles_manager.dart';

import '../../../app/modules/edit_room_feature/controllers/edit_room_feature_controller.dart';
import '../../../constants/fonts_manager.dart';
import '../../../constants/images_manager.dart';
import 'edit_or_delete_feature.dart';

featuresList(BuildContext context, dynamic roomController) {
  var editFeatureController = Get.put(EditRoomFeatureController());
  return Container(
    width: Get.width,
    height: Get.height * 0.6,
    child: RefreshIndicator(
      color: ColorsManager.mainColor,
      onRefresh: () async {
        await roomController.refreshRoomFeatures();
      },
      child: ListView.separated(
        itemCount: roomController.featuresList.length,
        itemBuilder: (context, index) => Column(
          children: [
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                editFeatureController.setRoomFeatures = roomController.featuresList[index];
                editOrDeleteFeature(context, editFeatureController);
              },
              child: Container(
                width: 330,
                decoration: BoxDecoration(
                  color: ColorsManager.lightGreyColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 15,
                            top: 10,
                          ),
                          child: Text(
                            roomController.featuresList[index].featureName,
                            style: getRegularStyle(
                              color: ColorsManager.mainColor,
                              fontSize: FontSizeManager.s14,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 13,
                            left: 20,
                          ),
                          child: SvgPicture.asset(
                            ImagesManager.more,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 20,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              roomController.featuresList[index].featureDescription,
                              style: getRegularStyle(
                                color: ColorsManager.blackColor,
                                fontSize: FontSizeManager.s12,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                height: 10,
              ),
                  ],
                ),
              ),
            ),
          ],
        ),
        separatorBuilder: (context, index) => SizedBox(
          height: 15,
        ),
      ),
    ),
  );
}
