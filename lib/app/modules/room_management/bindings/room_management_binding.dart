import 'package:get/get.dart';

import '../controllers/room_management_controller.dart';

class RoomManagementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RoomManagementController>(
      () => RoomManagementController(),
    );
  }
}
