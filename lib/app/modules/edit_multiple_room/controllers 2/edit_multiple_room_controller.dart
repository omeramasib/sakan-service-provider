import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sakan/app/modules/room_management/controllers/room_management_controller.dart';

import '../../../../constants/colors_manager.dart';
import '../../../../constants/dialogs.dart';
import '../provider/edit_multiple_room_provider.dart';

class EditMultipleRoomController extends GetxController {
  RxString imagePath = ''.obs;
  File image = File('');
  int roomNumber = 0;
  int numberOfBeds = 0;
  int? numAvailableBeds;
  RxBool dailyBooking = false.obs;
  RxBool monthlyBooking = false.obs;
  bool daily_booking = false;
  bool monthly_booking = false;
  int pricePerDay = 0;
  int pricePerMonth = 0;

  final isLoading = false.obs;

  var formKey = GlobalKey<FormState>();
  var roomNumberController = TextEditingController();
  var allBedsNumberController = TextEditingController();
  var emptyBedsNumberController = TextEditingController();
  var dailyBedPriceController = TextEditingController();
  var monthlyBedPriceController = TextEditingController();
  var pricePerDayController = TextEditingController();
  var pricePerMonthController = TextEditingController();

  var roomController = Get.put(RoomManagementController());
  var provider = EditMultipleRoomProvider();

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

  chooseDailyBooking(bool value) {
    dailyBooking.value = value;
    if (dailyBooking.value == true) {
      daily_booking = true;
      print('daily booking is $daily_booking');
    } else {
      daily_booking = false;
      print('daily booking is $daily_booking');
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

  Future<void> updateMultipleRoom() async {
    try {
     await provider.editMultipleRoom(
          image: image,
          roomNumber: roomNumber == 0
              ? roomNumber = roomController.getRooms.roomNumber!
              : roomNumber,
          numberOfBeds: numberOfBeds == 0
              ? numberOfBeds = roomController.getRooms.numberOfBeds!
              : numberOfBeds,
          numberOfAvailableBeds : numAvailableBeds!,

          dailyBooking: daily_booking == false
              ? daily_booking = roomController.getRooms.dailyBooking!
              : daily_booking,
          monthlyBooking: monthly_booking == false
              ? monthly_booking = roomController.getRooms.monthlyBooking!
              : monthly_booking,
          pricePerDay: pricePerDay == 0
              ? pricePerDay = roomController.getRooms.pricePerDay!.toInt()
              : pricePerDay,
          pricePerMonth: pricePerMonth == 0
              ? pricePerMonth = roomController.getRooms.pricePerMonth!.toInt()
              : pricePerMonth,
          roomId: roomController.getRooms.roomId!.toString());
    } catch (e) {
      Dialogs.errorDialog(Get.context!, 'Failed_to_update_multiple_room'.tr);
    }
    isLoading.value = false;
    EasyLoading.dismiss();
    update();
  }

  checkSubmitEMR() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }

    formKey.currentState!.save();

    // Set price values from controllers if they're not already set
    if (dailyBedPriceController.text.isNotEmpty) {
      pricePerDay = int.tryParse(dailyBedPriceController.text) ?? 0;
    }
    if (monthlyBedPriceController.text.isNotEmpty) {
      pricePerMonth = int.tryParse(monthlyBedPriceController.text) ?? 0;
    }

    // Set default values for unselected booking types
    if (!daily_booking) {
      pricePerDay = 0;
    }
    if (!monthly_booking) {
      pricePerMonth = 0;
    }

    EasyLoading.show(status: 'loading'.tr);
    await updateMultipleRoom();
    update();
  }

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    roomNumberController = TextEditingController();
    allBedsNumberController = TextEditingController();
    emptyBedsNumberController = TextEditingController();
    dailyBedPriceController = TextEditingController();
    monthlyBedPriceController = TextEditingController();
    pricePerDayController = TextEditingController();
    pricePerMonthController = TextEditingController();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    roomNumberController.dispose();
    allBedsNumberController.dispose();
    emptyBedsNumberController.dispose();
    dailyBedPriceController.dispose();
    monthlyBedPriceController.dispose();
    pricePerDayController.dispose();
    pricePerMonthController.dispose();
  }

  void increment() => count.value++;
}
