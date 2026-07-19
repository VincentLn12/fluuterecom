import '../utils/json_parser.dart';

class UtilityMeterModel {
  final int? id;
  final int roomId;
  final String month;
  final double previousWater;
  final double currentWater;
  final double previousElectric;
  final double currentElectric;
  final double waterRate;
  final double electricRate;
  final double waterUnits;
  final double electricUnits;
  final double waterAmount;
  final double electricAmount;

  const UtilityMeterModel({
    this.id,
    required this.roomId,
    required this.month,
    required this.previousWater,
    required this.currentWater,
    required this.previousElectric,
    required this.currentElectric,
    required this.waterRate,
    required this.electricRate,
    required this.waterUnits,
    required this.electricUnits,
    required this.waterAmount,
    required this.electricAmount,
  });

  factory UtilityMeterModel.fromJson(Map<String, dynamic> json) =>
      UtilityMeterModel(
        id: JsonParser.asInt(json['id']),
        roomId: JsonParser.asInt(json['roomId']) ?? 0,
        month: json['month']?.toString() ?? '',
        previousWater: JsonParser.asDouble(json['previousWater']),
        currentWater: JsonParser.asDouble(json['currentWater']),
        previousElectric: JsonParser.asDouble(json['previousElectric']),
        currentElectric: JsonParser.asDouble(json['currentElectric']),
        waterRate: JsonParser.asDouble(json['waterRate']),
        electricRate: JsonParser.asDouble(json['electricRate']),
        waterUnits: JsonParser.asDouble(json['waterUnits']),
        electricUnits: JsonParser.asDouble(json['electricUnits']),
        waterAmount: JsonParser.asDouble(json['waterAmount']),
        electricAmount: JsonParser.asDouble(json['electricAmount']),
      );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'roomId': roomId,
      'month': month,
      'previousWater': previousWater,
      'currentWater': currentWater,
      'previousElectric': previousElectric,
      'currentElectric': currentElectric,
      'waterRate': waterRate,
      'electricRate': electricRate,
      'waterUnits': waterUnits,
      'electricUnits': electricUnits,
      'waterAmount': waterAmount,
      'electricAmount': electricAmount,
    };
    if (id != null) {
      data['id'] = id;
    }
    return data;
  }

  UtilityMeterModel copyWith({
    int? id,
    int? roomId,
    String? month,
    double? previousWater,
    double? currentWater,
    double? previousElectric,
    double? currentElectric,
    double? waterRate,
    double? electricRate,
    double? waterUnits,
    double? electricUnits,
    double? waterAmount,
    double? electricAmount,
  }) {
    return UtilityMeterModel(
      id: id ?? this.id,
      roomId: roomId ?? this.roomId,
      month: month ?? this.month,
      previousWater: previousWater ?? this.previousWater,
      currentWater: currentWater ?? this.currentWater,
      previousElectric: previousElectric ?? this.previousElectric,
      currentElectric: currentElectric ?? this.currentElectric,
      waterRate: waterRate ?? this.waterRate,
      electricRate: electricRate ?? this.electricRate,
      waterUnits: waterUnits ?? this.waterUnits,
      electricUnits: electricUnits ?? this.electricUnits,
      waterAmount: waterAmount ?? this.waterAmount,
      electricAmount: electricAmount ?? this.electricAmount,
    );
  }
}
