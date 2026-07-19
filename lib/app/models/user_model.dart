import '../utils/json_parser.dart';

class UserModel {
  final int? id;
  final String name;
  final String email;
  final String password;
  final String role;
  final int? tenantId;

  const UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    required this.tenantId,
  });

  bool get isOwner => role == 'owner';
  bool get isTenant => role == 'tenant';

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: JsonParser.asInt(json['id']),
    name: json['name']?.toString() ?? '',
    email: json['email']?.toString() ?? '',
    password: json['password']?.toString() ?? '',
    role: json['role']?.toString() ?? 'tenant',
    tenantId: JsonParser.asInt(json['tenantId']),
  );
}
