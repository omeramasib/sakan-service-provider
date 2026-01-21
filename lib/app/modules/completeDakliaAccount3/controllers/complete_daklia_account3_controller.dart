import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../constants/colors_manager.dart';
import '../model/daklia_verify_account_model.dart';
import '../provider/daklia_verify_account_provider.dart';

class CompleteDakliaAccount3Controller extends GetxController {
  RxString confirmationPath = ''.obs;
  RxString ownerIdPath = ''.obs;
  File? dakliaLicense;
  File? ownerId;

  final count = 0.obs;

  var formKey = GlobalKey<FormState>();
  var provider = DakliaVAProvider();

  void getConfirmationImageCamera() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      dakliaLicense = File(pickedFile.path);
      confirmationPath.value = pickedFile.path;
      update();
    }
    update();
  }

  void getConfirmationImageGallery() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      dakliaLicense = File(pickedFile.path);
      confirmationPath.value = pickedFile.path;
      update();
      Get.back();
    }
    update();
  }

  void getOwnerIdImageCamera() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      ownerId = File(pickedFile.path);
      ownerIdPath.value = pickedFile.path;
      update();
    }
    update();
  }

  void getOwnerIdImageGallery() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      ownerId = File(pickedFile.path);
      ownerIdPath.value = pickedFile.path;
      update();
      Get.back();
    }
    update();
  }

  Future<DakliaVerifyAccountModel> sendDakliaVA() async {
    print("dakliaLicense: $dakliaLicense");
    print("ownerId: $ownerId");
    return await provider
        .sendVA(
      daklia_license: dakliaLicense!,
      owner_license: ownerId!,
    )
        .timeout(
      Duration(seconds: 2),
      onTimeout: () {
        EasyLoading.dismiss();
        return DakliaVerifyAccountModel();
      },
    );
  }

  void checkSendDakliaVA() {
    if (confirmationPath.value == '') {
      Get.showSnackbar(
        GetSnackBar(
          message: 'please_select_daklia_doc'.tr,
          backgroundColor: ColorsManager.errorColor,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }
    if (ownerIdPath.value == '') {
      Get.showSnackbar(
        GetSnackBar(
          message: 'please_select_daklia_owner_doc'.tr,
          backgroundColor: ColorsManager.errorColor,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

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
    var isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    formKey.currentState!.save();
    EasyLoading.show(status: 'loading'.tr);
    sendDakliaVA();
    update();
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}

// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';

// import '../../../../constants/colors_manager.dart';
// import '../models/daklia_info_model.dart';
// import '../providers/daklia_info_provider.dart';

// class CompleteDakliaAccount1Controller extends GetxController {
//   RxString imagePath = ''.obs;
//   File? image;
//   int? roomCount;
//   String? dakliaDescription;

//   var formKey = GlobalKey<FormState>();

//   TextEditingController descriptionController = TextEditingController();
//   TextEditingController roomCountController = TextEditingController();

//   var provider = DakliaInfoProvider();

//   void getImageFromGallery(ImageSource imageSource) async {
//     final pickedFile = await ImagePicker().pickImage(source: imageSource);
//     if (pickedFile != null) {
//       image = File(pickedFile.path);
//       imagePath.value = pickedFile.path;
//       update();
//       Get.back();
//     }
//     update();
//   }

//   void getImageFromCamera(ImageSource imageSource) async {
//     final pickedFile = await ImagePicker().pickImage(source: imageSource);
//     if (pickedFile != null) {
//       image = File(pickedFile.path);
//       imagePath.value = pickedFile.path;
//       update();
//       Get.back();
//     }
//     update();
//   }

//   Future<DakliaInfoModel> sendDakliaInfo() async {
//     return await provider
//         .sendDakliaInfo(
//       dakliaDescription: dakliaDescription!,
//       numberOfRooms: roomCount!,
//       image: image,
//     )
//         .timeout(
//       Duration(seconds: 2),
//       onTimeout: () {
//         EasyLoading.dismiss();
//         return DakliaInfoModel();
//       },
//     );
//   }

//   void checkSendDakliaInfo() {
//     if (imagePath.value == '') {
//       Get.showSnackbar(
//         GetSnackBar(
//           message: 'please_select_image'.tr,
//           backgroundColor: ColorsManager.errorColor,
//           duration: const Duration(seconds: 2),
//         ),
//       );
//       return;
//     }

//     var isValid = formKey.currentState!.validate();
//     if (!isValid) {
//       return;
//     }
//     formKey.currentState!.save();
//     // if (networkController.isConnected.value == true) {
//     //   EasyLoading.show(status: 'loading'.tr);
//     //   try {
//     //     updatePatientProfile();
//     //   } catch (e) {
//     //     EasyLoading.dismiss();
//     //     print(e);
//     //   }
//     // } else {
//     //   Dialogs.connectionErrorDialog(Get.context!);
//     // }
//     EasyLoading.show(status: 'loading'.tr);
//     sendDakliaInfo();
//     update();
//   }

//   @override
//   void onInit() {
//     super.onInit();
//     descriptionController = TextEditingController();
//     roomCountController = TextEditingController();
//   }

//   @override
//   void onReady() {
//     super.onReady();
//   }

//   @override
//   void onClose() {
//     super.onClose();
//     descriptionController.dispose();
//     roomCountController.dispose();
//   }

// }