import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../models/daklia_rooms_models.dart';
import '../providers/daklia_room_provider.dart';

class RoomManagementController extends GetxController {

  RxString imagePath = ''.obs;
  File? image;

  var roomNumberController = TextEditingController();
  var allBedsNumberController = TextEditingController();
  var emptyBedsNumberController = TextEditingController();
  var dailyBedPriceController = TextEditingController();
  var monthlyBedPriceController = TextEditingController();
  var featureController = TextEditingController();
  var otherDetailsController = TextEditingController();

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

  RxBool dailyBooking = false.obs;
  RxBool monthlyBooking = false.obs;
  RxBool isAvailable = false.obs;
  chooseIsAvailable(bool value) {
    isAvailable.value = value;
    update();
  }
  chooseDailyBooking(bool value) {
    dailyBooking.value = value;
    update();
  }
  chooseMonthlyBooking(bool value) {
    monthlyBooking.value = value;
    update();
  }

  static RoomManagementController get instance =>
      Get.put(RoomManagementController());

  RxList roomsList = <DakliaRoomModel>[].obs;
  RxBool isLoading = false.obs;
  var storage = GetStorage();
  var provider = DakliaRoomProvider();
  getRoomsList() async {
    isLoading.value = true;
    var data = await provider
        .getRoomsList(
      storage.read('dakliaId').toString(),
    )
        .timeout(
      const Duration(seconds: 3),
      onTimeout: () {
        EasyLoading.dismiss();
        isLoading.value = false;
        update();
        return DakliaRoomModel();
      },
    );
    if (data != null) {
      roomsList.clear();
      roomsList.add(data);
    }
    isLoading.value = false;
    EasyLoading.dismiss();
    update();
  }

  @override
  void onInit() async{
    super.onInit();
    roomNumberController = TextEditingController();
    allBedsNumberController = TextEditingController();
    emptyBedsNumberController = TextEditingController();
    dailyBedPriceController = TextEditingController();
    monthlyBedPriceController = TextEditingController();
    featureController = TextEditingController();
    otherDetailsController = TextEditingController();
   await getRoomsList();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    roomNumberController.dispose();
    allBedsNumberController.dispose();
    emptyBedsNumberController.dispose();
    dailyBedPriceController.dispose();
    monthlyBedPriceController.dispose();
    featureController.dispose();
    otherDetailsController.dispose();
    super.onClose();
  }
}
