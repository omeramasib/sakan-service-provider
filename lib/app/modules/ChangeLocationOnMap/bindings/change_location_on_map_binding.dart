import 'package:get/get.dart';

import '../controllers/change_location_on_map_controller.dart';

class ChangeLocationOnMapBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChangeLocationOnMapController>(
      () => ChangeLocationOnMapController(),
    );
  }
}
