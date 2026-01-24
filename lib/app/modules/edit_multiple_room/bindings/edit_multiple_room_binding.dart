import 'package:get/get.dart';

import '../controllers/edit_multiple_room_controller.dart';

class EditMultipleRoomBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditMultipleRoomController>(
      () => EditMultipleRoomController(),
    );
  }
}
