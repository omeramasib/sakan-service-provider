import 'package:get/get.dart';

import '../controllers/daklia_profile_controller.dart';

class DakliaProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DakliaProfileController>(
      () => DakliaProfileController(),
    );
  }
}
