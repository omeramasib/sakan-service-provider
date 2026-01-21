import 'package:get/get.dart';

import '../controllers/complete_daklia_account2_controller.dart';

class CompleteDakliaAccount2Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CompleteDakliaAccount2Controller>(
      () => CompleteDakliaAccount2Controller(),
    );
  }
}
