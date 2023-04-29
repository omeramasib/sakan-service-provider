class AddRoomModel {
  int roomId;
  int roomNumber;
  String roomImage;
  String roomType;
  bool dailyBooking;
  bool monthlyBooking;
  double pricePerMonth;
  double pricePerDay;
  int numberOfBeds;
  int numAvailableBeds;
  int dakliaId;

  AddRoomModel({
    required this.roomId,
    required this.roomNumber,
    required this.roomImage,
    required this.roomType,
    required this.dailyBooking,
    required this.monthlyBooking,
    required this.pricePerMonth,
    required this.pricePerDay,
    required this.numberOfBeds,
    required this.numAvailableBeds,
    required this.dakliaId,
  });

factory AddRoomModel.fromJson(Map<String, dynamic> json) {
  return AddRoomModel(
    roomId: json['room_id'] ?? 0,
    roomNumber: json['room_number'] ?? 0,
    roomImage: json['room_image'] ?? '',
    roomType: json['room_type'] ?? '',
    dailyBooking: json['daily_booking'] ?? false,
    monthlyBooking: json['monthly_booking'] ?? false,
    pricePerMonth: json['price_per_month'].toDouble() ?? 0,
    pricePerDay: json['price_per_day'].toDouble() ?? 0.0,
    numberOfBeds: json['numberOfBeds'] as int,
    numAvailableBeds: json['num_Available_Beds'] as int ,
    dakliaId: json['daklia_id'],
  );
}
}
