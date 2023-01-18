import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Dialogs {
  // Sucsses Dialog
  static void successDialog(BuildContext context, String message) {
    Get.snackbar(
      '',
      message,
      titleText: Text(
        'success'.tr,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      duration: const Duration(seconds: 2),
    );
  }

// Connection Error Dialog
  static void connectionErrorDialog(BuildContext context) {
    Get.snackbar(
      '',
      titleText: Text(
        'error'.tr,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      'no_internet'.tr,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 2),
    );
  }

// Error Dialog
  static void errorDialog(BuildContext context, String message) {
    Get.snackbar(
      '',
      message,
      titleText: Text(
        'error'.tr,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 2),
    );
  }
}
