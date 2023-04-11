import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../constants/dialogs.dart';
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
  // define instance of DakliaRoomsModel()
  // var roomModelList = dakliaRoomModelFromJson;
  final provider = DakliaRoomProvider();
  final storage = GetStorage();
  final roomsList = <DakliaRoomModel>[].obs;
  final isLoading = false.obs;

  Future<void> getRoomsList() async {
    isLoading.value = true;
    final dakliaId = storage.read('dakliaId').toString();
    try {
      final data = await provider.getRoomsList(dakliaId);
      final roomsData = List<Map<String, dynamic>>.from(data);
      final rooms = roomsData
          .map((roomData) => DakliaRoomModel.fromJson(roomData))
          .toList();
      roomsList.value = rooms;
    } catch (e) {
      print(e);
      Dialogs.errorDialog(Get.context!, 'Failed to load rooms');
    }
    isLoading.value = false;
    EasyLoading.dismiss();
    update();
  }
  // RxList roomsList = [DakliaRoomModel].obs;
  // RxBool isLoading = false.obs;
  // var storage = GetStorage();
  // var provider = DakliaRoomProvider();
  // getRoomsList() async {
  //   isLoading.value = true;
  //   var data = await provider
  //       .getRoomsList(
  //     storage.read('dakliaId').toString(),
  //   )
  //       .timeout(
  //     const Duration(seconds: 3),
  //     onTimeout: () {
  //       EasyLoading.dismiss();
  //       isLoading.value = false;
  //       update();
  //     },
  //   );
  //   if (data != null) {
  //     roomsList.clear();
  //     roomsList.add(data);
  //     print("this is the list length: ${roomsList.length}");
  //   }
  //   isLoading.value = false;
  //   EasyLoading.dismiss();
  //   update();
  // }

  @override
  void onInit(){
    super.onInit();
    roomNumberController = TextEditingController();
    allBedsNumberController = TextEditingController();
    emptyBedsNumberController = TextEditingController();
    dailyBedPriceController = TextEditingController();
    monthlyBedPriceController = TextEditingController();
    featureController = TextEditingController();
    otherDetailsController = TextEditingController();
     getRoomsList();
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
