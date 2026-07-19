import '../utils/json_helpers.dart';

class Ingredient {
  const Ingredient({
    required this.name,
    required this.amount,
    required this.unit,
  });

  final String name;
  final double amount;
  final String unit;

  factory Ingredient.fromJson(Map<String, Object?> json) {
    return Ingredient(
      name: json['name'] as String? ?? '',
      amount: readDouble(json['amount']),
      unit: json['unit'] as String? ?? '',
    );
  }

  Map<String, Object?> toJson() {
    return {
      'name': name,
      'amount': amount,
      'unit': unit,
    };
  }

  Ingredient copyWith({
    String? name,
    double? amount,
    String? unit,
  }) {
    return Ingredient(
      name: name ?? this.name,
      amount: amount ?? this.amount,
      unit: unit ?? this.unit,
    );
  }
}
