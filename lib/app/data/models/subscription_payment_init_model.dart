/// Model representing the response from payment initiation.
class SubscriptionPaymentInitModel {
  final bool success;
  final String paymentUrl;
  final String clientReferenceId;
  final double amount;
  final String currency;
  final String planName;
  final String message;
  final String? instructions;

  SubscriptionPaymentInitModel({
    required this.success,
    required this.paymentUrl,
    required this.clientReferenceId,
    required this.amount,
    required this.currency,
    required this.planName,
    required this.message,
    this.instructions,
  });

  factory SubscriptionPaymentInitModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionPaymentInitModel(
      success: json['success'] as bool? ?? false,
      paymentUrl: json['payment_url'] as String? ?? '',
      clientReferenceId: json['client_reference_id'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] as String? ?? 'SDG',
      planName: json['plan_name'] as String? ?? '',
      message: json['message'] as String? ?? '',
      instructions: json['instructions'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'payment_url': paymentUrl,
      'client_reference_id': clientReferenceId,
      'amount': amount,
      'currency': currency,
      'plan_name': planName,
      'message': message,
      'instructions': instructions,
    };
  }
}
