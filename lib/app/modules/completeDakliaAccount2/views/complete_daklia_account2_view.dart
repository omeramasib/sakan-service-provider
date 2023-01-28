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
import '../../../../constants/values_manager.dart';
import '../../../../widgets/text_form_fields.dart';
import '../../../routes/app_pages.dart';
import '../controllers/complete_daklia_account2_controller.dart';

class CompleteDakliaAccount2View
    extends GetView<CompleteDakliaAccount2Controller> {
  const CompleteDakliaAccount2View({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final Completer<GoogleMapController> _controllerGoogleMap = Completer();
    GoogleMapController? newGoogleMapController;
    CameraPosition cameraPosition = CameraPosition(
      target: LatLng(controller.lat.value, controller.lat.value),
      zoom: 15,
    );
    var isEnglish = Get.locale!.languageCode == 'en';
    final Set<Marker> _markers = {};
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
            GoogleMap(
              initialCameraPosition: cameraPosition,
              onMapCreated: (GoogleMapController controller) {
                _controllerGoogleMap.complete(controller);
                newGoogleMapController = controller;
              },
              markers: _markers,
              mapType: MapType.normal,
              myLocationEnabled: true,
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
                top: Get.height * 0.5,
                right: 50,
                left: 50,
              ),
              child: ButtonsManager.primaryButton(
                  onPressed: () async {
                    Position position = await controller.getCurrentLocation();
                    newGoogleMapController!.animateCamera(
                      CameraUpdate.newCameraPosition(
                        CameraPosition(
                          target: LatLng(position.latitude, position.longitude),
                          zoom: 15,
                        ),
                      ),
                    );
                    controller.lat.value = position.latitude;
                    controller.lon.value = position.longitude;
                    print(controller.lat.value);
                    print(controller.lon.value);
                    _markers.clear();
                    _markers.add(
                      Marker(
                        markerId: MarkerId('1'),
                        position:
                            LatLng(controller.lat.value, controller.lon.value),
                        infoWindow: InfoWindow(title: 'Marker 1'),
                      ),
                    );
                  },
                  buttonColor: ColorsManager.mainColor,
                  context: context,
                  text: 'mylocation'.tr),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: Get.height * 0.6,
              ),
              child: Container(
                height: 375,
                width: Get.width,
                decoration: BoxDecoration(
                  color: ColorsManager.whiteColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 20,
                      ),
                      child: Text(
                        'other_detailes'.tr,
                        style: getMediumStyle(
                          fontSize: FontSizeManager.s15,
                          color: ColorsManager.fontColor,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: isEnglish
                              ? const EdgeInsets.only(
                                  top: AppPadding.p20, left: AppPadding.p65)
                              : const EdgeInsets.only(
                                  top: AppPadding.p20, right: AppPadding.p50),
                          child: Text(
                            'address_details_des'.tr,
                            style: getRegularStyle(
                              color: ColorsManager.mainColor,
                              fontSize: FontSizeManager.s14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    addressDetailsWidget(
                        context, controller, 'address_details'.tr),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding:  EdgeInsets.only(
                        right: Get.width * 0.1,
                      ),
                      child: Row(
                        children: [
                          ButtonsManager.primaryButton(
                            text: 'next'.tr,
                            onPressed: () {
                              Get.toNamed(Routes.COMPLETE_DAKLIA_ACCOUNT3);
                              print('clicked');
                            },
                            context: context,
                            maximumSize: Size(174, 50),
                            minimumSize: Size(174, 50),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          ButtonsManager.primaryButton(
                            text: 'previous'.tr,
                            onPressed: () {
                              Get.back();
                            },
                            context: context,
                            maximumSize: Size(134, 50),
                            minimumSize: Size(134, 50),
                            buttonColor: ColorsManager.greyColor,
                            textColor: ColorsManager.blackColor,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
    );
  }
}
