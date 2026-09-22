class ProductDealModel {
  final String? id;
  final String dealType;
  final String discountType;
  final double discountValue;
  final int remainingQuantity;
  final int availableQuantity;
  final DateTime? endsAt;

  const ProductDealModel({
    this.id,
    required this.dealType,
    required this.discountType,
    required this.discountValue,
    required this.remainingQuantity,
    required this.availableQuantity,
    this.endsAt,
  });

  factory ProductDealModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseUtc(dynamic value) {
      if (value == null) return null;
      final raw = value.toString();
      final hasTimezone = RegExp(
        r'(Z|[+-]\d{2}:?\d{2})$',
        caseSensitive: false,
      ).hasMatch(raw);
      return DateTime.tryParse(hasTimezone ? raw : '${raw}Z')?.toUtc();
    }

    double number(dynamic value) =>
        double.tryParse(value?.toString() ?? '') ?? 0;
    int integer(dynamic value) => int.tryParse(value?.toString() ?? '') ?? 0;
    return ProductDealModel(
      id: json['productDealId']?.toString(),
      dealType: json['dealType']?.toString() ?? 'FlashDeal',
      discountType: json['discountType']?.toString() ?? 'Percent',
      discountValue: number(json['discountValue']),
      remainingQuantity: integer(json['remainingQuantity']),
      availableQuantity: integer(json['availableQuantity']),
      endsAt: parseUtc(json['endsAt']),
    );
  }

  String get label =>
      dealType.toLowerCase() == 'localdeal' ? 'โปรเด็ดชุมชน' : 'โปรโมชันพิเศษ';
  bool get isExpired =>
      endsAt != null && !endsAt!.isAfter(DateTime.now().toUtc());
}
