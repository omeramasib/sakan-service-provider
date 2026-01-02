import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sakan/constants/colors_manager.dart';
import 'package:sakan/constants/images_manager.dart';

import '../controllers/splash_screen_controller.dart';

/// Splash screen view with reactive states for loading, maintenance, and update.
class SplashScreenView extends GetView<SplashScreenController> {
  const SplashScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.mainColor,
      body: SafeArea(
        child: Obx(() {
          // Show maintenance view
          if (controller.showMaintenance.value) {
            return _buildMaintenanceView();
          }

          // Show force update view
          if (controller.showForceUpdate.value) {
            return _buildForceUpdateView();
          }

          // Default loading view
          return _buildLoadingView();
        }),
      ),
    );
  }

  /// Loading view with logo and progress indicator.
  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            ImagesManager.logo,
            width: 188,
            height: 188,
            color: ColorsManager.whiteColor,
          ),
          const SizedBox(height: 40),
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(ColorsManager.whiteColor),
            strokeWidth: 3,
          ),
        ],
      ),
    );
  }

  /// Maintenance mode view - blocking, cannot be dismissed.
  Widget _buildMaintenanceView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Maintenance icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: ColorsManager.whiteColor.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.construction_rounded,
                size: 60,
                color: ColorsManager.whiteColor,
              ),
            ),
            const SizedBox(height: 32),

            // Title
            Text(
              'under_maintenance'.tr.isNotEmpty
                  ? 'under_maintenance'.tr
                  : 'Under Maintenance',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: ColorsManager.whiteColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Message
            Obx(() => Text(
                  controller.maintenanceMessage.value,
                  style: const TextStyle(
                    fontSize: 16,
                    color: ColorsManager.whiteColor,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                )),
            const SizedBox(height: 32),

            // Retry button (optional)
            OutlinedButton.icon(
              onPressed: controller.retry,
              style: OutlinedButton.styleFrom(
                foregroundColor: ColorsManager.whiteColor,
                side: const BorderSide(color: ColorsManager.whiteColor),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              icon: const Icon(Icons.refresh),
              label: Text(
                'retry'.tr.isNotEmpty ? 'retry'.tr : 'Retry',
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Force update view - blocking with store link button.
  Widget _buildForceUpdateView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Update icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: ColorsManager.whiteColor.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.system_update_rounded,
                size: 60,
                color: ColorsManager.whiteColor,
              ),
            ),
            const SizedBox(height: 32),

            // Title
            Text(
              'update_required'.tr.isNotEmpty
                  ? 'update_required'.tr
                  : 'Update Required',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: ColorsManager.whiteColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Message
            Text(
              'update_message'.tr.isNotEmpty
                  ? 'update_message'.tr
                  : 'A new version of the app is available. Please update to continue using the app.',
              style: const TextStyle(
                fontSize: 16,
                color: ColorsManager.whiteColor,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // New version display
            Obx(() => controller.newVersion.value.isNotEmpty
                ? Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: ColorsManager.whiteColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${'new_version'.tr.isNotEmpty ? 'new_version'.tr : 'New Version'}: ${controller.newVersion.value}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: ColorsManager.whiteColor,
                      ),
                    ),
                  )
                : const SizedBox.shrink()),
            const SizedBox(height: 32),

            // Update button
            ElevatedButton.icon(
              onPressed: controller.openStore,
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorsManager.whiteColor,
                foregroundColor: ColorsManager.mainColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              icon: const Icon(Icons.download_rounded),
              label: Text(
                'update_now'.tr.isNotEmpty ? 'update_now'.tr : 'Update Now',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
