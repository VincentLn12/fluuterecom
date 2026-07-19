import '../utils/json_parser.dart';

class SettingsModel {
  final int? id;
  final String dormitoryName;
  final String address;
  final String phone;
  final double waterRate;
  final double electricRate;
  final int defaultDueDay;

  const SettingsModel({
    this.id,
    required this.dormitoryName,
    required this.address,
    required this.phone,
    required this.waterRate,
    required this.electricRate,
    required this.defaultDueDay,
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) => SettingsModel(
    id: JsonParser.asInt(json['id']),
    dormitoryName: json['dormitoryName']?.toString() ?? '',
    address: json['address']?.toString() ?? '',
    phone: json['phone']?.toString() ?? '',
    waterRate: JsonParser.asDouble(json['waterRate']),
    electricRate: JsonParser.asDouble(json['electricRate']),
    defaultDueDay: JsonParser.asInt(json['defaultDueDay']) ?? 10,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'dormitoryName': dormitoryName,
    'address': address,
    'phone': phone,
    'waterRate': waterRate,
    'electricRate': electricRate,
    'defaultDueDay': defaultDueDay,
  };

  SettingsModel copyWith({
    int? id,
    String? dormitoryName,
    String? address,
    String? phone,
    double? waterRate,
    double? electricRate,
    int? defaultDueDay,
  }) {
    return SettingsModel(
      id: id ?? this.id,
      dormitoryName: dormitoryName ?? this.dormitoryName,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      waterRate: waterRate ?? this.waterRate,
      electricRate: electricRate ?? this.electricRate,
      defaultDueDay: defaultDueDay ?? this.defaultDueDay,
    );
  }
}
