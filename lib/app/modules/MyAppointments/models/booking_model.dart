class RoomImage {
  final int? imageId;
  final int? room;
  final String? image;
  final String? imageUrl;
  final String? caption;
  final int? order;
  final String? uploadedAt;

  RoomImage({
    this.imageId,
    this.room,
    this.image,
    this.imageUrl,
    this.caption,
    this.order,
    this.uploadedAt,
  });

  factory RoomImage.fromJson(Map<String, dynamic> json) {
    return RoomImage(
      imageId: json['image_id'],
      room: json['room'],
      image: json['image'],
      imageUrl: json['image_url'],
      caption: json['caption'],
      order: json['order'],
      uploadedAt: json['uploaded_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image_id': imageId,
      'room': room,
      'image': image,
      'image_url': imageUrl,
      'caption': caption,
      'order': order,
      'uploaded_at': uploadedAt,
    };
  }
}

class BookingModel {
  final int? bookingId;
  final int? roomId;
  final int? studentId;
  final int? employeeId;
  final int? dakliaId;
  final int? discountId;
  final String? startDate;
  final String? endDate;
  final double? totalPrice;
  final int? bedsBooked;
  final String? bookingStatus;
  final String? transactionId;
  final String? bookingTime;
  final String? invoiceReceipt;
  final bool? paymentStatus;
  final bool? cancelStatus;
  final String? rejectionReason;
  final String? adminNotes;
  final String? cancelDate;
  final String? customerName;
  final String? customerType;
  final String? dakliaName;
  final int? roomNumber;
  final List<RoomImage>? roomImages;
  final bool? isStudent;
  final bool? isEmployee;
  final bool? dailyBooking;
  final bool? monthlyBooking;
  final String? adminActionDate;
  final String? ownerActionDate;
  final String? ownerRejectionReason;
  final int? adminActionBy;
  final String? customerPhone;

  BookingModel({
    this.bookingId,
    this.roomId,
    this.studentId,
    this.employeeId,
    this.dakliaId,
    this.discountId,
    this.startDate,
    this.endDate,
    this.totalPrice,
    this.bedsBooked,
    this.bookingStatus,
    this.transactionId,
    this.bookingTime,
    this.invoiceReceipt,
    this.paymentStatus,
    this.cancelStatus,
    this.rejectionReason,
    this.adminNotes,
    this.cancelDate,
    this.customerName,
    this.customerType,
    this.dakliaName,
    this.roomNumber,
    this.roomImages,
    this.isStudent,
    this.isEmployee,
    this.dailyBooking,
    this.monthlyBooking,
    this.adminActionDate,
    this.ownerActionDate,
    this.ownerRejectionReason,
    this.adminActionBy,
    this.customerPhone,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    List<RoomImage>? images;
    if (json['room_images'] != null && json['room_images'] is List) {
      images = (json['room_images'] as List)
          .map((img) => RoomImage.fromJson(img))
          .toList();
    }

    return BookingModel(
      bookingId: json['booking_id'],
      roomId: json['room_id'],
      studentId: json['student_id'],
      employeeId: json['employee_id'],
      dakliaId: json['daklia_id'],
      discountId: json['discount_id'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      totalPrice: json['total_price'] != null
          ? double.tryParse(json['total_price'].toString())
          : null,
      bedsBooked: json['beds_booked'],
      bookingStatus: json['booking_status'],
      transactionId: json['transaction_id'],
      bookingTime: json['booking_time'],
      invoiceReceipt: json['invoice_receipt'],
      paymentStatus: json['payment_status'],
      cancelStatus: json['cancel_status'],
      rejectionReason: json['rejection_reason'],
      adminNotes: json['admin_notes'],
      cancelDate: json['cancel_date'],
      customerName: json['customer_name'],
      customerType: json['customer_type'],
      dakliaName: json['daklia_name'],
      roomNumber: json['room_number'],
      roomImages: images,
      isStudent: json['is_student'],
      isEmployee: json['is_employee'],
      dailyBooking: json['daily_booking'],
      monthlyBooking: json['monthly_booking'],
      adminActionDate: json['admin_action_date'],
      ownerActionDate: json['owner_action_date'],
      ownerRejectionReason: json['owner_rejection_reason'],
      adminActionBy: json['admin_action_by'],
      customerPhone: json['customer_phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'booking_id': bookingId,
      'room_id': roomId,
      'student_id': studentId,
      'employee_id': employeeId,
      'daklia_id': dakliaId,
      'discount_id': discountId,
      'start_date': startDate,
      'end_date': endDate,
      'total_price': totalPrice,
      'beds_booked': bedsBooked,
      'booking_status': bookingStatus,
      'transaction_id': transactionId,
      'booking_time': bookingTime,
      'invoice_receipt': invoiceReceipt,
      'payment_status': paymentStatus,
      'cancel_status': cancelStatus,
      'rejection_reason': rejectionReason,
      'admin_notes': adminNotes,
      'cancel_date': cancelDate,
      'customer_name': customerName,
      'customer_type': customerType,
      'daklia_name': dakliaName,
      'room_number': roomNumber,
      'room_images': roomImages?.map((img) => img.toJson()).toList(),
      'is_student': isStudent,
      'is_employee': isEmployee,
      'daily_booking': dailyBooking,
      'monthly_booking': monthlyBooking,
      'admin_action_date': adminActionDate,
      'owner_action_date': ownerActionDate,
      'owner_rejection_reason': ownerRejectionReason,
      'admin_action_by': adminActionBy,
      'customer_phone': customerPhone,
    };
  }

  // Get the first room image URL
  String? get firstRoomImageUrl {
    if (roomImages != null && roomImages!.isNotEmpty) {
      return roomImages!.first.imageUrl ?? roomImages!.first.image;
    }
    return null;
  }

  // Check if booking is pending
  bool get isPending => bookingStatus == 'pending';

  // Check if booking is approved
  bool get isApproved => bookingStatus == 'approved';

  // Check if booking is rejected
  bool get isRejected => bookingStatus == 'rejected';

  // Check if booking is cancelled
  bool get isCancelled => bookingStatus == 'cancelled';

  // Get formatted customer phone text (replaces 249 with 0)
  String? get formattedCustomerPhone {
    if (customerPhone == null) return null;
    if (customerPhone!.startsWith('249')) {
      return '0${customerPhone!.substring(3)}';
    }
    return customerPhone;
  }
}
