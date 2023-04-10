class ChangeLocationModel {
  int? userId;
  int? locationId;
  String? longitude;
  String? latitude;
  String? address;
  String? additionalAddress;

  ChangeLocationModel(
      {this.userId,
      this.locationId,
      this.longitude,
      this.latitude,
      this.address,
      this.additionalAddress});

  ChangeLocationModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    locationId = json['location_id'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    address = json['address'];
    additionalAddress = json['additional_address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['location_id'] = this.locationId;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['address'] = this.address;
    data['additional_address'] = this.additionalAddress;
    return data;
  }
}