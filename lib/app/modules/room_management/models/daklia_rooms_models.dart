class DakliaRoomModel {
  int roomId;
  int roomNumber;
  String roomImage;
  String roomType;
  double roomPrice;
  String bookingType;
  double pricePerMonth;
  double pricePerDay;
  int numberOfBeds;
  int numAvailableBeds;
  int dakliaId;

  DakliaRoomModel({
    required this.roomId,
    required this.roomNumber,
    required this.roomImage,
    required this.roomType,
    required this.roomPrice,
    required this.bookingType,
    required this.pricePerMonth,
    required this.pricePerDay,
    required this.numberOfBeds,
    required this.numAvailableBeds,
    required this.dakliaId,
  });

factory DakliaRoomModel.fromJson(Map<String, dynamic> json) {
  return DakliaRoomModel(
    roomId: json['room_id'] ?? 0,
    roomNumber: json['room_number'] ?? 0,
    roomImage: json['room_image'] ?? '',
    roomType: json['room_type'] ?? '',
    roomPrice: json['room_price'].toDouble() ?? 0.0,
    bookingType: json['booking_type'] ?? '',
    pricePerMonth: json['price_per_month'].toDouble() ?? 0.0,
    pricePerDay: json['price_per_day'].toDouble() ?? 0.0,
    numberOfBeds: json['numberOfBeds'] as int ?? 0,
    numAvailableBeds: json['num_Available_Beds'] as int ?? 0,
    dakliaId: json['daklia_id'],
  );
}
}


