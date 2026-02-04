/// Model representing a single subscription history record.
class SubscriptionHistoryItemModel {
  final int subscriptionId;
  final String subscriptionType;
  final String status;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? planName;
  final String? planCode;
  final int daysRemaining;
  final String source;

  SubscriptionHistoryItemModel({
    required this.subscriptionId,
    required this.subscriptionType,
    required this.status,
    this.startDate,
    this.endDate,
    this.planName,
    this.planCode,
    this.daysRemaining = 0,
    required this.source,
  });

  factory SubscriptionHistoryItemModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionHistoryItemModel(
      subscriptionId: json['subscription_id'] as int,
      subscriptionType: json['subscription_type'] as String,
      status: json['status'] as String,
      startDate: json['start_date'] != null
          ? DateTime.parse(json['start_date'] as String)
          : null,
      endDate: json['end_date'] != null
          ? DateTime.parse(json['end_date'] as String)
          : null,
      planName: json['plan_name'] as String?,
      planCode: json['plan_code'] as String?,
      daysRemaining: json['days_remaining'] as int? ?? 0,
      source: json['source'] as String? ?? 'UNKNOWN',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subscription_id': subscriptionId,
      'subscription_type': subscriptionType,
      'status': status,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'plan_name': planName,
      'plan_code': planCode,
      'days_remaining': daysRemaining,
      'source': source,
    };
  }
}

/// Model representing the complete subscription history.
class SubscriptionHistoryModel {
  final List<SubscriptionHistoryItemModel> subscriptions;

  SubscriptionHistoryModel({
    required this.subscriptions,
  });

  factory SubscriptionHistoryModel.fromJson(Map<String, dynamic> json) {
    final subscriptionsList = json['subscriptions'] as List<dynamic>? ?? [];
    return SubscriptionHistoryModel(
      subscriptions: subscriptionsList
          .map((item) => SubscriptionHistoryItemModel.fromJson(
              item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subscriptions': subscriptions.map((s) => s.toJson()).toList(),
    };
  }
}
