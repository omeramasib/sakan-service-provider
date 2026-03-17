class SubscriptionOtpConfirmModel {
  final bool success;
  final String? errorCode;
  final String? errorMessage;

  SubscriptionOtpConfirmModel({
    required this.success,
    this.errorCode,
    this.errorMessage,
  });

  factory SubscriptionOtpConfirmModel.fromJson(Map<String, dynamic> json) {
    bool isSuccess = json['success'] == true || json['status'] == 'success';
    String? code;
    String? message;

    if (json.containsKey('error') && json['error'] is Map) {
      final errorMap = json['error'] as Map;
      code = errorMap['code']?.toString();
      message = errorMap['message']?.toString();
    } else if (!isSuccess && json.containsKey('message')) {
      message = json['message']?.toString();
    }

    return SubscriptionOtpConfirmModel(
      success: isSuccess,
      errorCode: code,
      errorMessage: message,
    );
  }
}
