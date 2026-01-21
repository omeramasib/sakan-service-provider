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

    // Safely handle potential non-String types (like List from validation errors)
    if (json['longitude'] is List) {
      longitude = (json['longitude'] as List).first?.toString();
    } else {
      longitude = json['longitude']?.toString();
    }

    if (json['latitude'] is List) {
      latitude = (json['latitude'] as List).first?.toString();
    } else {
      latitude = json['latitude']?.toString();
    }

    if (json['address'] is List) {
      address = (json['address'] as List).first?.toString();
    } else {
      address = json['address']?.toString();
    }

    if (json['additional_address'] is List) {
      additionalAddress =
          (json['additional_address'] as List).first?.toString();
    } else {
      additionalAddress = json['additional_address']?.toString();
    }
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
