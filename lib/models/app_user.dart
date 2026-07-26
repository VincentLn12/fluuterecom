class AppUser {
  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    required this.favoriteRecipeIds,
  });

  final String? id;
  final String name;
  final String email;
  final String password;
  final UserRole role;
  final List<int> favoriteRecipeIds;

  bool get isAdmin => role == UserRole.admin;

  factory AppUser.fromJson(Map<String, Object?> json) {
    return AppUser(
      id: json['id']?.toString(),
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      password: json['password']?.toString() ?? '',
      role: UserRoleX.fromValue(json['role']?.toString()),
      favoriteRecipeIds: (json['favoriteRecipeIds'] as List<dynamic>? ?? [])
          .map((item) => int.tryParse(item.toString()))
          .whereType<int>()
          .toList(),
    );
  }

  Map<String, Object?> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'email': email,
      'password': password,
      'role': role.value,
      'favoriteRecipeIds': favoriteRecipeIds,
    };
  }

  AppUser copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    UserRole? role,
    List<int>? favoriteRecipeIds,
  }) {
    return AppUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      role: role ?? this.role,
      favoriteRecipeIds: favoriteRecipeIds ?? this.favoriteRecipeIds,
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
