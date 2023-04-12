import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../constants/dialogs.dart';
import '../models/daklia_rooms_models.dart';
import '../providers/add_room_provider.dart';
import '../providers/daklia_room_provider.dart';

class RoomManagementController extends GetxController {
  RxString imagePath = ''.obs;
  File? image;
  int? roomNumber;
  String? roomType;
  int? roomPrice;
  String? bookingType;
  int? pricePerMonth;
  int? pricePerDay;
  int? numberOfBeds;
  int? numAvailableBeds;

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

  final provider = DakliaRoomProvider();
  final addRoomProvider = AddRoomProvider();
  final storage = GetStorage();
  final roomsList = <DakliaRoomModel>[].obs;
  final isLoading = false.obs;

  // method to get rooms list from api
  Future<void> getRoomsList() async {
    final dakliaId = storage.read('dakliaId').toString();
    try {
      isLoading.value = true;
      final data = await provider.getRoomsList(dakliaId);
      roomsList.clear();
      roomsList.addAll(data);
      print('this is the list length: ${roomsList.length}');
    } catch (e) {
      print(e);
      Dialogs.errorDialog(Get.context!, 'Failed_to_load_rooms'.tr);
    }
    isLoading.value = false;
    EasyLoading.dismiss();
    update();
  }
  // method to add new room
  Future<void> addNewRoom() async {
    try {
      final data = await addRoomProvider.addNewRoom(
        roomImage: image!,
        roomNumber: roomNumber!,
        roomType: roomType!,
        roomPrice: roomPrice!,
        bookingType: bookingType!,
        pricePerMonth: pricePerMonth!,
        pricePerDay: pricePerDay!,
        numberOfBeds: numberOfBeds!,
        numAvailableBeds: numAvailableBeds!,
      );
      print('this is the data: $data');
    } catch (e) {
      print(e);
      Dialogs.errorDialog(Get.context!, 'Failed_to_add_room'.tr);
    }
    isLoading.value = false;
    EasyLoading.dismiss();
    update();
  }


  @override
  void onInit() {
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
