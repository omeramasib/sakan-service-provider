import 'package:flutter/material.dart';

import '../../core/utils/whatsapp_helper.dart';

class CustomerServiceButton extends StatelessWidget {
  final double? iconSize;

  const CustomerServiceButton({
    super.key,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.support_agent,
          color: Colors.white,
          size: iconSize ?? 24,
        ),
      ),
      onPressed: () => WhatsAppHelper.launchWhatsApp(context),
      tooltip: 'Customer Service',
    );
  }
}