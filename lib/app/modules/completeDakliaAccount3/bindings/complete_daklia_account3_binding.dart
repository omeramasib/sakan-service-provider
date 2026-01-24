import 'package:get/get.dart';

import '../controllers/complete_daklia_account3_controller.dart';

class CompleteDakliaAccount3Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CompleteDakliaAccount3Controller>(
      () => CompleteDakliaAccount3Controller(),
    );
  }
}
