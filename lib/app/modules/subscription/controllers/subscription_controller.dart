import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../../data/models/subscription_plan_model.dart';
import '../../../data/models/subscription_status_model.dart';
import '../../../data/models/subscription_payment_init_model.dart';
import '../../../data/models/subscription_payment_verify_model.dart';
import '../../../data/models/subscription_history_model.dart';
import '../../../data/providers/subscription_provider.dart';

class SubscriptionController extends GetxController {
  final SubscriptionProvider _provider = SubscriptionProvider.instance;

  // Observable state
  final RxList<SubscriptionPlanModel> plans = <SubscriptionPlanModel>[].obs;
  final Rx<SubscriptionStatusModel?> status =
      Rx<SubscriptionStatusModel?>(null);
  final Rx<SubscriptionHistoryModel?> history =
      Rx<SubscriptionHistoryModel?>(null);
  final RxBool isLoadingPlans = false.obs;
  final RxBool isLoadingStatus = false.obs;
  final RxBool isLoadingHistory = false.obs;
  final RxString currency = 'SDG'.obs;

  @override
  void onInit() {
    super.onInit();
    loadStatus();
    loadPlans();
  }

  /// Load all available subscription plans.
  Future<void> loadPlans() async {
    try {
      isLoadingPlans.value = true;
      final result = await _provider.getPlans();

      if (result != null && result.isNotEmpty) {
        plans.value = result;
        if (result.isNotEmpty) {
          currency.value = result.first.currency;
        }
        debugPrint('SubscriptionController: Loaded ${result.length} plans');
      } else {
        Get.snackbar(
          'error'.tr,
          'Failed to load subscription plans',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      debugPrint('SubscriptionController: loadPlans error: $e');
      Get.snackbar(
        'error'.tr,
        'Failed to load subscription plans',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingPlans.value = false;
    }
  }

  /// Load current subscription status.
  Future<void> loadStatus() async {
    try {
      isLoadingStatus.value = true;
      final result = await _provider.getStatus();

      if (result != null) {
        status.value = result;
        debugPrint(
            'SubscriptionController: Loaded status - active: ${result.hasActiveSubscription}');
      }
    } catch (e) {
      debugPrint('SubscriptionController: loadStatus error: $e');
    } finally {
      isLoadingStatus.value = false;
    }
  }

  /// Initiate payment for a selected plan.
  Future<SubscriptionPaymentInitModel?> initiatePayment(int planId) async {
    try {
      EasyLoading.show(status: 'loading'.tr);
      final result = await _provider.initiatePayment(planId);

      if (result != null && result.success) {
        debugPrint(
            'SubscriptionController: Payment initiated - ${result.clientReferenceId}');
        return result;
      } else {
        Get.snackbar(
          'error'.tr,
          'Failed to initiate payment',
          snackPosition: SnackPosition.BOTTOM,
        );
        return null;
      }
    } catch (e) {
      debugPrint('SubscriptionController: initiatePayment error: $e');
      Get.snackbar(
        'error'.tr,
        'Failed to initiate payment',
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    } finally {
      EasyLoading.dismiss();
    }
  }

  /// Verify payment status after WebView completion.
  Future<SubscriptionPaymentVerifyModel?> verifyPayment(
      String clientReferenceId) async {
    try {
      EasyLoading.show(status: 'loading'.tr);
      final result = await _provider.verifyPayment(clientReferenceId);

      if (result != null) {
        debugPrint(
            'SubscriptionController: Payment verification - ${result.status}');
        if (result.isCompleted && result.subscriptionActive) {
          // Refresh status
          await loadStatus();
        }
        return result;
      } else {
        Get.snackbar(
          'error'.tr,
          'Failed to verify payment status',
          snackPosition: SnackPosition.BOTTOM,
        );
        return null;
      }
    } catch (e) {
      debugPrint('SubscriptionController: verifyPayment error: $e');
      Get.snackbar(
        'error'.tr,
        'Failed to verify payment status',
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    } finally {
      EasyLoading.dismiss();
    }
  }

  /// Load subscription history.
  Future<void> loadHistory() async {
    try {
      isLoadingHistory.value = true;
      final result = await _provider.getHistory();

      if (result != null) {
        history.value = result;
        debugPrint(
            'SubscriptionController: Loaded ${result.subscriptions.length} history items');
      }
    } catch (e) {
      debugPrint('SubscriptionController: loadHistory error: $e');
    } finally {
      isLoadingHistory.value = false;
    }
  }

  /// Check if subscription is required and show dialog if not active.
  ///
  /// Returns true if user has active subscription, false otherwise.
  Future<bool> checkSubscriptionRequired() async {
    await loadStatus();

    if (status.value?.hasActiveSubscription == false) {
      Get.dialog(
        AlertDialog(
          title: Text('subscription_required'.tr),
          content: Text('subscription_required_message'.tr),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text('cancel'.tr),
            ),
            ElevatedButton(
              onPressed: () {
                Get.back();
                Get.toNamed('/subscription-plans');
              },
              child: Text('subscribe_to_continue'.tr),
            ),
          ],
        ),
      );
      return false;
    }

    return true;
  }
}
