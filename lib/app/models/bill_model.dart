import '../utils/json_parser.dart';

class BillModel {
  final int? id;
  final int roomId;
  final int tenantId;
  final int utilityMeterId;
  final String billingMonth;
  final double roomRent;
  final double waterAmount;
  final double electricAmount;
  final double otherAmount;
  final double lateFee;
  final double totalAmount;
  final String dueDate;
  final String? paidDate;
  final String? paymentMethod;
  final String status;

  const BillModel({
    this.id,
    required this.roomId,
    required this.tenantId,
    required this.utilityMeterId,
    required this.billingMonth,
    required this.roomRent,
    required this.waterAmount,
    required this.electricAmount,
    required this.otherAmount,
    required this.lateFee,
    required this.totalAmount,
    required this.dueDate,
    required this.paidDate,
    required this.paymentMethod,
    required this.status,
  });

  bool get isPaid => status == 'paid';

  factory BillModel.fromJson(Map<String, dynamic> json) => BillModel(
    id: JsonParser.asInt(json['id']),
    roomId: JsonParser.asInt(json['roomId']) ?? 0,
    tenantId: JsonParser.asInt(json['tenantId']) ?? 0,
    utilityMeterId: JsonParser.asInt(json['utilityMeterId']) ?? 0,
    billingMonth: json['billingMonth']?.toString() ?? '',
    roomRent: JsonParser.asDouble(json['roomRent']),
    waterAmount: JsonParser.asDouble(json['waterAmount']),
    electricAmount: JsonParser.asDouble(json['electricAmount']),
    otherAmount: JsonParser.asDouble(json['otherAmount']),
    lateFee: JsonParser.asDouble(json['lateFee']),
    totalAmount: JsonParser.asDouble(json['totalAmount']),
    dueDate: json['dueDate']?.toString() ?? '',
    paidDate: json['paidDate']?.toString(),
    paymentMethod: json['paymentMethod']?.toString(),
    status: json['status']?.toString() ?? 'pending',
  );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'roomId': roomId,
      'tenantId': tenantId,
      'utilityMeterId': utilityMeterId,
      'billingMonth': billingMonth,
      'roomRent': roomRent,
      'waterAmount': waterAmount,
      'electricAmount': electricAmount,
      'otherAmount': otherAmount,
      'lateFee': lateFee,
      'totalAmount': totalAmount,
      'dueDate': dueDate,
      'paidDate': paidDate,
      'paymentMethod': paymentMethod,
      'status': status,
    };
    if (id != null) {
      data['id'] = id;
    }
    return data;
  }

  BillModel copyWith({
    int? id,
    int? roomId,
    int? tenantId,
    int? utilityMeterId,
    String? billingMonth,
    double? roomRent,
    double? waterAmount,
    double? electricAmount,
    double? otherAmount,
    double? lateFee,
    double? totalAmount,
    String? dueDate,
    String? paidDate,
    String? paymentMethod,
    String? status,
  }) {
    return BillModel(
      id: id ?? this.id,
      roomId: roomId ?? this.roomId,
      tenantId: tenantId ?? this.tenantId,
      utilityMeterId: utilityMeterId ?? this.utilityMeterId,
      billingMonth: billingMonth ?? this.billingMonth,
      roomRent: roomRent ?? this.roomRent,
      waterAmount: waterAmount ?? this.waterAmount,
      electricAmount: electricAmount ?? this.electricAmount,
      otherAmount: otherAmount ?? this.otherAmount,
      lateFee: lateFee ?? this.lateFee,
      totalAmount: totalAmount ?? this.totalAmount,
      dueDate: dueDate ?? this.dueDate,
      paidDate: paidDate ?? this.paidDate,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      status: status ?? this.status,
    );
  }
}
