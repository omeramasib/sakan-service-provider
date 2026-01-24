class DakliaLocationModel {
  int? userId;
  int? locationId;
  String? longitude;
  String? latitude;
  String? additionalAddress;

  DakliaLocationModel(
      {this.userId,
      this.locationId,
      this.longitude,
      this.latitude,
      this.additionalAddress});

  DakliaLocationModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    locationId = json['location_id'];

    // Handle longitude and latitude type conversion (double to String)
    longitude = json['longitude']?.toString();
    latitude = json['latitude']?.toString();

    additionalAddress = json['additional_address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['location_id'] = this.locationId;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['additional_address'] = this.additionalAddress;
    return data;
  }
}