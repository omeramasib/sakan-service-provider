class DakliaProfileModel {
  int? dakliaId;
  String? dakliaName;
  String? dakliaImage;
  String? dakliaDescription;
  int? numberOfRooms;
  int? accountStatus;
  int? roomCount;
  int? serviceCount;
  int? lawCount;
  String? longitude;
  String? latitude;

  DakliaProfileModel(
      {this.dakliaId,
      this.dakliaName,
      this.dakliaImage,
      this.dakliaDescription,
      this.numberOfRooms,
      this.accountStatus,
      this.roomCount,
      this.serviceCount,
      this.lawCount,
      this.longitude,
      this.latitude});

  DakliaProfileModel.fromJson(Map<String, dynamic> json) {
    dakliaId = json['Daklia_id'];
    dakliaName = json['daklia_name'];
    dakliaImage = json['daklia_image'] ?? '';
    dakliaDescription = json['daklia_description'] ?? '';
    numberOfRooms = json['numberOfRooms'] ?? 0;
    accountStatus = json['account_status'] ?? 0;
    roomCount = json['room_count'] ?? 0;
    serviceCount = json['service_count'] ?? 0;
    lawCount = json['law_count'] ?? 0;
    longitude = json['longitude'] ?? '';
    latitude = json['latitude'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Daklia_id'] = this.dakliaId;
    data['daklia_name'] = this.dakliaName;
    data['daklia_image'] = this.dakliaImage;
    data['daklia_description'] = this.dakliaDescription;
    data['numberOfRooms'] = this.numberOfRooms;
    data['account_status'] = this.accountStatus;
    data['room_count'] = this.roomCount;
    data['service_count'] = this.serviceCount;
    data['law_count'] = this.lawCount;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    return data;
  }
}