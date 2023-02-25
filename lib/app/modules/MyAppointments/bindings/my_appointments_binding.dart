import 'package:get/get.dart';

import '../controllers/my_appointments_controller.dart';

class MyAppointmentsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyAppointmentsController>(
      () => MyAppointmentsController(),
    );
  }
}
