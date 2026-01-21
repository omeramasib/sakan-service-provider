import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../../services/secure_storage_service.dart';
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
  // Multiple images support
  RxList<String> imagePaths = <String>[].obs;
  List<File> images = [];

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

  // Pick multiple images from gallery
  void pickMultipleImages() async {
    final List<XFile> pickedFiles = await ImagePicker().pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      for (var file in pickedFiles) {
        images.add(File(file.path));
        imagePaths.add(file.path);
      }
      update();
      Get.back();
    }
  }

  // Pick single image from gallery (for backward compatibility)
  void getImageFromGallery(ImageSource imageSource) async {
    final pickedFile = await ImagePicker().pickImage(source: imageSource);
    if (pickedFile != null) {
      images.add(File(pickedFile.path));
      imagePaths.add(pickedFile.path);
      update();
      Get.back();
    }
    update();
  }

  // Pick image from camera
  void getImageFromCamera(ImageSource imageSource) async {
    final pickedFile = await ImagePicker().pickImage(source: imageSource);
    if (pickedFile != null) {
      images.add(File(pickedFile.path));
      imagePaths.add(pickedFile.path);
      update();
      Get.back();
    }
    update();
  }

  // Remove image at index
  void removeImage(int index) {
    if (index >= 0 && index < images.length) {
      images.removeAt(index);
      imagePaths.removeAt(index);
      update();
    }
  }

  // Clear all images
  void clearImages() {
    images.clear();
    imagePaths.clear();
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
  final storage = SecureStorageService.instance;
  final roomsList = <DakliaRoomModel>[].obs;
  final featuresList = <RoomFeaturesModel>[].obs;
  final isLoading = false.obs;

  DakliaRoomModel myRooms = DakliaRoomModel();

  set setRooms(DakliaRoomModel rooms) {
    myRooms = rooms;
    update();
  }

  DakliaRoomModel get getRooms => myRooms;

  RoomFeaturesModel myRoomFeatures = RoomFeaturesModel();

  // Computed properties for room statistics
  int get totalRooms => roomsList.length;

  int get occupiedRooms => roomsList
      .where(
          (room) => room.numAvailableBeds == 0 || room.numAvailableBeds == null)
      .length;

  int get availableRooms => roomsList
      .where(
          (room) => room.numAvailableBeds != null && room.numAvailableBeds! > 0)
      .length;

  // method to get rooms list from api
  Future<void> getRoomsList() async {
    isLoading.value = true;
    final dakliaId = (await storage.read('dakliaId')).toString();
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

  // method to add new room with multiple images
  Future<void> addNewMultipleRoom() async {
    try {
      final data = await addRoomProvider.addMultipleRoom(
        roomImages: images,
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
      // Clear images after successful upload
      clearImages();
    } catch (e) {
      print(e);
      Dialogs.errorDialog(Get.context!, 'Failed_to_add_room'.tr);
    }
    isLoading.value = false;
    EasyLoading.dismiss();
    update();
  }

  // method to remove room
  FutureOr<void> removeRoom(String roomId) async {
    EasyLoading.show(status: 'loading'.tr);
    try {
      final dakliaId = (await storage.read('dakliaId')).toString();
      final data = await removeRoomProvider.deleteRoom(dakliaId, roomId);
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
    if (imagePaths.isEmpty) {
      Get.showSnackbar(
        GetSnackBar(
          message: 'please_select_room_image'.tr,
          backgroundColor: ColorsManager.errorColor,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    if (roomType.isEmpty) {
      Get.showSnackbar(
        GetSnackBar(
          message: 'select_room_type'.tr,
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

    // Ensure boolean values are properly set
    daily_booking = dailyBooking.value;
    monthly_booking = monthlyBooking.value;

    // Debug logging
    log('=== DEBUG: Controller values before API call ===');
    log('roomNumber: $roomNumber (type: ${roomNumber.runtimeType})');
    log('roomType: "$roomType" (type: ${roomType.runtimeType})');
    log('pricePerMonth: $pricePerMonth (type: ${pricePerMonth.runtimeType})');
    log('pricePerDay: $pricePerDay (type: ${pricePerDay.runtimeType})');
    log('numberOfBeds: $numberOfBeds (type: ${numberOfBeds.runtimeType})');
    log('numAvailableBeds: $numAvailableBeds (type: ${numAvailableBeds.runtimeType})');
    log('daily_booking: $daily_booking (type: ${daily_booking.runtimeType})');
    log('monthly_booking: $monthly_booking (type: ${monthly_booking.runtimeType})');
    log('images count: ${images.length}');
    log('==============================================');

    // Validate that at least one booking type is selected
    if (!daily_booking && !monthly_booking) {
      Get.showSnackbar(
        GetSnackBar(
          message: 'select_booking_type'.tr,
          backgroundColor: ColorsManager.errorColor,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    // Set price values from controllers if they're not already set
    if (dailyBedPriceController.text.isNotEmpty) {
      pricePerDay = int.tryParse(dailyBedPriceController.text) ?? 0;
    }
    if (monthlyBedPriceController.text.isNotEmpty) {
      pricePerMonth = int.tryParse(monthlyBedPriceController.text) ?? 0;
    }

    // Validate price fields based on selected booking types
    if (daily_booking &&
        (pricePerDay == 0 || dailyBedPriceController.text.isEmpty)) {
      Get.showSnackbar(
        GetSnackBar(
          message: 'enter_daily_price'.tr,
          backgroundColor: ColorsManager.errorColor,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    if (monthly_booking &&
        (pricePerMonth == 0 || monthlyBedPriceController.text.isEmpty)) {
      Get.showSnackbar(
        GetSnackBar(
          message: 'enter_monthly_price'.tr,
          backgroundColor: ColorsManager.errorColor,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    // Set default values for unselected booking types
    if (!daily_booking) {
      pricePerDay = 0;
    }
    if (!monthly_booking) {
      pricePerMonth = 0;
    }

    EasyLoading.show(status: 'loading'.tr);
    addNewMultipleRoom();
    update();
  }

  // method to add single room
  Future<void> addSingleRoom() async {
    log('this is the number of available beds: $numAvailableBedsSingleRoom');
    try {
      final data = await addRoomProvider.addSingleRoom(
        roomImages: images,
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
      // Clear images after successful upload
      clearImages();
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
    if (imagePaths.isEmpty) {
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
  Future<bool> addRoomFeature() async {
    log('this is the room id: ${getRooms.roomId}');
    try {
      final data = await roomFeatureProvider.addFeature(
        roomId: getRooms.roomId!,
        featureName: featureName!,
        featureDescription: featureDescription!,
      );
      print('this is the data: $data');
      // Refresh features list after successful addition
      await refreshRoomFeatures();
      isLoading.value = false;
      EasyLoading.dismiss();
      update();
      return true;
    } catch (e) {
      print(e);
      Dialogs.errorDialog(Get.context!, 'Failed_to_add_feature'.tr);
      isLoading.value = false;
      EasyLoading.dismiss();
      update();
      return false;
    }
  }

  // method to check add room feature
  Future<bool> checkAddRoomFeature() async {
    var isValid = roomFeaturesFormKey.currentState!.validate();
    if (!isValid) {
      return false;
    }

    roomFeaturesFormKey.currentState!.save();
    EasyLoading.show(status: 'loading'.tr);
    final success = await addRoomFeature();
    return success;
  }

  Future<bool> checkEditAddRoomFeature() async {
    var isValid = editAddFeaturesFormKey.currentState!.validate();
    if (!isValid) {
      return false;
    }

    editAddFeaturesFormKey.currentState!.save();
    EasyLoading.show(status: 'loading'.tr);
    final success = await addRoomFeature();
    return success;
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
