import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../../data/providers/subscription_provider.dart';

class HomeController extends GetxController {
  final count = 0.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    // Check subscription status after home screen is ready
    _checkSubscriptionStatus();
  }

  @override
  void onClose() {
    super.onClose();
  }

  /// Check if user's subscription is expired
  /// If expired, redirect to subscription plans with skip option
  Future<void> _checkSubscriptionStatus() async {
    try {
      final provider = SubscriptionProvider.instance;
      final status = await provider.getStatus();

      // Detailed debug logging
      debugPrint('🔍 Subscription Status Check Results:');
      if (status != null) {
        debugPrint('   ✅ Status Loaded:');
        debugPrint('   - Active: ${status.hasActiveSubscription}');
        debugPrint('   - Free Plan: ${status.isFreePlan}');
        debugPrint('   - Type: ${status.subscriptionType}');
        debugPrint('   - Plan Name: ${status.planName}');
        debugPrint('   - Expiry: ${status.endDate}');

        // If subscription is NOT active and user is NOT on free plan
        // Redirect to subscription plans screen
        if (!status.hasActiveSubscription && !status.isFreePlan) {
          debugPrint(
              '⚠️  Redirecting to subscription page (expired/no subscription)');

          // Navigate and wait for user to return
          await Get.toNamed(
            Routes.SUBSCRIPTION_PLANS,
            arguments: {'canSkip': false},
          );

          // User returned from subscription page
          // Re-check status in case they subscribed
          debugPrint(
              '🔄 User returned from subscription page, re-checking status...');
          final updatedStatus = await provider.getStatus();

          if (updatedStatus != null && updatedStatus.hasActiveSubscription) {
            debugPrint('✅ Subscription now active! User can access app.');
          } else {
            debugPrint('⚠️  Subscription still not active.');
          }
        }
      } else {
        debugPrint('   ❌ Status is NULL (Check API or Internet)');
      }
    } catch (e) {
      // If check fails, allow user to continue
      // Don't block app access due to subscription check error
      debugPrint('Subscription check error: $e');
    }
  }

  void increment() => count.value++;
}
