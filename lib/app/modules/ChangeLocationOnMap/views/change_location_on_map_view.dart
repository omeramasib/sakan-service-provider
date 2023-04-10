import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../constants/buttons_manager.dart';
import '../../../../constants/colors_manager.dart';
import '../../../../constants/fonts_manager.dart';
import '../../../../constants/styles_manager.dart';
import '../../../../widgets/change_location_widgets/change_additonal_address.dart';
import '../controllers/change_location_on_map_controller.dart';

class ChangeLocationOnMapView extends GetView<ChangeLocationOnMapController> {
  const ChangeLocationOnMapView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ChangeLocationOnMapController());
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: AppBar(
          title: Text(
            'edit_profile'.tr,
            style: getMediumStyle(
              fontSize: FontSizeManager.s15,
              color: ColorsManager.whiteColor,
            ),
          ),
          centerTitle: true,
          backgroundColor: ColorsManager.mainColor,
          leading: Padding(
            padding: const EdgeInsets.only(
              right: 25,
            ),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: ColorsManager.whiteColor,
              ),
              onPressed: () => Get.back(),
            ),
          ),
        ),
      ),
      // appBar: PreferredSize(
      //   preferredSize: Size.fromHeight(80),
      //   child: AppBar(
      //     title: Text(
      //       'daklia_management'.tr,
      //       style: getMediumStyle(
      //         fontSize: FontSizeManager.s15,
      //         color: ColorsManager.whiteColor,
      //       ),
      //     ),
      //     centerTitle: true,
      //     backgroundColor: ColorsManager.mainColor,
      //     leading: Padding(
      //       padding: const EdgeInsets.only(
      //         right: 25,
      //       ),
      //       child: IconButton(
      //         icon: Icon(
      //           Icons.arrow_back,
      //           color: ColorsManager.whiteColor,
      //         ),
      //         onPressed: () => Get.back(),
      //       ),
      //     ),
      //   ),
      // ),
      body: Stack(
        children: [
          GetBuilder(
            init: controller,
            builder: (_) {
              return FutureBuilder(
                future: controller.getCurrentLocationFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return GoogleMap(
                      onMapCreated: controller.onMapCreated,
                      zoomControlsEnabled: false,
                      initialCameraPosition: CameraPosition(
                        target: controller.currentPosition!,
                        zoom: controller.initZoom,
                      ),
                      markers: controller.markers,
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        color: ColorsManager.mainColor,
                      ),
                    );
                  }
                },
              );
            },
          ),
          // Padding(
          //   padding: const EdgeInsets.only(
          //     right: 30,
          //     left: 40,
          //     top: 10,
          //   ),
          //   child: step2(context, "daklia_information".tr, "address".tr,
          //       "daklia_documentation".tr),
          // ),
        ],
      ),
      bottomNavigationBar: Container(
        width: Get.width,
        height: 78,
        decoration: BoxDecoration(
          color: ColorsManager.whiteColor,
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            right: 50,
          ),
          child: Row(
            children: [
              ButtonsManager.primaryButton(
                text: 'save_changes'.tr,
                onPressed: (){
                  // await controller.sendUpdateProfile();
                changeAdditionalAddress(context);
                },
                context: context,
                maximumSize: Size(287, 50),
                minimumSize: Size(287, 50),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
