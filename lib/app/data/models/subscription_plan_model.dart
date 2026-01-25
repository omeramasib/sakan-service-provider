/// Model representing a subscription plan.
///
/// Contains plan details including pricing, duration, and localized names.
class SubscriptionPlanModel {
  final int planId;
  final String code;
  final String name;
  final String nameAr;
  final int durationDays;
  final double price;
  final String currency;
  final String description;
  final String descriptionAr;

  SubscriptionPlanModel({
    required this.planId,
    required this.code,
    required this.name,
    required this.nameAr,
    required this.durationDays,
    required this.price,
    required this.currency,
    required this.description,
    required this.descriptionAr,
  });

  factory SubscriptionPlanModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlanModel(
      planId: json['plan_id'] as int,
      code: json['code'] as String,
      name: json['name'] as String,
      nameAr: json['name_ar'] as String? ?? '',
      durationDays: json['duration_days'] as int,
      price: double.parse(json['price'].toString()),
      currency: json['currency'] as String,
      description: json['description'] as String? ?? '',
      descriptionAr: json['description_ar'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'plan_id': planId,
      'code': code,
      'name': name,
      'name_ar': nameAr,
      'duration_days': durationDays,
      'price': price.toString(),
      'currency': currency,
      'description': description,
      'description_ar': descriptionAr,
    };
  }

  /// Get localized plan name based on language code.
  String getName(String locale) => locale == 'ar' ? nameAr : name;

  /// Get localized plan description based on language code.
  String getDescription(String locale) =>
      locale == 'ar' ? descriptionAr : description;
}
