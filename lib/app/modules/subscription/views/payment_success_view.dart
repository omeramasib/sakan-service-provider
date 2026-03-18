import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sakan/constants/colors_manager.dart';
import 'package:sakan/constants/fonts_manager.dart';
import 'package:sakan/constants/styles_manager.dart';
import 'package:sakan/app/routes/app_pages.dart';

class PaymentSuccessView extends StatelessWidget {
  const PaymentSuccessView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.whiteColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              const Icon(
                Icons.check_circle_outline,
                color: ColorsManager.successStyleColor,
                size: 100,
              ),
              const SizedBox(height: 24),
              Text(
                'payment_success'.tr,
                textAlign: TextAlign.center,
                style: getBoldStyle(
                  fontSize: FontSizeManager.s24,
                  color: ColorsManager.blackColor,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'subscription_activated_success'.tr,
                textAlign: TextAlign.center,
                style: getRegularStyle(
                  fontSize: FontSizeManager.s16,
                  color: ColorsManager.fontColor,
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  Get.offAllNamed(Routes.HOME);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsManager.mainColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'go_to_home'.tr,
                  style: getMediumStyle(
                    fontSize: FontSizeManager.s16,
                    color: ColorsManager.whiteColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
