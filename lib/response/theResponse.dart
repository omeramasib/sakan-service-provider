class TheResponse<T> {
  final int code;
  final String message;
  final T data;

  TheResponse({
    required this.code,
    required this.message,
    required this.data,
  });

  factory TheResponse.fromJson(Map<String, dynamic> json) {
    return TheResponse(
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      data: json['data'] ?? {},
    );
  }


}
