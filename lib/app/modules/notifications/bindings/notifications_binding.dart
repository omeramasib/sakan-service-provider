import 'package:get/get.dart';

import '../controllers/notifications_controller.dart';
import '../provider/notification_provider.dart';

class NotificationsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationsController>(
      () => NotificationsController(),
    );
    Get.lazyPut<NotificationProvider>(
      () => NotificationProvider(),
    );
  }
}
