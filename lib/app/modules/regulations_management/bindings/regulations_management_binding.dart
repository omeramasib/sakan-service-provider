import 'package:get/get.dart';

import '../controllers/regulations_management_controller.dart';

class RegulationsManagementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegulationsManagementController>(
      () => RegulationsManagementController(),
    );
  }
}
