import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../constants/colors_manager.dart';
import '../../../../constants/dialogs.dart';
import '../models/daklia_rooms_models.dart';
import '../models/room_features_model.dart';
import '../providers/room_features_provider.dart';
import '../providers/add_room_provider.dart';
import '../providers/daklia_room_provider.dart';
import '../providers/remove_room_provider.dart';

class RoomManagementController extends GetxController {
  RxString imagePath = ''.obs;
  File? image;
  int? roomNumber;
  String roomType = '';
  int pricePerMonth = 0;
  int pricePerDay = 0;
  int? numberOfBeds;
  int? numAvailableBeds;
  int numAvailableBedsSingleRoom = 0;
  bool daily_booking = false;
  bool monthly_booking = false;
  String? roomId = '';
  String? featureName = '';
  String? featureDescription = '';

  var roomNumberController = TextEditingController();
  var allBedsNumberController = TextEditingController();
  var emptyBedsNumberController = TextEditingController();
  var dailyBedPriceController = TextEditingController();
  var monthlyBedPriceController = TextEditingController();
  var featureController = TextEditingController();
  var otherDetailsController = TextEditingController();
  var editFeatureController = TextEditingController();
  var editOtherDetailsController = TextEditingController();

  var formKey = GlobalKey<FormState>();
  var roomFeaturesFormKey = GlobalKey<FormState>();
  var editAddFeaturesFormKey = GlobalKey<FormState>();

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
    if (isAvailable.value == true) {
      numAvailableBedsSingleRoom = 1;
      print('is available is true');
    } else {
      numAvailableBedsSingleRoom = 0;
      print('is available is false');
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
  final removeRoomProvider = RemoveRoomProvider();
  final roomFeatureProvider = RoomFeaturesProvider();
  final storage = GetStorage();
  final roomsList = <DakliaRoomModel>[].obs;
  final featuresList = <RoomFeaturesModel>[].obs;
  final isLoading = false.obs;

  DakliaRoomModel myRooms = new DakliaRoomModel();

  set setRooms(DakliaRoomModel rooms) {
    myRooms = rooms;
    update();
  }

  DakliaRoomModel get getRooms => myRooms;

  RoomFeaturesModel myRoomFeatures = new RoomFeaturesModel();

  // method to get rooms list from api
  Future<void> getRoomsList() async {
    isLoading.value = true;
    final dakliaId = storage.read('dakliaId').toString();
    try {
      final data = await provider.getRoomsList(dakliaId);
      roomsList.clear();
      roomsList.addAll(data);
      print('this is the list length: ${roomsList.length}');
    } catch (e) {
      print(e);
      Dialogs.errorDialog(Get.context!, 'Failed_to_load_rooms'.tr);
    }
    EasyLoading.dismiss();
    isLoading.value = false;
    update();
  }

  // method to add new room
  Future<void> addNewMultipleRoom() async {
    try {
      final data = await addRoomProvider.addMultipleRoom(
        roomImage: image!,
        roomNumber: roomNumber!,
        roomType: roomType,
        pricePerMonth: pricePerMonth,
        pricePerDay: pricePerDay,
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

  // method to remove room
  Future<void> removeRoom(String roomId) async {
    EasyLoading.show(status: 'loading'.tr);
    try {
      final data = await removeRoomProvider.deleteRoom(
          storage.read('dakliaId').toString(), roomId);
      print('this is the data: $data');
    } catch (e) {
      print(e);
      Dialogs.errorDialog(Get.context!, 'Failed_to_remove_room'.tr);
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

  // method to add single room
  Future<void> addSingleRoom() async {
    log('this is the number of available beds: $numAvailableBedsSingleRoom');
    try {
      final data = await addRoomProvider.addSingleRoom(
        roomImage: image!,
        roomNumber: roomNumber!,
        roomType: roomType,
        pricePerMonth: pricePerMonth,
        pricePerDay: pricePerDay,
        numberOfBeds: 1,
        numAvailableBeds: numAvailableBedsSingleRoom,
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

  Future<void> refreshRoomsList() async {
    await getRoomsList();
    update();
  }

  void checkAddSingleRoom() {
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
    addSingleRoom();
    update();
  }

  // method to get room features
  Future<void> getRoomFeatures() async {
    isLoading.value = true;
    log('this is the room id: ${getRooms.roomId}');
    try {
      final data = await roomFeatureProvider.getAllFeatures(
        roomId: getRooms.roomId!.toString(),
      );
      featuresList.clear();
      featuresList.addAll(data);
    } catch (e) {
      print(e);
      Dialogs.errorDialog(Get.context!, 'Failed_to_load_features'.tr);
    }
    EasyLoading.dismiss();
    isLoading.value = false;
    update();
  }

  // method to refresh room features
  Future<void> refreshRoomFeatures() async {
    await getRoomFeatures();
    update();
  }

  // method to add room feature
  Future<void> addRoomFeature() async {
    log('this is the room id: ${getRooms.roomId}');
    try {
      final data = await roomFeatureProvider.addFeature(
        roomId: getRooms.roomId!,
        featureName: featureName!,
        featureDescription: featureDescription!,
      );
      print('this is the data: $data');
    } catch (e) {
      print(e);
      Dialogs.errorDialog(Get.context!, 'Failed_to_add_feature'.tr);
    }
    isLoading.value = false;
    EasyLoading.dismiss();
    update();
  }

  // method to check add room feature
  void checkAddRoomFeature() {
    var isValid = roomFeaturesFormKey.currentState!.validate();
    if (!isValid) {
      return;
    }

    roomFeaturesFormKey.currentState!.save();
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
    addRoomFeature();
    update();
  }

  void checkEditAddRoomFeature() {
    var isValid = editAddFeaturesFormKey.currentState!.validate();
    if (!isValid) {
      return;
    }

    editAddFeaturesFormKey.currentState!.save();
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
    addRoomFeature();
    update();
  }

  @override
  void onInit() async {
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
    super.onClose();
  }
}
