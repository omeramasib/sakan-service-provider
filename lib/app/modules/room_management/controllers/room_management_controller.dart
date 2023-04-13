import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../constants/colors_manager.dart';
import '../../../../constants/dialogs.dart';
import '../models/daklia_rooms_models.dart';
import '../providers/add_room_provider.dart';
import '../providers/daklia_room_provider.dart';

class RoomManagementController extends GetxController {
  RxString imagePath = ''.obs;
  File? image;
  int? roomNumber;
  String roomType = '';
  int? roomPrice = 0;
  int? pricePerMonth;
  int? pricePerDay;
  int? numberOfBeds;
  int? numAvailableBeds;
  bool daily_booking = false;
  bool monthly_booking = false;

  var roomNumberController = TextEditingController();
  var allBedsNumberController = TextEditingController();
  var emptyBedsNumberController = TextEditingController();
  var dailyBedPriceController = TextEditingController();
  var monthlyBedPriceController = TextEditingController();
  var featureController = TextEditingController();
  var otherDetailsController = TextEditingController();

  var formKey = GlobalKey<FormState>();

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
    if (dailyBooking.value == true) {
      daily_booking = true;
      print('daily booking is $daily_booking');
    } else {
      daily_booking = false;
      print('monthly booking is $monthly_booking');
    }
    update();
  }

  chooseMonthlyBooking(bool value) {
    monthlyBooking.value = value;
    if (monthlyBooking.value == true) {
      monthly_booking = true;
      print('monthly booking is $monthly_booking');
    } else {
      monthly_booking = false;
      print('monthly booking is $monthly_booking');
    }
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
  Future<void> addNewMultipleRoom() async {
    try {
      final data = await addRoomProvider.addMultipleRoom(
        roomImage: image!,
        roomNumber: roomNumber!,
        roomType: roomType,
        roomPrice: roomPrice!,
        pricePerMonth: pricePerMonth!,
        pricePerDay: pricePerDay!,
        numberOfBeds: numberOfBeds!,
        numAvailableBeds: numAvailableBeds!,
        dailyBooking: daily_booking,
        monthlyBooking: monthly_booking,
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

  void checkAddRoom() {
    var isValid = formKey.currentState!.validate();
    if (imagePath.value == '') {
      Get.showSnackbar(
        GetSnackBar(
          message: 'please_select_room_image'.tr,
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
    addNewMultipleRoom();
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
