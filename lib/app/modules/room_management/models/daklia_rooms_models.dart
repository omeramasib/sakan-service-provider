// // To parse this JSON data, do
// //
// //     final dakliaRoomModel = dakliaRoomModelFromJson(jsonString);

// import 'dart:convert';

// List<DakliaRoomModel> dakliaRoomModelFromJson(String str) =>
//     List<DakliaRoomModel>.from(
//         json.decode(str).map((x) => DakliaRoomModel.fromJson(x)));

// String dakliaRoomModelToJson(List<DakliaRoomModel> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

// class DakliaRoomModel {
//   DakliaRoomModel({
//     required this.roomId,
//     required this.roomNumber,
//     required this.roomImage,
//     required this.roomType,
//     required this.roomPrice,
//     required this.bookingType,
//     required this.pricePerMonth,
//     required this.pricePerDay,
//     required this.numberOfBeds,
//     required this.numAvailableBeds,
//     required this.dakliaId,
//   });

//   int roomId;
//   int roomNumber;
//   String roomImage;
//   String roomType;
//   int roomPrice;
//   String bookingType;
//   int pricePerMonth;
//   int pricePerDay;
//   int numberOfBeds;
//   int numAvailableBeds;
//   int dakliaId;

//   factory DakliaRoomModel.fromJson(Map<String, dynamic> json) =>
//       DakliaRoomModel(
//         roomId: json["room_id"],
//         roomNumber: json["room_number"],
//         roomImage: json["room_image"],
//         roomType: json["room_type"],
//         roomPrice: json["room_price"].toInt(),
//         bookingType: json["booking_type"],
//         pricePerMonth: json["price_per_month"].toInt(),
//         pricePerDay: json["price_per_day"].toInt(),
//         numberOfBeds: json["numberOfBeds"],
//         numAvailableBeds: json["num_Available_Beds"],
//         dakliaId: json["daklia_id"],
//       );

//   Map<String, dynamic> toJson() => {
//         "room_id": roomId,
//         "room_number": roomNumber,
//         "room_image": roomImage,
//         "room_type": roomType,
//         "room_price": roomPrice,
//         "booking_type": bookingType,
//         "price_per_month": pricePerMonth,
//         "price_per_day": pricePerDay,
//         "numberOfBeds": numberOfBeds,
//         "num_Available_Beds": numAvailableBeds,
//         "daklia_id": dakliaId,
//       };
// }

// import 'dart:convert';

// List<DakliaRoomModel> dakliaRoomModelFromJson(String str) =>
//     List<DakliaRoomModel>.from(
//       json.decode(str).map(
//             (x) => DakliaRoomModel.fromJson(x),
//           ),
//     );

// String dakliaRoomModelToJson(List<DakliaRoomModel> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
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


