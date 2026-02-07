import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../../../../constants/colors_manager.dart';
import '../../../../constants/fonts_manager.dart';
import '../../../../constants/styles_manager.dart';

import '../controllers/notifications_controller.dart';
import '../widgets/no_notification_yet.dart';
import '../widgets/notication_exist.dart';

class NotificationsView extends GetView<NotificationsController> {
  const NotificationsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: ColorsManager.greyColor,
        title: Text(
          'notifications'.tr,
          style: getMediumStyle(
            color: ColorsManager.mainColor,
            fontSize: FontSizeManager.s16,
          ),
        ),
        // create a custom back button with back icon
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: ColorsManager.fontColor,
          ),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.hasError.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(controller.errorMessage.value),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.loadNotifications(),
                  child: Text('retry'.tr),
                ),
              ],
            ),
          );
        }

        if (controller.notifications.isEmpty) {
          return noNotificationYet(context);
        }

        return notificationExist(context, controller);
      }),
    );
  }
}
