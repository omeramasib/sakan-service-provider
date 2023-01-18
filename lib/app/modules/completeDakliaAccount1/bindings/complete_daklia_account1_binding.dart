import 'package:get/get.dart';

import '../controllers/complete_daklia_account1_controller.dart';

class CompleteDakliaAccount1Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CompleteDakliaAccount1Controller>(
      () => CompleteDakliaAccount1Controller(),
    );
  }
}
