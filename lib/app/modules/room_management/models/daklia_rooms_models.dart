class DakliaRoomModel {
  int? roomId;
  int? roomNumber;
  String? roomImage;
  String? roomType;
  int? roomPrice;
  String? bookingType;
  int? pricePerMonth;
  int? pricePerDay;
  int? numberOfBeds;
  int? numAvailableBeds;
  int? dakliaId;

  DakliaRoomModel(
      {this.roomId,
      this.roomNumber,
      this.roomImage,
      this.roomType,
      this.roomPrice,
      this.bookingType,
      this.pricePerMonth,
      this.pricePerDay,
      this.numberOfBeds,
      this.numAvailableBeds,
      this.dakliaId});

  DakliaRoomModel.fromJson(Map<String, dynamic> json) {
    roomId = json['room_id'] ?? 0;
    roomNumber = json['room_number'] ?? 0;
    roomImage = json['room_image'] ?? '';
    roomType = json['room_type'] ?? '';
    roomPrice = json['room_price'] ?? 0;
    bookingType = json['booking_type'] ?? '';
    pricePerMonth = json['price_per_month'] ?? 0;
    pricePerDay = json['price_per_day'] ?? 0;
    numberOfBeds = json['numberOfBeds'] ?? 0;
    numAvailableBeds = json['num_Available_Beds'] ?? 0;
    dakliaId = json['daklia_id'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['room_id'] = this.roomId;
    data['room_number'] = this.roomNumber;
    data['room_image'] = this.roomImage;
    data['room_type'] = this.roomType;
    data['room_price'] = this.roomPrice;
    data['booking_type'] = this.bookingType;
    data['price_per_month'] = this.pricePerMonth;
    data['price_per_day'] = this.pricePerDay;
    data['numberOfBeds'] = this.numberOfBeds;
    data['num_Available_Beds'] = this.numAvailableBeds;
    data['daklia_id'] = this.dakliaId;
    return data;
  }
}