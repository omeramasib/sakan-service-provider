import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sakan/constants/buttons_manager.dart';
import 'package:sakan/widgets/stepper/step2.dart';

import '../../../../constants/colors_manager.dart';
import '../../../../constants/fonts_manager.dart';
import '../../../../constants/styles_manager.dart';
import '../../../../widgets/account_confirmation_widget/additonal_daklia_address.dart';
import '../controllers/complete_daklia_account2_controller.dart';

class CompleteDakliaAccount2View
    extends GetView<CompleteDakliaAccount2Controller> {
  const CompleteDakliaAccount2View({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: AppBar(
          title: Text(
            'daklia_management'.tr,
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
                      // initialCameraPosition: CameraPosition(
                      //   target: controller.currentPosition ??
                      //       LatLng(56.324293441187315, 38.13961947281509),
                      //   zoom: 14.0,
                      // ),
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
          Padding(
            padding: const EdgeInsets.only(
              right: 30,
              left: 40,
              top: 10,
            ),
            child: step2(context, "daklia_information".tr, "address".tr,
                "daklia_documentation".tr),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: Get.height * 0.75,
              right: 50,
              left: 50,
            ),
            child: ButtonsManager.primaryButton(
                onPressed: () async {
                  additionalAddress(context);
                },
                buttonColor: ColorsManager.mainColor,
                context: context,
                text: 'select_location'.tr),
          ),
        ],
      ),
    );
  }
}
