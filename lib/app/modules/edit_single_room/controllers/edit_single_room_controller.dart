import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../constants/colors_manager.dart';
import '../../../../constants/dialogs.dart';
import '../../room_management/controllers/room_management_controller.dart';
import '../provider/edit_single_room_provider.dart';

class EditSingleRoomController extends GetxController {
  //TODO: Implement EditSingleRoomController

  final count = 0.obs;
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

  int numAvailableBedsSingleRoom = 0;
  RxBool isAvailable = false.obs;
  var formKey = GlobalKey<FormState>();
  var roomNumberController = TextEditingController();
  var dailyBedPriceController = TextEditingController();
  var monthlyBedPriceController = TextEditingController();
  var pricePerDayController = TextEditingController();
  var pricePerMonthController = TextEditingController();

  var provider = EditSingleRoomProvider();
  var roomController = Get.put(RoomManagementController());

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

  chooseIsAvailable(bool value) {
    isAvailable.value = value;
    if (isAvailable.value == true) {
      numAvailableBedsSingleRoom = 1;
      print('is available is true');
    } else {
      numAvailableBedsSingleRoom = 0;
      print('is available is false');
    }
    update();
  }

  Future<void> editSingleRoom() async {
    try {
      await provider.editSingleRoom(
          image: image,
          roomNumber: roomNumber == 0
              ? roomNumber = roomController.getRooms.roomNumber!
              : roomNumber,
          pricePerMonth: pricePerMonth == 0
              ? pricePerMonth = roomController.getRooms.pricePerMonth!.toInt()
              : pricePerMonth,
          pricePerDay: pricePerDay == 0
              ? pricePerDay = roomController.getRooms.pricePerDay!.toInt()
              : pricePerDay,
          numberOfAvailableBeds: numAvailableBedsSingleRoom,
          dailyBooking: daily_booking == false
              ? daily_booking = roomController.getRooms.dailyBooking!
              : daily_booking,
          monthlyBooking: monthly_booking == false
              ? monthly_booking = roomController.getRooms.monthlyBooking!
              : monthly_booking,
          roomId: roomController.getRooms.roomId!.toString());
    } catch (e) {
      print(e);
      Dialogs.errorDialog(Get.context!, 'Failed_to_add_room'.tr);
    }
    EasyLoading.dismiss();
    update();
  }

  checkSubmitESR() async {
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

    await editSingleRoom();
    update();
  }

  @override
  void onInit() {
    super.onInit();
    roomNumberController = TextEditingController();
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
    dailyBedPriceController.dispose();
    monthlyBedPriceController.dispose();
    pricePerDayController.dispose();
    pricePerMonthController.dispose();
  }

  void increment() => count.value++;
}
