import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sakan/constants/colors_manager.dart';
import 'package:sakan/constants/fonts_manager.dart';
import 'package:sakan/constants/styles_manager.dart';

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
      body: notificationExist(context, controller) 
      // body:noNotificationYet(context),
    );
  }
}
