import 'package:get/get.dart';

import '../controllers/more_screen_controller.dart';

class MoreScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MoreScreenController>(
      () => MoreScreenController(),
    );
  }
}
