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

  // CashiPay specific fields
  final String paymentGateway;
  final String? paymentFlow;
  final String? providerReference;
  final String? displayReference;
  final String? status;
  final String? expiresAt;
  final String? qrCodeDataUrl;
  final String? qrCodeContent;

  SubscriptionPaymentInitModel({
    required this.success,
    required this.paymentUrl,
    required this.clientReferenceId,
    required this.amount,
    required this.currency,
    required this.planName,
    required this.message,
    this.instructions,
    this.paymentGateway = '',
    this.paymentFlow,
    this.providerReference,
    this.displayReference,
    this.status,
    this.expiresAt,
    this.qrCodeDataUrl,
    this.qrCodeContent,
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
      paymentGateway: json['payment_gateway'] as String? ?? '',
      paymentFlow: json['payment_flow'] as String?,
      providerReference: json['provider_reference'] as String?,
      displayReference: json['display_reference'] as String?,
      status: json['status'] as String?,
      expiresAt: json['expires_at'] as String?,
      qrCodeDataUrl: json['qr_code_data_url'] as String?,
      qrCodeContent: json['qr_code_content'] as String?,
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
      'payment_gateway': paymentGateway,
      'payment_flow': paymentFlow,
      'provider_reference': providerReference,
      'display_reference': displayReference,
      'status': status,
      'expires_at': expiresAt,
      'qr_code_data_url': qrCodeDataUrl,
      'qr_code_content': qrCodeContent,
    };
  }
}
