import 'subscription_status_model.dart';

/// Model representing the payment verification response.
class SubscriptionPaymentVerifyModel {
  final String status;
  final bool subscriptionActive;
  final String message;
  final SubscriptionStatusModel? subscription;

  SubscriptionPaymentVerifyModel({
    required this.status,
    required this.subscriptionActive,
    required this.message,
    this.subscription,
  });

  factory SubscriptionPaymentVerifyModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionPaymentVerifyModel(
      status: json['status'] as String? ?? 'unknown',
      subscriptionActive: json['subscription_active'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      subscription: json['subscription'] != null
          ? SubscriptionStatusModel.fromJson(
              json['subscription'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'subscription_active': subscriptionActive,
      'message': message,
      'subscription': subscription?.toJson(),
    };
  }

  /// Check if payment is completed.
  bool get isCompleted => status == 'completed';

  /// Check if payment is pending.
  bool get isPending => status == 'pending';
}
