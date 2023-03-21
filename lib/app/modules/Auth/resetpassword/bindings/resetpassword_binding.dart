import 'package:get/get.dart';

import '../../controllers/reset_password_controller.dart';

class ResetpasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ResetpasswordController>(
      () => ResetpasswordController(),
    );
  }
}
