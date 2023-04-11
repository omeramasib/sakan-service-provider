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
  int? roomId;
  int? roomNumber;
  String? roomImage;
  String? roomType;
  double? roomPrice;
  String? bookingType;
  double? pricePerMonth;
  double? pricePerDay;
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
    roomId = json['room_id'];
    roomNumber = json['room_number'];
    roomImage = json['room_image'];
    roomType = json['room_type'];
    roomPrice = json['room_price'];
    bookingType = json['booking_type'];
    pricePerMonth = json['price_per_month'];
    pricePerDay = json['price_per_day'];
    numberOfBeds = json['numberOfBeds'];
    numAvailableBeds = json['num_Available_Beds'];
    dakliaId = json['daklia_id'];
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
