import 'package:get/get.dart';

import '../controllers/edit_room_feature_controller.dart';

class EditRoomFeatureBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditRoomFeatureController>(
      () => EditRoomFeatureController(),
    );
  }
}
