import 'package:get/get.dart';

import '../controllers/edit_single_room_controller.dart';

class EditSingleRoomBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditSingleRoomController>(
      () => EditSingleRoomController(),
    );
  }
}
