import 'package:get/get.dart';

import 'package:sakan/app/modules/MyAppointments/controllers/appointment_detailes_controller.dart';

import '../controllers/my_appointments_controller.dart';

class MyAppointmentsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AppointmentDetailesController>(
      () => AppointmentDetailesController(),
    );
    Get.lazyPut<MyAppointmentsController>(
      () => MyAppointmentsController(),
    );
  }
}
