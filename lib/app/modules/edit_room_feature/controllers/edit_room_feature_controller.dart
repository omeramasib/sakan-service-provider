import 'package:get/get.dart';

import '../../room_management/controllers/room_management_controller.dart';

class EditRoomFeatureController extends GetxController {
  //TODO: Implement EditRoomFeatureController
  var roomController = Get.put(RoomManagementController());
  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    roomController.getRoomFeatures();
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
