import 'dart:async';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../constants/colors_manager.dart';
import '../../../../constants/fonts_manager.dart';
import '../../../../constants/styles_manager.dart';
import '../controllers/complete_daklia_account2_controller.dart';

class CompleteDakliaAccount2View
    extends GetView<CompleteDakliaAccount2Controller> {
  const CompleteDakliaAccount2View({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
      final Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController? newGoogleMapController;
  CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(controller.lat.value, controller.lat.value),
    zoom: 17,
  );
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
      body: Column(
        children: [
        Expanded(
          child: GoogleMap(
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;
              // for black map theme
              // blackThemeGoogleMap();
            },
            mapType: MapType.normal,
            myLocationEnabled: true,
          ),
        ),
      ],
      )
    );
  }
}
