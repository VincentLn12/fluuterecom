import '../utils/json_parser.dart';

class TenantModel {
  final int? id;
  final String prefix;
  final String firstName;
  final String lastName;
  final String phone;
  final String email;
  final String idCard;
  final String address;
  final int roomId;
  final String moveInDate;
  final String? moveOutDate;
  final String status;

  const TenantModel({
    this.id,
    required this.prefix,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.idCard,
    required this.address,
    required this.roomId,
    required this.moveInDate,
    required this.moveOutDate,
    required this.status,
  });

  String get fullName => '$prefix$firstName $lastName';
  bool get isActive => status == 'active';

  factory TenantModel.fromJson(Map<String, dynamic> json) => TenantModel(
    id: JsonParser.asInt(json['id']),
    prefix: json['prefix']?.toString() ?? '',
    firstName: json['firstName']?.toString() ?? '',
    lastName: json['lastName']?.toString() ?? '',
    phone: json['phone']?.toString() ?? '',
    email: json['email']?.toString() ?? '',
    idCard: json['idCard']?.toString() ?? '',
    address: json['address']?.toString() ?? '',
    roomId: JsonParser.asInt(json['roomId']) ?? 0,
    moveInDate: json['moveInDate']?.toString() ?? '',
    moveOutDate: json['moveOutDate']?.toString(),
    status: json['status']?.toString() ?? 'active',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'prefix': prefix,
    'firstName': firstName,
    'lastName': lastName,
    'phone': phone,
    'email': email,
    'idCard': idCard,
    'address': address,
    'roomId': roomId,
    'moveInDate': moveInDate,
    'moveOutDate': moveOutDate,
    'status': status,
  };

  TenantModel copyWith({
    int? id,
    String? prefix,
    String? firstName,
    String? lastName,
    String? phone,
    String? email,
    String? idCard,
    String? address,
    int? roomId,
    String? moveInDate,
    String? moveOutDate,
    String? status,
  }) {
    return TenantModel(
      id: id ?? this.id,
      prefix: prefix ?? this.prefix,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      idCard: idCard ?? this.idCard,
      address: address ?? this.address,
      roomId: roomId ?? this.roomId,
      moveInDate: moveInDate ?? this.moveInDate,
      moveOutDate: moveOutDate ?? this.moveOutDate,
      status: status ?? this.status,
    );
  }
}
