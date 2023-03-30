class DakliaProfileModel {
  int? dakliaId;
  String? dakliaImage;
  String? dakliaName;
  int? accountStatus;

  DakliaProfileModel(
      {this.dakliaId, this.dakliaImage, this.dakliaName, this.accountStatus});

  DakliaProfileModel.fromJson(Map<String, dynamic> json) {
    dakliaId = json['Daklia_id'];
    dakliaImage = json['daklia_image'];
    dakliaName = json['daklia_name'];
    accountStatus = json['account_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Daklia_id'] = this.dakliaId;
    data['daklia_image'] = this.dakliaImage;
    data['daklia_name'] = this.dakliaName;
    data['account_status'] = this.accountStatus;
    return data;
  }
}