import '../utils/json_parser.dart';

class RoomModel {
  final int? id;
  final String roomNumber;
  final int floor;
  final String roomType;
  final double monthlyRent;
  final double deposit;
  final String status;
  final String description;
  final String imageUrl;

  const RoomModel({
    this.id,
    required this.roomNumber,
    required this.floor,
    required this.roomType,
    required this.monthlyRent,
    required this.deposit,
    required this.status,
    required this.description,
    required this.imageUrl,
  });

  bool get isVacant => status == 'vacant';

  factory RoomModel.fromJson(Map<String, dynamic> json) => RoomModel(
    id: JsonParser.asInt(json['id']),
    roomNumber: json['roomNumber']?.toString() ?? '',
    floor: JsonParser.asInt(json['floor']) ?? 0,
    roomType: json['roomType']?.toString() ?? '',
    monthlyRent: JsonParser.asDouble(json['monthlyRent']),
    deposit: JsonParser.asDouble(json['deposit']),
    status: json['status']?.toString() ?? 'vacant',
    description: json['description']?.toString() ?? '',
    imageUrl: json['imageUrl']?.toString() ?? '',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'roomNumber': roomNumber,
    'floor': floor,
    'roomType': roomType,
    'monthlyRent': monthlyRent,
    'deposit': deposit,
    'status': status,
    'description': description,
    'imageUrl': imageUrl,
  };

  RoomModel copyWith({
    int? id,
    String? roomNumber,
    int? floor,
    String? roomType,
    double? monthlyRent,
    double? deposit,
    String? status,
    String? description,
    String? imageUrl,
  }) {
    return RoomModel(
      id: id ?? this.id,
      roomNumber: roomNumber ?? this.roomNumber,
      floor: floor ?? this.floor,
      roomType: roomType ?? this.roomType,
      monthlyRent: monthlyRent ?? this.monthlyRent,
      deposit: deposit ?? this.deposit,
      status: status ?? this.status,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
