import 'dart:developer';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../../../constants/dialogs.dart';
import '../../room_management/controllers/room_management_controller.dart';
import '../../room_management/models/room_features_model.dart';
import '../../room_management/providers/room_features_provider.dart';

class EditRoomFeatureController extends GetxController {
  var roomController = Get.put(RoomManagementController());
  var formKey = GlobalKey<FormState>();

  RoomFeaturesModel myRoomFeatures = new RoomFeaturesModel();
  var featureController = TextEditingController();
  var otherDetailsController = TextEditingController();
  final isLoading = false.obs;
  String featureName = "";
  String featureDescription = "";

  set setRoomFeatures(RoomFeaturesModel features) {
    myRoomFeatures = features;
    update();
  }

  RoomFeaturesModel get getFeatures => myRoomFeatures;

  var provider = RoomFeaturesProvider();

  Future<void> editRoomFeature() async {
    try {
      final data = await provider.editFeature(
        roomId: roomController.getRooms.roomId!,
        featureId: getFeatures.featureId!,
        featureName: featureName == ""
            ? featureName = getFeatures.featureName!
            : featureName,
        featureDescription: featureDescription == ""
            ? featureDescription = getFeatures.featureDescription!
            : featureDescription,
      );
      print('this is the data: $data');
    } catch (e) {
      print(e);
      Dialogs.errorDialog(Get.context!, 'Failed_to_update_feature'.tr);
    }
    isLoading.value = false;
    EasyLoading.dismiss();
    update();
  }

  Future<void> deleteFeature() async {
    log('this is the feature id: ${getFeatures.featureId}');
    log('this is the room id: ${roomController.getRooms.roomId}');
    try {
      await provider.deleteFeature(
        roomId: roomController.getRooms.roomId!,
        featureId: getFeatures.featureId!,
      );
    } catch (e) {
      print(e);
      Dialogs.errorDialog(Get.context!, 'Failed_to_delete_feature'.tr);
    }
    isLoading.value = false;
    EasyLoading.dismiss();
    update();
  }

  checkDeleteFeature() async {
    isLoading.value = true;
    EasyLoading.show(status: 'loading'.tr);
    await deleteFeature();
  }

  checkEditFeature() async {
    isLoading.value = true;
    EasyLoading.show(status: 'loading'.tr);
    await editRoomFeature();
  }

  @override
  void onInit() {
    super.onInit();
    featureController = TextEditingController();
    otherDetailsController = TextEditingController();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
