import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../../data/models/subscription_plan_model.dart';
import '../../../data/models/subscription_status_model.dart';
import '../../../data/models/subscription_payment_init_model.dart';
import '../../../data/models/subscription_payment_verify_model.dart';
import '../../../data/models/subscription_history_model.dart';
import '../../../data/providers/subscription_provider.dart';
import '../../../../constants/dialogs.dart';
import '../../../../constants/colors_manager.dart';
import '../../../../constants/fonts_manager.dart';
import '../../../../constants/styles_manager.dart';

class SubscriptionController extends GetxController {
  final SubscriptionProvider _provider;

  SubscriptionController({SubscriptionProvider? provider})
      : _provider = provider ?? SubscriptionProvider.instance;

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

  // CashiPay Payment State
  final Rx<SubscriptionPaymentInitModel?> currentPayment = Rx<SubscriptionPaymentInitModel?>(null);
  final RxString cashiPaymentMethod = 'reference'.obs;
  final RxInt selectedPlanId = 0.obs;
  final RxString walletNumber = ''.obs;
  final RxBool isOtpInitiated = false.obs;
  final RxBool isPolling = false.obs;
  final RxInt pollCount = 0.obs;
  final RxString otpCode = ''.obs;
  final RxBool isConfirmingOtp = false.obs;
  final RxBool isOtpLocked = false.obs;
  Timer? _pollingTimer;
  static const int _maxPolls = 20;

  @override
  void onInit() {
    super.onInit();
    loadStatus();
    loadPlans();
  }

  @override
  void onClose() {
    cancelPolling();
    super.onClose();
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
      }
    } catch (e) {
      debugPrint('SubscriptionController: loadPlans error: $e');
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
  Future<SubscriptionPaymentInitModel?> initiatePayment(int planId, String paymentGateway, {bool? requiresOtp, String? walletAccountNumber}) async {
    try {
      EasyLoading.show(status: 'loading'.tr);
      final result = await _provider.initiatePayment(
        planId,
        paymentGateway: paymentGateway,
        requiresOtp: requiresOtp,
        walletAccountNumber: walletAccountNumber,
      );

      if (result != null && result.success) {
        currentPayment.value = result;
        if (requiresOtp == true) {
          isOtpInitiated.value = true;
          isOtpLocked.value = false;
        }
        debugPrint('SubscriptionController: Payment initiated - ${result.clientReferenceId}');
        return result;
      } else {
        if (Get.context != null) {
          Dialogs.errorDialog(Get.context!, 'failed_to_initiate_payment'.tr);
        }
        return null;
      }
    } catch (e) {
      debugPrint('SubscriptionController: initiatePayment error: $e');
      if (Get.context != null) {
        Dialogs.errorDialog(Get.context!, 'failed_to_initiate_payment'.tr);
      }
      return null;
    } finally {
      EasyLoading.dismiss();
    }
  }

  /// Confirm OTP for payment.
  Future<bool> confirmOtp(String clientReferenceId, String otp) async {
    if (isOtpLocked.value) return false;

    try {
      isConfirmingOtp.value = true;
      final result = await _provider.confirmOtp(clientReferenceId, otp);

      if (result != null && result.success) {
        // Start polling upon success
        startPolling(clientReferenceId);
        return true;
      } else {
        String errorMessage = 'failed_to_confirm_otp'.tr;

        if (result != null) {
          if (result.errorCode == 'otp_attempts_exceeded') {
            isOtpLocked.value = true;
            errorMessage = 'otp_attempts_exceeded'.tr;
          } else if (result.errorMessage != null && result.errorMessage!.isNotEmpty) {
            final backendMsg = result.errorMessage!.toLowerCase();
            if (result.errorCode == 'otp_confirmation_failed' && backendMsg.contains('locked')) {
              isOtpLocked.value = true;
              errorMessage = 'otp_locked_message'.tr;
            } else if (result.errorCode == 'otp_confirmation_failed') {
              final match = RegExp(r'(\d+)').firstMatch(result.errorMessage!);
              if (match != null) {
                final attempts = match.group(1);
                errorMessage = 'otp_attempts_remaining'.tr.replaceAll('@attempts', attempts!);
              } else {
                errorMessage = result.errorMessage!;
              }
            } else {
              errorMessage = result.errorMessage!;
            }
          }
        }

        _showErrorDialog(errorMessage);
        return false;
      }
    } catch (e) {
      debugPrint('SubscriptionController: confirmOtp error: $e');
      _showErrorDialog('failed_to_confirm_otp'.tr);
      return false;
    } finally {
      isConfirmingOtp.value = false;
    }
  }

  void _showErrorDialog(String message) {
    if (Get.context == null) return;
    if (Get.isDialogOpen == true) return;
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Row(
          children: [
            const Icon(Icons.error_outline, color: ColorsManager.errorColor),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'error'.tr,
                style: getBoldStyle(
                  color: ColorsManager.errorColor,
                  fontSize: FontSizeManager.s16,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: getRegularStyle(
            color: ColorsManager.fontColor,
            fontSize: FontSizeManager.s14,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'ok'.tr,
              style: getMediumStyle(
                color: ColorsManager.mainColor,
                fontSize: FontSizeManager.s14,
              ),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  /// Start polling for payment verification
  void startPolling(String clientReferenceId) {
    cancelPolling(); // Ensure no existing timer is running
    isPolling.value = true;
    pollCount.value = 0;

    _pollingTimer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      pollCount.value++;
      debugPrint('SubscriptionController: Polling payment status (attempt ${pollCount.value}/$_maxPolls)');

      final result = await verifyPayment(clientReferenceId, showLoading: false);

      if (result != null) {
        if (result.isCompleted && result.subscriptionActive) {
          // Payment successful
          cancelPolling();
          Get.offNamed('/payment-success');
        } else if (!result.isPending && !result.isCompleted) {
          // Another terminal state
          cancelPolling();
          if (Get.context != null) {
            Dialogs.errorDialog(Get.context!, 'payment_failed'.tr);
          }
        }
      }

      if (pollCount.value >= _maxPolls) {
        cancelPolling();
        Get.dialog(
          AlertDialog(
            title: Text('payment_timeout'.tr),
            content: Text('payment_timeout_message'.tr),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back(); // close dialog
                  Get.back(); // go back from payment screen
                },
                child: Text('ok'.tr),
              ),
            ],
          ),
          barrierDismissible: false,
        );
      }
    });
  }

  /// Cancel any active polling
  void cancelPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
    isPolling.value = false;
  }

  /// Verify payment status.
  Future<SubscriptionPaymentVerifyModel?> verifyPayment(String clientReferenceId, {bool showLoading = true}) async {
    try {
      if (showLoading) EasyLoading.show(status: 'loading'.tr);
      final result = await _provider.verifyPayment(clientReferenceId);

      if (result != null) {
        debugPrint('SubscriptionController: Payment verification - ${result.status}');
        if (result.isCompleted && result.subscriptionActive) {
          // Refresh status
          await loadStatus();
        }
        return result;
      } else {
        if (showLoading) {
          if (Get.context != null) {
            Dialogs.errorDialog(Get.context!, 'Failed to verify payment status');
          }
        }
        return null;
      }
    } catch (e) {
      debugPrint('SubscriptionController: verifyPayment error: $e');
      if (showLoading) {
        if (Get.context != null) {
          Dialogs.errorDialog(Get.context!, 'Failed to verify payment status');
        }
      }
      return null;
    } finally {
      if (showLoading) EasyLoading.dismiss();
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
