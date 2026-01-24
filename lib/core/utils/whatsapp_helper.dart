import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import 'package:sakan/constants/dialogs.dart';

class WhatsAppHelper {
  // Customer service WhatsApp number
  static const String customerServiceNumber = '+249114591010';

  /// Launch WhatsApp with the customer service number
  static Future<void> launchWhatsApp(BuildContext context,
      {String? message}) async {
    try {
      // Remove + from phone number for WhatsApp URL format
      final phoneNumber = customerServiceNumber.replaceAll('+', '');

      // Try multiple URL formats for better compatibility
      List<String> urlsToTry = [
        // WhatsApp web URL (wa.me)
        'https://wa.me/$phoneNumber${message != null ? '?text=${Uri.encodeComponent(message)}' : ''}',
        // WhatsApp app URL scheme
        'whatsapp://send?phone=$phoneNumber${message != null ? '&text=${Uri.encodeComponent(message)}' : ''}',
        // Alternative API URL
        'https://api.whatsapp.com/send?phone=$phoneNumber${message != null ? '&text=${Uri.encodeComponent(message)}' : ''}',
      ];

      bool launched = false;

      for (String url in urlsToTry) {
        try {
          final uri = Uri.parse(url);
          debugPrint('📱 Trying to launch: $url');

          if (await canLaunchUrl(uri)) {
            debugPrint('✅ Can launch: $url');
            await launchUrl(
              uri,
              mode: LaunchMode.externalApplication,
            );
            launched = true;
            break;
          } else {
            debugPrint('❌ Cannot launch: $url');
          }
        } catch (e) {
          debugPrint('❌ Error trying $url: $e');
          continue;
        }
      }

      if (!launched) {
        _showError(context, 'whatsapp_not_available'.tr);
      }
    } catch (e) {
      debugPrint('❌ Error launching WhatsApp: $e');
      _showError(context, 'error_opening_whatsapp'.tr);
    }
  }

  /// Show error message
  static void _showError(BuildContext context, String message) {
    Dialogs.errorDialog(
      context,
      message,
    );
  }
}
