import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sakan/constants/httpHelper.dart';
import '../../services/secure_storage_service.dart';
import '../models/subscription_plan_model.dart';
import '../models/subscription_status_model.dart';
import '../models/subscription_payment_init_model.dart';
import '../models/subscription_payment_verify_model.dart';
import '../models/subscription_history_model.dart';
import '../models/subscription_otp_confirm_model.dart';

/// Provider for subscription-related API calls.
///
/// Handles all subscription endpoints including plans, status, payment, and history.
class SubscriptionProvider extends GetConnect {
  static SubscriptionProvider get instance => Get.put(SubscriptionProvider());
  final SecureStorageService storage = SecureStorageService.instance;

  @override
  void onInit() {
    httpClient.baseUrl = HttpHelper.subscriptionBaseUrl;
    // Payment initiate calls the gateway; 3s caused null status/body (client timeout in GetConnect).
    httpClient.timeout = const Duration(seconds: 60);
    super.onInit();
  }

  /// Get authentication headers with token.
  Future<Map<String, String>> _getHeaders() async {
    String? token = await storage.read('token');
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Token $token',
    };
  }

  /// Fetch all available subscription plans.
  ///
  /// Endpoint: GET /api/v1/subscription/plans/
  Future<List<SubscriptionPlanModel>?> getPlans() async {
    try {
      final headers = await _getHeaders();
      final response = await get(
        HttpHelper.subscriptionPlans,
        headers: headers,
      );

      debugPrint('SubscriptionProvider: getPlans response');
      debugPrint('Status: ${response.statusCode}');
      debugPrint('Body: ${response.body}');

      if (response.statusCode == 200 && response.body != null) {
        final data = response.body as Map<String, dynamic>;
        final plansList = data['plans'] as List<dynamic>? ?? [];
        return plansList
            .map((plan) =>
                SubscriptionPlanModel.fromJson(plan as Map<String, dynamic>))
            .toList();
      }

      return null;
    } catch (e) {
      debugPrint('SubscriptionProvider: getPlans exception: $e');
      return null;
    }
  }

  /// Get current subscription status.
  ///
  /// Endpoint: GET /api/v1/subscription/status/
  Future<SubscriptionStatusModel?> getStatus() async {
    try {
      final headers = await _getHeaders();
      final response = await get(
        HttpHelper.subscriptionStatus,
        headers: headers,
      );

      debugPrint('SubscriptionProvider: getStatus response');
      debugPrint('Status: ${response.statusCode}');
      debugPrint('Body: ${response.body}');

      if (response.statusCode == 200 && response.body != null) {
        return SubscriptionStatusModel.fromJson(
            response.body as Map<String, dynamic>);
      }

      return null;
    } catch (e) {
      debugPrint('SubscriptionProvider: getStatus exception: $e');
      return null;
    }
  }

  /// Initiate payment for a subscription plan.
  ///
  /// Endpoint: POST /api/v1/subscription/payment/initiate/
  Future<SubscriptionPaymentInitModel?> initiatePayment(
    int planId, {
    String paymentGateway = 'cashipay',
    bool? requiresOtp,
    String? walletAccountNumber,
  }) async {
    try {
      final headers = await _getHeaders();
      final body = {
        'plan_id': planId,
        'payment_gateway': paymentGateway,
        if (requiresOtp != null) 'requires_otp': requiresOtp,
        if (walletAccountNumber != null) 'wallet_account_number': walletAccountNumber,
      };

      debugPrint('SubscriptionProvider: initiatePayment request');
      debugPrint('Body: $body');

      final response = await post(
        HttpHelper.subscriptionPaymentInitiate,
        body,
        headers: headers,
      );

      debugPrint('SubscriptionProvider: initiatePayment response');
      debugPrint('Status: ${response.statusCode}');
      debugPrint('StatusText: ${response.statusText}');
      debugPrint('Body: ${response.bodyString ?? response.body}');

      if (response.statusCode == null) {
        debugPrint(
            'SubscriptionProvider: initiatePayment failed (no HTTP status — likely timeout or network). '
            'See StatusText above.');
        return null;
      }

      final code = response.statusCode!;
      if (response.body is Map<String, dynamic>) {
        final model = SubscriptionPaymentInitModel.fromJson(
            response.body as Map<String, dynamic>);
        if (code >= 200 && code < 300) {
          return model;
        }
        debugPrint(
            'SubscriptionProvider: initiatePayment HTTP $code: ${response.body}');
        return model;
      }

      return null;
    } catch (e) {
      debugPrint('SubscriptionProvider: initiatePayment exception: $e');
      return null;
    }
  }

  /// Confirm OTP for payment.
  ///
  /// Endpoint: POST /api/v1/subscription/payment/confirm/
  Future<SubscriptionOtpConfirmModel?> confirmOtp(String clientReferenceId, String otp) async {
    try {
      final headers = await _getHeaders();
      final body = {
        'client_reference_id': clientReferenceId,
        'otp': otp,
      };

      debugPrint('SubscriptionProvider: confirmOtp request');
      debugPrint('Body: $body');

      final response = await post(
        HttpHelper.subscriptionPaymentConfirm,
        body,
        headers: headers,
      );

      debugPrint('SubscriptionProvider: confirmOtp response');
      debugPrint('Status: ${response.statusCode}');
      debugPrint('Body: ${response.bodyString ?? response.body}');

      if (response.body != null) {
        return SubscriptionOtpConfirmModel.fromJson(response.body as Map<String, dynamic>);
      }

      return null;
    } catch (e) {
      debugPrint('SubscriptionProvider: confirmOtp exception: $e');
      return null;
    }
  }

  /// Verify payment status after payment completion.
  ///
  /// Endpoint: GET /api/v1/subscription/payment/verify/?client_reference_id=...
  Future<SubscriptionPaymentVerifyModel?> verifyPayment(
      String clientReferenceId) async {
    try {
      final headers = await _getHeaders();
      final response = await get(
        '${HttpHelper.subscriptionPaymentVerify}?client_reference_id=$clientReferenceId',
        headers: headers,
      );

      debugPrint('SubscriptionProvider: verifyPayment response');
      debugPrint('Status: ${response.statusCode}');
      debugPrint('Body: ${response.body}');

      if (response.statusCode == 200 && response.body != null) {
        return SubscriptionPaymentVerifyModel.fromJson(
            response.body as Map<String, dynamic>);
      }

      return null;
    } catch (e) {
      debugPrint('SubscriptionProvider: verifyPayment exception: $e');
      return null;
    }
  }

  /// Get subscription history for the current Daklia.
  ///
  /// Endpoint: GET /api/v1/subscription/history/
  Future<SubscriptionHistoryModel?> getHistory() async {
    try {
      final headers = await _getHeaders();
      final response = await get(
        HttpHelper.subscriptionHistory,
        headers: headers,
      );

      debugPrint('SubscriptionProvider: getHistory response');
      debugPrint('Status: ${response.statusCode}');
      debugPrint('Body: ${response.body}');

      if (response.statusCode == 200 && response.body != null) {
        return SubscriptionHistoryModel.fromJson(
            response.body as Map<String, dynamic>);
      }

      return null;
    } catch (e) {
      debugPrint('SubscriptionProvider: getHistory exception: $e');
      return null;
    }
  }
}
