import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sakan/constants/colors_manager.dart';
import 'package:sakan/constants/styles_manager.dart';
import 'package:sakan/constants/fonts_manager.dart';

/// A reusable full-screen network error widget with retry functionality.
/// Supports both Arabic and English localization.
class NetworkErrorScreen extends StatelessWidget {
  /// Callback function when retry button is pressed.
  final VoidCallback? onRetry;

  /// Optional custom title. Defaults to localized 'network_error_title'.
  final String? title;

  /// Optional custom message. Defaults to localized 'network_error_message'.
  final String? message;

  /// Whether to show the retry button. Defaults to true.
  final bool showRetryButton;

  const NetworkErrorScreen({
    Key? key,
    this.onRetry,
    this.title,
    this.message,
    this.showRetryButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Network error icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: ColorsManager.mainColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.wifi_off_rounded,
                size: 60,
                color: ColorsManager.mainColor,
              ),
            ),
            const SizedBox(height: 32),

            // Title
            Text(
              title ?? 'network_error_title'.tr,
              style: getBoldStyle(
                color: ColorsManager.fontColor,
                fontSize: FontSizeManager.s18,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Message
            Text(
              message ?? 'network_error_message'.tr,
              style: getRegularStyle(
                color: ColorsManager.fontColor.withValues(alpha: 0.7),
                fontSize: FontSizeManager.s14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Retry button
            if (showRetryButton && onRetry != null)
              ElevatedButton.icon(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsManager.mainColor,
                  foregroundColor: ColorsManager.whiteColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                icon: const Icon(Icons.refresh),
                label: Text(
                  'retry'.tr,
                  style: getMediumStyle(
                    color: ColorsManager.whiteColor,
                    fontSize: FontSizeManager.s16,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
