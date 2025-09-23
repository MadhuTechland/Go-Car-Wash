class SubscriptionModel {
  final int id;
  final String planName;
  final int price;
  final String duration;
  final String tag;
  final int tax;
  final double tax_amount;
  final double total_amount;
  final List<String> subscriptionPoints;

  SubscriptionModel(
      {required this.id,
      required this.planName,
      required this.price,
      required this.duration,
      required this.tag,
      required this.subscriptionPoints,
      required this.tax,
      required this.tax_amount,
      required this.total_amount});

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      id: json['id'],
      planName: json['plan_name'],
      price: json['price'],
      duration: json['duration'],
      tag: json['tag'],
      tax: json['tax'],
      tax_amount: (json['tax_amount'] as num).toDouble(),
      total_amount: (json['total_amount'] as num).toDouble(),
      subscriptionPoints: List<String>.from(json['subscription_points']),
    );
  }
}
