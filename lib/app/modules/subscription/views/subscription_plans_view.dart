import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sakan/constants/colors_manager.dart';
import 'package:sakan/constants/fonts_manager.dart';
import 'package:sakan/constants/styles_manager.dart';
import 'package:sakan/constants/images_manager.dart';
import 'package:sakan/constants/responsive_helper.dart';
import 'package:sakan/constants/values_manager.dart';
import 'package:sakan/widgets/responsive_builder.dart';
import '../controllers/subscription_controller.dart';
import 'cashipay_payment_view.dart';
import 'payment_webview_view.dart';

class SubscriptionPlansView extends GetView<SubscriptionController> {
  const SubscriptionPlansView({Key? key}) : super(key: key);

  /// Check if user can skip subscription prompt
  bool get canSkip {
    final args = Get.arguments;
    if (args is Map<String, dynamic>) {
      return args['canSkip'] == true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Get.locale?.languageCode == 'ar';

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async => canSkip,
      child: Scaffold(
        backgroundColor: ColorsManager.lightGreyColor,
        appBar: AppBar(
          backgroundColor: ColorsManager.whiteColor,
          elevation: 1,
          centerTitle: true,
          title: Text(
            'subscription_management'.tr,
            style: getMediumStyle(
              fontSize:
                  ResponsiveHelper.responsiveFontSize(FontSizeManager.s16),
              color: ColorsManager.blackColor,
            ),
          ),
          leading: IconButton(
            icon: Icon(
              isArabic ? Icons.arrow_back : Icons.arrow_forward,
              color: ColorsManager.blackColor,
            ),
            onPressed: () => Get.back(),
          ),
          actions: [
            // Show skip button only when canSkip is true
            if (canSkip)
              TextButton(
                onPressed: () => Get.back(),
                child: Text(
                  'skip'.tr,
                  style: getMediumStyle(
                    fontSize: ResponsiveHelper.responsiveFontSize(
                        FontSizeManager.s14),
                    color: ColorsManager.mainColor,
                  ),
                ),
              ),
          ],
        ),
        body: ResponsiveContainer(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.responsiveHorizontalPadding(context),
          ),
          child: RefreshIndicator(
            onRefresh: () async {
              await controller.loadPlans();
              await controller.loadStatus();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ResponsiveSpacing(
                    mobileHeight: 20,
                    tabletHeight: 25,
                    desktopHeight: 30,
                  ),
                  _buildCurrentSubscriptionStatus(context, isArabic),
                  ResponsiveSpacing(
                    mobileHeight: 20,
                    tabletHeight: 25,
                    desktopHeight: 30,
                  ),
                  _buildSectionTitle(context, 'subscription_plans'.tr),
                  ResponsiveSpacing(
                    mobileHeight: 15,
                    tabletHeight: 20,
                    desktopHeight: 25,
                  ),
                  _buildPlansList(context, isArabic),
                  ResponsiveSpacing(
                    mobileHeight: 30,
                    tabletHeight: 40,
                    desktopHeight: 50,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentSubscriptionStatus(BuildContext context, bool isArabic) {
    return Obx(() {
      final status = controller.status.value;

      if (controller.isLoadingStatus.value) {
        return const SizedBox.shrink();
      }

      if (status == null || !status.hasActiveSubscription) {
        return Container(
          padding: const EdgeInsets.all(AppPadding.p16),
          decoration: BoxDecoration(
            color: ColorsManager.whiteColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: ColorsManager.borderColor),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                color: ColorsManager.warningStyleColor,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'no_active_subscription'.tr,
                  style: getRegularStyle(
                    fontSize: ResponsiveHelper.responsiveFontSize(
                        FontSizeManager.s14),
                    color: ColorsManager.fontColor,
                  ),
                ),
              ),
            ],
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (status.isExpiringSoon) ...[
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(AppPadding.p12),
              decoration: BoxDecoration(
                color: ColorsManager.warningStyleColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: ColorsManager.warningStyleColor),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: ColorsManager.warningStyleColor,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'expiring_soon_banner'.tr,
                      style: getSemiBoldStyle(
                        fontSize: ResponsiveHelper.responsiveFontSize(
                            FontSizeManager.s14),
                        color: ColorsManager.warningStyleColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          Container(
            padding: const EdgeInsets.all(AppPadding.p16),
            decoration: BoxDecoration(
              color: ColorsManager.mainColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: ColorsManager.mainColor.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: ColorsManager.mainColor,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'active_subscription'.tr,
                        style: getSemiBoldStyle(
                          fontSize: ResponsiveHelper.responsiveFontSize(
                              FontSizeManager.s15),
                          color: ColorsManager.mainColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  status.getPlanName(isArabic ? 'ar' : 'en'),
                  style: getMediumStyle(
                    fontSize:
                        ResponsiveHelper.responsiveFontSize(FontSizeManager.s14),
                    color: ColorsManager.fontColor,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (status.daysRemaining != null) ...[
                      Text(
                        '${status.daysRemaining} ${'days_remaining'.tr}',
                        style: getRegularStyle(
                          fontSize: ResponsiveHelper.responsiveFontSize(
                              FontSizeManager.s12),
                          color: ColorsManager.hintStyleColor,
                        ),
                      ),
                    ],
                    if (status.endDate != null) ...[
                      Text(
                        '${'expires_on'.tr}: ${_formatDate(status.endDate!)}',
                        style: getRegularStyle(
                          fontSize: ResponsiveHelper.responsiveFontSize(
                              FontSizeManager.s12),
                          color: ColorsManager.hintStyleColor,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: getSemiBoldStyle(
        fontSize: ResponsiveHelper.responsiveFontSize(FontSizeManager.s16),
        color: ColorsManager.blackColor,
      ),
    );
  }

  Widget _buildPlansList(BuildContext context, bool isArabic) {
    return Obx(() {
      if (controller.isLoadingPlans.value) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(AppPadding.p40),
            child: CircularProgressIndicator(
              color: ColorsManager.mainColor,
            ),
          ),
        );
      }

      if (controller.plans.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(AppPadding.p40),
            child: Text(
              'no_plans_available'.tr,
              style: getRegularStyle(
                fontSize:
                    ResponsiveHelper.responsiveFontSize(FontSizeManager.s14),
                color: ColorsManager.hintStyleColor,
              ),
            ),
          ),
        );
      }

      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.plans.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final plan = controller.plans[index];
          return _buildPlanCard(context, plan, isArabic);
        },
      );
    });
  }

  Widget _buildPlanCard(BuildContext context, dynamic plan, bool isArabic) {
    final locale = isArabic ? 'ar' : 'en';

    return Container(
      decoration: BoxDecoration(
        color: ColorsManager.whiteColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: ColorsManager.shadowColor,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    plan.getName(locale),
                    style: getSemiBoldStyle(
                      fontSize: ResponsiveHelper.responsiveFontSize(
                          FontSizeManager.s16),
                      color: ColorsManager.blackColor,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: ColorsManager.mainColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'SDG ${NumberFormat('#,###').format(plan.price.toInt())}',
                    style: getSemiBoldStyle(
                      fontSize: ResponsiveHelper.responsiveFontSize(
                          FontSizeManager.s14),
                      color: ColorsManager.mainColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              plan.getDescription(locale),
              style: getRegularStyle(
                fontSize:
                    ResponsiveHelper.responsiveFontSize(FontSizeManager.s13),
                color: ColorsManager.hintStyleColor,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: ColorsManager.hintStyleColor,
                ),
                const SizedBox(width: 8),
                Text(
                  '${plan.durationDays} ${'days'.tr}',
                  style: getRegularStyle(
                    fontSize: ResponsiveHelper.responsiveFontSize(
                        FontSizeManager.s12),
                    color: ColorsManager.hintStyleColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _showPaymentMethodSelector(context, plan.planId),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsManager.mainColor,
                  foregroundColor: ColorsManager.whiteColor,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'subscribe'.tr,
                  style: getMediumStyle(
                    fontSize: ResponsiveHelper.responsiveFontSize(
                        FontSizeManager.s14),
                    color: ColorsManager.whiteColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPaymentMethodSelector(BuildContext context, int planId) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: ColorsManager.whiteColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'choose_payment_method'.tr,
              style: getBoldStyle(
                fontSize: FontSizeManager.s18,
                color: ColorsManager.blackColor,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: Image.asset(ImagesManager.bravoLogo, width: 40, height: 40),
              title: Text('Bravo Pay', style: getMediumStyle(fontSize: FontSizeManager.s16, color: ColorsManager.fontColor)),
              onTap: () {
                Get.back();
                _handleSubscribe(context, planId, 'yallapay');
              },
            ),
            const Divider(),
            ListTile(
              leading: Image.asset(ImagesManager.cashiLogo, width: 40, height: 40),
              title: Text('MyCashi Pay', style: getMediumStyle(fontSize: FontSizeManager.s16, color: ColorsManager.fontColor)),
              onTap: () {
                Get.back();
                controller.cashiPaymentMethod.value = 'reference';
                controller.isOtpInitiated.value = false;
                controller.walletNumber.value = '';
                controller.otpCode.value = '';
                controller.selectedPlanId.value = planId;
                _handleSubscribe(context, planId, 'cashipay');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handleSubscribe(BuildContext context, int planId, String paymentGateway) async {
    final result = await controller.initiatePayment(planId, paymentGateway);

    if (result != null && result.success) {
      if (paymentGateway == 'cashipay') {
        Get.to(() => const CashiPayPaymentView());
      } else {
        final paymentResult = await Get.to<Map<String, dynamic>>(
          () => PaymentWebViewView(
            paymentUrl: result.paymentUrl,
            clientReferenceId: result.clientReferenceId,
          ),
        );

        if (paymentResult != null && paymentResult['success'] == true) {
          await Future.wait([
            controller.loadStatus(),
            controller.loadPlans(),
          ]);
          Get.snackbar(
            'success'.tr,
            'subscription_activated'.tr,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: ColorsManager.successStyleColor,
            colorText: ColorsManager.whiteColor,
            duration: const Duration(seconds: 3),
          );
        }
      }
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
