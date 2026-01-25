/// Model representing the current subscription status of a Daklia.
class SubscriptionStatusModel {
  final bool hasActiveSubscription;
  final String? subscriptionType;
  final String? status;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? daysRemaining;
  final bool isExpiringSoon;
  final bool trialUsed;
  final bool canReceiveBookings;
  final String? planName;
  final String? planNameAr;
  final int? dakliaId;
  final String? dakliaName;
  final bool? dakliaIsActive;

  SubscriptionStatusModel({
    required this.hasActiveSubscription,
    this.subscriptionType,
    this.status,
    this.startDate,
    this.endDate,
    this.daysRemaining,
    this.isExpiringSoon = false,
    this.trialUsed = false,
    this.canReceiveBookings = false,
    this.planName,
    this.planNameAr,
    this.dakliaId,
    this.dakliaName,
    this.dakliaIsActive,
  });

  factory SubscriptionStatusModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionStatusModel(
      hasActiveSubscription: json['has_active_subscription'] as bool? ?? false,
      subscriptionType: json['subscription_type'] as String?,
      status: json['status'] as String?,
      startDate: json['start_date'] != null
          ? DateTime.parse(json['start_date'] as String)
          : null,
      endDate: json['end_date'] != null
          ? DateTime.parse(json['end_date'] as String)
          : null,
      daysRemaining: json['days_remaining'] as int?,
      isExpiringSoon: json['is_expiring_soon'] as bool? ?? false,
      trialUsed: json['trial_used'] as bool? ?? false,
      canReceiveBookings: json['can_receive_bookings'] as bool? ?? false,
      planName: json['plan_name'] as String?,
      planNameAr: json['plan_name_ar'] as String?,
      dakliaId: json['daklia_id'] as int?,
      dakliaName: json['daklia_name'] as String?,
      dakliaIsActive: json['daklia_is_active'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'has_active_subscription': hasActiveSubscription,
      'subscription_type': subscriptionType,
      'status': status,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'days_remaining': daysRemaining,
      'is_expiring_soon': isExpiringSoon,
      'trial_used': trialUsed,
      'can_receive_bookings': canReceiveBookings,
      'plan_name': planName,
      'plan_name_ar': planNameAr,
      'daklia_id': dakliaId,
      'daklia_name': dakliaName,
      'daklia_is_active': dakliaIsActive,
    };
  }

  /// Get localized plan name based on language code.
  String getPlanName(String locale) =>
      locale == 'ar' ? (planNameAr ?? '') : (planName ?? '');

  /// Check if the user is on a free plan
  bool get isFreePlan =>
      subscriptionType?.toLowerCase() == 'free' ||
      planName?.toLowerCase() == 'free';
}
