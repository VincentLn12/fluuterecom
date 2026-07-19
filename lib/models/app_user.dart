class AppUser {
  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
  });

  final String? id;
  final String name;
  final String email;
  final String password;
  final UserRole role;

  bool get isAdmin => role == UserRole.admin;

  factory AppUser.fromJson(Map<String, Object?> json) {
    return AppUser(
      id: json['id']?.toString(),
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      password: json['password']?.toString() ?? '',
      role: UserRoleX.fromValue(json['role']?.toString()),
    );
  }

  Map<String, Object?> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'email': email,
      'password': password,
      'role': role.value,
    };
  }

  AppUser copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    UserRole? role,
  }) {
    return AppUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      role: role ?? this.role,
    );
  }
}

enum UserRole { user, admin }

extension UserRoleX on UserRole {
  String get value => switch (this) {
        UserRole.admin => 'admin',
        UserRole.user => 'user',
      };

  static UserRole fromValue(String? value) {
    return value == 'admin' ? UserRole.admin : UserRole.user;
  }
}
