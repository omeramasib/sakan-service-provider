import 'package:get/get.dart';

import '../controllers/edit_daklia_profile_controller.dart';

class EditDakliaProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditDakliaProfileController>(
      () => EditDakliaProfileController(),
    );
  }
}
