class AddRoomModel {
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

  AddRoomModel({
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

factory AddRoomModel.fromJson(Map<String, dynamic> json) {
  return AddRoomModel(
    roomId: json['room_id'],
    roomNumber: json['room_number'],
    roomImage: json['room_image'],
    roomType: json['room_type'],
    roomPrice: json['room_price'].toDouble(),
    bookingType: json['booking_type'],
    pricePerMonth: json['price_per_month'].toDouble(),
    pricePerDay: json['price_per_day'].toDouble(),
    numberOfBeds: json['numberOfBeds'] as int,
    numAvailableBeds: json['num_Available_Beds'] as int,
    dakliaId: json['daklia_id'],
  );
}
}