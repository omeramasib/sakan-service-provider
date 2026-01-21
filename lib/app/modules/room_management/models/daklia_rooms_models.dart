class RoomImageModel {
  final int? imageId;
  final int? room;
  final String? image;
  final String? imageUrl;
  final String? caption;
  final int? order;
  final String? uploadedAt;

  RoomImageModel({
    this.imageId,
    this.room,
    this.image,
    this.imageUrl,
    this.caption,
    this.order,
    this.uploadedAt,
  });

  factory RoomImageModel.fromJson(Map<String, dynamic> json) {
    return RoomImageModel(
      imageId: json['image_id'],
      room: json['room'],
      image: json['image'],
      imageUrl: json['image_url'],
      caption: json['caption'],
      order: json['order'],
      uploadedAt: json['uploaded_at'],
    );
  }
}

class DakliaRoomModel {
  int? roomId;
  int? roomNumber;
  String? roomImage; // Legacy single image field
  List<RoomImageModel>? roomImages; // New list of images
  String? roomType;
  bool? dailyBooking;
  bool? monthlyBooking;
  double? pricePerMonth;
  double? pricePerDay;
  int? numberOfBeds;
  int? numAvailableBeds;
  int? dakliaId;

  DakliaRoomModel({
    this.roomId,
    this.roomNumber,
    this.roomImage,
    this.roomImages,
    this.roomType,
    this.dailyBooking,
    this.monthlyBooking,
    this.pricePerMonth,
    this.pricePerDay,
    this.numberOfBeds,
    this.numAvailableBeds,
    this.dakliaId,
  });

  // Helper getter to get the first image URL (prefers new format, falls back to legacy)
  String? get firstImageUrl {
    // Try new format first
    if (roomImages != null && roomImages!.isNotEmpty) {
      return roomImages!.first.imageUrl ?? roomImages!.first.image;
    }
    // Fall back to legacy format
    return roomImage;
  }

  factory DakliaRoomModel.fromJson(Map<String, dynamic> json) {
    // Parse room_images list if present
    List<RoomImageModel>? images;
    if (json['room_images'] != null && json['room_images'] is List) {
      images = (json['room_images'] as List)
          .map((img) => RoomImageModel.fromJson(img))
          .toList();
    }

    // Safely get room_image as String (it might come as int or null)
    String? roomImageValue;
    if (json['room_image'] != null) {
      roomImageValue = json['room_image'].toString();
    }

    return DakliaRoomModel(
      roomId: json['room_id'] is int
          ? json['room_id']
          : int.tryParse(json['room_id']?.toString() ?? '0') ?? 0,
      roomNumber: json['room_number'] is int
          ? json['room_number']
          : int.tryParse(json['room_number']?.toString() ?? '0') ?? 0,
      roomImage: roomImageValue,
      roomImages: images,
      roomType: json['room_type']?.toString() ?? '',
      dailyBooking: json['daily_booking'] ?? false,
      monthlyBooking: json['monthly_booking'] ?? false,
      pricePerMonth: json['price_per_month']?.toDouble() ?? 0.0,
      pricePerDay: json['price_per_day']?.toDouble() ?? 0.0,
      numberOfBeds: json['numberOfBeds'] is int
          ? json['numberOfBeds']
          : int.tryParse(json['numberOfBeds']?.toString() ?? '0') ?? 0,
      numAvailableBeds: json['num_Available_Beds'] is int
          ? json['num_Available_Beds']
          : int.tryParse(json['num_Available_Beds']?.toString() ?? '0') ?? 0,
      dakliaId: json['daklia_id'],
    );
  }
}
