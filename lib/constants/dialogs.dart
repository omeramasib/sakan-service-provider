import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sakan/constants/styles_manager.dart';

class Dialogs {
  // Sucsses Dialog
  static void successDialog(BuildContext context, String message) {
    Get.snackbar(
      '',
      message,
      messageText: Text(message,
          style: getRegularStyle(color: Colors.green, fontSize: 16)),
      leftBarIndicatorColor: Colors.green,
      borderRadius: 6,
      margin: const EdgeInsets.only(
        top: 10,
        left: 10,
        right: 10,
      ),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

// Connection Error Dialog
  static void connectionErrorDialog(BuildContext context) {
    Get.snackbar(
      '',
      'no_internet'.tr,
      messageText: Text('no_internet'.tr,
          style: getRegularStyle(color: Colors.red, fontSize: 16)),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.white,
      leftBarIndicatorColor: Colors.red,
      borderRadius: 6,
      margin: const EdgeInsets.only(
        top: 10,
        left: 10,
        right: 10,
      ),
      duration: const Duration(seconds: 2),
    );
  }

// Error Dialog
  static void errorDialog(BuildContext context, String message) {
    Get.snackbar(
      '',
      message,
      messageText: Text(message,
          style: getRegularStyle(color: Colors.red, fontSize: 16)),
      leftBarIndicatorColor: Colors.red,
      borderRadius: 6,
      margin: const EdgeInsets.only(
        top: 10,
        left: 10,
        right: 10,
      ),
      colorText: Colors.red,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  // Network Error Dialog - specifically for network/connection errors
  static void networkErrorDialog(BuildContext context) {
    Get.snackbar(
      '',
      'network_error'.tr,
      messageText: Text('network_error_message'.tr,
          style: getRegularStyle(color: Colors.orange, fontSize: 16)),
      icon: const Icon(Icons.wifi_off_rounded, color: Colors.orange, size: 28),
      leftBarIndicatorColor: Colors.orange,
      borderRadius: 6,
      margin: const EdgeInsets.only(
        top: 10,
        left: 10,
        right: 10,
      ),
      colorText: Colors.orange,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }
}
