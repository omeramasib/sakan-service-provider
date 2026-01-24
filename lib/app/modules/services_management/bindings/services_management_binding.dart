import 'package:get/get.dart';

import '../controllers/services_management_controller.dart';

class ServicesManagementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServicesManagementController>(
      () => ServicesManagementController(),
    );
  }
}
