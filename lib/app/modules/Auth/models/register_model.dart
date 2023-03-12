class RegisterModel {
  String? message;
  String? username;
  String? phoneNumber;
  int? userType;
  bool? isActive;
  String? createdAt;
  String? updatedAt;
  String? token;

  RegisterModel(
      {this.message,
      this.username,
      this.phoneNumber,
      this.userType,
      this.isActive,
      this.createdAt,
      this.updatedAt,
      this.token});

  RegisterModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    username = json['username'];
    phoneNumber = json['phone_number'];
    userType = json['user_type'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['username'] = this.username;
    data['phone_number'] = this.phoneNumber;
    data['user_type'] = this.userType;
    data['is_active'] = this.isActive;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['token'] = this.token;
    return data;
  }
}
