class RegisterModel {
  String? message;
  int? id;
  String? username;
  String? phoneNumber;
  int? userType;
  bool? isActive;
  String? createdAt;
  String? updatedAt;
  String? token;
  String? otp;

  RegisterModel(
      {this.message,
      this.id,
      this.username,
      this.phoneNumber,
      this.userType,
      this.isActive,
      this.createdAt,
      this.updatedAt,
      this.token,
      this.otp});

  RegisterModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    id = json['id'];
    username = json['username'];
    phoneNumber = json['phone_number'];
    userType = json['user_type'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    token = json['token'];
    otp = json['otp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['id'] = this.id;
    data['username'] = this.username;
    data['phone_number'] = this.phoneNumber;
    data['user_type'] = this.userType;
    data['is_active'] = this.isActive;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['token'] = this.token;
    data['otp'] = this.otp;
    return data;
  }
}