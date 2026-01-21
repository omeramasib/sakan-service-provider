import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../constants/colors_manager.dart';
import '../models/daklia_info_model.dart';
import '../providers/daklia_info_provider.dart';

class CompleteDakliaAccount1Controller extends GetxController {
  RxString imagePath = ''.obs;
  File? image;
  int? roomCount;
  String? dakliaDescription;

  var formKey = GlobalKey<FormState>();

  TextEditingController descriptionController = TextEditingController();
  TextEditingController roomCountController = TextEditingController();

  var provider = DakliaInfoProvider();

  void getImageFromGallery(ImageSource imageSource) async {
    final pickedFile = await ImagePicker().pickImage(source: imageSource);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      imagePath.value = pickedFile.path;
      update();
      Get.back();
    }
    update();
  }

  void getImageFromCamera(ImageSource imageSource) async {
    final pickedFile = await ImagePicker().pickImage(source: imageSource);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      imagePath.value = pickedFile.path;
      update();
      Get.back();
    }
    update();
  }

  Future<DakliaInfoModel> sendDakliaInfo() async {
    return await provider
        .sendDakliaInfo(
      dakliaDescription: dakliaDescription!,
      numberOfRooms: roomCount!,
      image: image,

        ).timeout(
      Duration(seconds: 3),
      onTimeout: () {
        EasyLoading.dismiss();
        return DakliaInfoModel();
      },
    );
  }

  void checkSendDakliaInfo() {
    var isValid = formKey.currentState!.validate();
    if (imagePath.value == '') {
      Get.showSnackbar(
        GetSnackBar(
          message: 'please_select_image'.tr,
          backgroundColor: ColorsManager.errorColor,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    if (!isValid) {
      return;
    }

    formKey.currentState!.save();
    // if (networkController.isConnected.value == true) {
    //   EasyLoading.show(status: 'loading'.tr);
    //   try {
    //     updatePatientProfile();
    //   } catch (e) {
    //     EasyLoading.dismiss();
    //     print(e);
    //   }
    // } else {
    //   Dialogs.connectionErrorDialog(Get.context!);
    // }
    EasyLoading.show(status: 'loading'.tr);
    sendDakliaInfo();
    update();
  }

  @override
  void onInit() {
    super.onInit();
    descriptionController = TextEditingController();
    roomCountController = TextEditingController();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    descriptionController.dispose();
    roomCountController.dispose();
  }

}
