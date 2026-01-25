import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sakan/constants/httpHelper.dart';
import '../../services/secure_storage_service.dart';
import '../models/subscription_plan_model.dart';
import '../models/subscription_status_model.dart';
import '../models/subscription_payment_init_model.dart';
import '../models/subscription_payment_verify_model.dart';
import '../models/subscription_history_model.dart';

/// Provider for subscription-related API calls.
///
/// Handles all subscription endpoints including plans, status, payment, and history.
class SubscriptionProvider extends GetConnect {
  static SubscriptionProvider get instance => Get.put(SubscriptionProvider());
  final SecureStorageService storage = SecureStorageService.instance;

  @override
  void onInit() {
    httpClient.baseUrl = HttpHelper.subscriptionBaseUrl;
    httpClient.timeout = const Duration(seconds: 30);
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
  Future<SubscriptionPaymentInitModel?> initiatePayment(int planId) async {
    try {
      final headers = await _getHeaders();
      final response = await post(
        HttpHelper.subscriptionPaymentInitiate,
        {'plan_id': planId},
        headers: headers,
      );

      debugPrint('SubscriptionProvider: initiatePayment response');
      debugPrint('Status: ${response.statusCode}');
      debugPrint('Body: ${response.body}');

      if (response.statusCode == 200 && response.body != null) {
        return SubscriptionPaymentInitModel.fromJson(
            response.body as Map<String, dynamic>);
      }

      return null;
    } catch (e) {
      debugPrint('SubscriptionProvider: initiatePayment exception: $e');
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
