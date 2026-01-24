import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../constants/colors_manager.dart';
import '../../../../constants/fonts_manager.dart';
import '../../../../constants/images_manager.dart';
import '../../../../constants/styles_manager.dart';
import '../../../../widgets/room_management/room_features/add_room_feature.dart';
import '../../../../widgets/room_management/room_features/features_list.dart';
import '../../../../widgets/room_management/room_features/no_features.dart';
import '../../room_management/controllers/room_management_controller.dart';
import '../controllers/edit_room_feature_controller.dart';

class EditRoomFeatureView extends GetView<EditRoomFeatureController> {
  const EditRoomFeatureView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final isEnglish = Get.locale!.languageCode == 'en';
    final roomController = Get.put(RoomManagementController());
    return Scaffold(
      backgroundColor: ColorsManager.whiteColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          title: Text(
            'edit_room_feature'.tr,
            style: getRegularStyle(
              color: ColorsManager.whiteColor,
              fontSize: FontSizeManager.s15,
            ),
          ),
          leading: IconButton(
            onPressed: (){
            Get.back();
          }, icon: Icon(
            Icons.arrow_back,
            color: ColorsManager.whiteColor,
            ),
            ),
          centerTitle: true,
        ),
      ),
      body: GetBuilder(
        init: controller,
        builder: (controller) =>
        SingleChildScrollView(
          child:
        Column(
          children: [
            SizedBox(
              height: 30,
            ),
            // This is row 1
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
                    'room_features'.tr,
                    style: getRegularStyle(
                      color: ColorsManager.blackColor,
                      fontSize: FontSizeManager.s16,
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
                          addRoomFeatures(context);
                        },
                        child: SvgPicture.asset(
                          ImagesManager.add,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'add_feature'.tr,
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
            Obx(
           (){
             if(roomController.isLoading.value){
                return Center(
                  child: CircularProgressIndicator(
                    color: ColorsManager.mainColor,
                  )
                  );
            }
            else{
              return roomController.featuresList.isEmpty
                  ? no_features(context)
                  : featuresList(context, roomController);
            }
            }
          ),
          ],
        ),
      ),
        ),
    );
  }
}
