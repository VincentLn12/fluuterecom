import '../utils/json_helpers.dart';

class Category {
  const Category({
    this.id,
    required this.name,
    required this.imageUrl,
  });

  final int? id;
  final String name;
  final String imageUrl;

  factory Category.fromJson(Map<String, Object?> json) {
    return Category(
      id: readInt(json['id']),
      name: json['name'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
    );
  }

  Map<String, Object?> toJson() {
    return {
      if (id != null) 'id': id.toString(),
      'name': name,
      'imageUrl': imageUrl,
    };
  }

  Category copyWith({
    int? id,
    String? name,
    String? imageUrl,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
