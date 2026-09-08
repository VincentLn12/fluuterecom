class UserModel {
  final String id;
  final String email;
  final String? name;
  final String? role;
  final String? firstName;
  final String? lastName;

  UserModel({
    required this.id,
    required this.email,
    this.name,
    this.role,
    this.firstName,
    this.lastName,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      name: json['name']?.toString(),
      role: json['role']?.toString() ?? 'User',
      firstName: json['firstName']?.toString(),
      lastName: json['lastName']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role,
      'firstName': firstName,
      'lastName': lastName,
    };
  }

  String get displayName {
    if (firstName != null && firstName!.isNotEmpty) {
      if (lastName != null && lastName!.isNotEmpty) {
        return '$firstName $lastName';
      }
      return firstName!;
    }
    if (name != null && name!.isNotEmpty) {
      return name!;
    }
    return email.contains('@') ? email.split('@').first : email;
  }
}
