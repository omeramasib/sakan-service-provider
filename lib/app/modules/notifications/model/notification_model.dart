class NotificationModel {
  final int? notificationId;
  final String? title;
  final String? body;
  final Map<String, dynamic>? data;
  final bool? isRead;
  final String? createdAt;
  final String? readAt;

  NotificationModel({
    this.notificationId,
    this.title,
    this.body,
    this.data,
    this.isRead,
    this.createdAt,
    this.readAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      notificationId: json['notification_id'],
      title: json['title'],
      body: json['body'],
      data: json['data'],
      isRead: json['is_read'],
      createdAt: json['created_at'],
      readAt: json['read_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notification_id': notificationId,
      'title': title,
      'body': body,
      'data': data,
      'is_read': isRead,
      'created_at': createdAt,
      'read_at': readAt,
    };
  }
}
