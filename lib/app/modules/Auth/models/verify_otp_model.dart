class VerifyOtpModel {
  String? message;
  bool? isVerified;

  VerifyOtpModel({this.message, this.isVerified});

  VerifyOtpModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    isVerified = json['is_verified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['is_verified'] = this.isVerified;
    return data;
  }
}