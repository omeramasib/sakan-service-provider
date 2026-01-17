import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sakan/app/modules/dakliaProfile/controllers/daklia_profile_controller.dart';
import '../../../../constants/buttons_manager.dart';
import '../../../../constants/colors_manager.dart';
import '../../../../constants/fonts_manager.dart';
import '../../../../constants/images_manager.dart';
import '../../../../constants/styles_manager.dart';
import '../../../../constants/values_manager.dart';
import '../../../../widgets/choose_image/choose_image.dart';
import '../../../../widgets/text_form_fields.dart';
import '../../ChangeLocationOnMap/views/change_location_on_map_view.dart';
import '../controllers/edit_daklia_profile_controller.dart';

class EditDakliaProfileView extends GetView<EditDakliaProfileController> {
  const EditDakliaProfileView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final isEnglish = Get.locale!.languageCode == 'en';
    var profileController = Get.put(DakliaProfileController());
    return Scaffold(
      backgroundColor: ColorsManager.lightGreyColor,
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
      body: SingleChildScrollView(
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: isEnglish
                          ? const EdgeInsets.only(
                              top: AppPadding.p20,
                              left: AppPadding.p20,
                            )
                          : EdgeInsets.only(
                              top: AppPadding.p20, right: AppPadding.p20),
                      child: Text(
                        'warning_edit_profile'.tr,
                        style: getRegularStyle(
                          fontSize: FontSizeManager.s14,
                          color: ColorsManager.blackColor,
                          height: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: isEnglish
                        ? const EdgeInsets.only(
                            top: AppPadding.p30, left: AppPadding.p20)
                        : const EdgeInsets.only(
                            top: AppPadding.p30, right: AppPadding.p20),
                    child: Text(
                      'daklia_image'.tr,
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
              Obx(
                (() => Padding(
                      padding: isEnglish
                          ? const EdgeInsets.only(left: AppPadding.p30)
                          : const EdgeInsets.only(right: AppPadding.p20),
                      child: Row(
                        children: [
                          controller.imagePath.value == ''
                              ? Container(
                                  height: 138,
                                  width: 334,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: profileController.profileList[0]
                                                  .fullDakliaImage !=
                                              null
                                          ? NetworkImage(profileController
                                              .profileList[0].fullDakliaImage!)
                                          : const AssetImage(
                                                  ImagesManager.room_example)
                                              as ImageProvider,
                                      fit: BoxFit.cover,
                                      colorFilter: ColorFilter.mode(
                                        ColorsManager.blackColor
                                            .withOpacity(0.4),
                                        BlendMode.darken,
                                      ),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(
                                          AppPadding.p10,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                selectImage(
                                                    context, controller);
                                              },
                                              child: SvgPicture.asset(
                                                ImagesManager.edit_profile_icon,
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              : Padding(
                                  padding: isEnglish
                                      ? const EdgeInsets.only(
                                          left: AppPadding.p10)
                                      : const EdgeInsets.only(
                                          right: AppPadding.p10),
                                  child: Container(
                                    height: 94,
                                    width: 315,
                                    decoration: BoxDecoration(
                                      color: ColorsManager.whiteColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: kIsWeb
                                          ? Icon(
                                              Icons.check_circle,
                                              color: ColorsManager.mainColor,
                                              size: 40,
                                            )
                                          : Image.file(
                                              File(controller.imagePath.value),
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    )),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Padding(
                    padding: isEnglish
                        ? const EdgeInsets.only(
                            top: AppPadding.p30, left: AppPadding.p20)
                        : const EdgeInsets.only(
                            top: AppPadding.p30, right: AppPadding.p20),
                    child: Text(
                      'daklia_description'.tr,
                      style: getRegularStyle(
                        color: ColorsManager.mainColor,
                        fontSize: FontSizeManager.s14,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: isEnglish
                    ? const EdgeInsets.only(left: AppPadding.p10)
                    : const EdgeInsets.only(right: AppPadding.p10),
                child: Row(
                  children: [
                    dakliaDescriptionWidget(
                      context,
                      controller,
                      profileController.profileList[0].dakliaDescription!,
                    ),
                  ],
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
                            top: AppPadding.p20, left: AppPadding.p20)
                        : const EdgeInsets.only(
                            top: AppPadding.p20, right: AppPadding.p20),
                    child: Text(
                      'room_count'.tr,
                      style: getRegularStyle(
                        color: ColorsManager.mainColor,
                        fontSize: FontSizeManager.s14,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: isEnglish
                    ? const EdgeInsets.only(left: AppPadding.p30)
                    : const EdgeInsets.only(right: AppPadding.p30),
                child: Row(
                  children: [
                    editProfileRoomCountWidget(
                      context,
                      controller,
                      profileController.profileList[0].numberOfRooms!
                          .toString(),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: isEnglish
                        ? const EdgeInsets.only(
                            top: AppPadding.p20, left: AppPadding.p20)
                        : const EdgeInsets.only(
                            top: AppPadding.p20, right: AppPadding.p20),
                    child: Text(
                      "address".tr,
                      style: getRegularStyle(
                        color: ColorsManager.mainColor,
                        fontSize: FontSizeManager.s14,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 150,
                width: 330,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  children: [
                    // make button to change location on map as a container with icon

                    GoogleMap(
                      initialCameraPosition: CameraPosition(
                          target: LatLng(
                            double.tryParse(
                                    profileController.profileList[0].latitude ??
                                        '') ??
                                15.5007,
                            double.tryParse(profileController
                                        .profileList[0].longitude ??
                                    '') ??
                                32.5599,
                          ),
                          zoom: 14),
                      markers: {
                        Marker(
                          markerId: MarkerId("1"),
                          position: LatLng(
                            double.tryParse(
                                    profileController.profileList[0].latitude ??
                                        '') ??
                                15.5007,
                            double.tryParse(profileController
                                        .profileList[0].longitude ??
                                    '') ??
                                32.5599,
                          ),
                        ),
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: AppPadding.p20,
                        right: 290,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Get.to(() => ChangeLocationOnMapView());
                        },
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: ColorsManager.mainColor,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              ImagesManager.edit,
                              width: 15,
                              height: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
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
                onPressed: () async {
                  await controller.sendUpdateProfile();
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
