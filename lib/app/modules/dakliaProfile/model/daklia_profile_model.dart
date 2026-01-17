import 'package:sakan/constants/flavor_config.dart';

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
  int? userId;
  int? locationId;
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
      this.userId,
      this.locationId,
      this.longitude,
      this.latitude});

  DakliaProfileModel.fromJson(Map<String, dynamic> json) {
    dakliaId = json['Daklia_id'];
    dakliaName = json['daklia_name'];
    dakliaImage = json['daklia_image'];
    dakliaDescription = json['daklia_description'];
    numberOfRooms = json['numberOfRooms'];
    accountStatus = json['account_status'];
    roomCount = json['room_count'];
    serviceCount = json['service_count'];
    lawCount = json['law_count'];
    userId = json['user_id'];
    locationId = json['location_id'];

    // Handle longitude and latitude type conversion (double to String)
    longitude = json['longitude']?.toString();
    latitude = json['latitude']?.toString();
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
    data['user_id'] = this.userId;
    data['location_id'] = this.locationId;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    return data;
  }

  String? get fullDakliaImage {
    if (dakliaImage == null) return null;
    if (dakliaImage!.startsWith('http')) return dakliaImage;

    String base = FlavorConfig.instance.baseUrl;
    if (base.endsWith('/') && dakliaImage!.startsWith('/')) {
      return base + dakliaImage!.substring(1);
    }
    if (!base.endsWith('/') && !dakliaImage!.startsWith('/')) {
      return '$base/$dakliaImage';
    }
    return '$base$dakliaImage';
  }
}
