import 'ingredient.dart';
import '../utils/json_helpers.dart';

class Recipe {
  const Recipe({
    this.id,
    required this.name,
    required this.description,
    required this.categoryId,
    required this.categoryName,
    required this.imageUrl,
    required this.prepTime,
    required this.cookTime,
    required this.servings,
    required this.difficulty,
    required this.rating,
    required this.isFavorite,
    required this.ownerId,
    required this.ownerName,
    required this.ingredients,
    required this.steps,
  });

  final int? id;
  final String name;
  final String description;
  final int categoryId;
  final String categoryName;
  final String imageUrl;
  final int prepTime;
  final int cookTime;
  final int servings;
  final String difficulty;
  final double rating;
  final bool isFavorite;
  final String ownerId;
  final String ownerName;
  final List<Ingredient> ingredients;
  final List<String> steps;

  int get totalTime => prepTime + cookTime;

  factory Recipe.fromJson(Map<String, Object?> json) {
    final ingredientItems = json['ingredients'] as List<dynamic>? ?? [];
    final stepItems = json['steps'] as List<dynamic>? ?? [];
    return Recipe(
      id: readInt(json['id']),
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      categoryId: readInt(json['categoryId']) ?? 0,
      categoryName: json['categoryName'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      prepTime: readInt(json['prepTime']) ?? 0,
      cookTime: readInt(json['cookTime']) ?? 0,
      servings: readInt(json['servings']) ?? 1,
      difficulty: json['difficulty'] as String? ?? '',
      rating: readDouble(json['rating']),
      isFavorite: json['isFavorite'] as bool? ?? false,
      ownerId: json['ownerId']?.toString() ?? 'user-1',
      ownerName: json['ownerName']?.toString() ?? 'นักศึกษา Flutter',
      ingredients: ingredientItems
          .whereType<Map<String, Object?>>()
          .map(Ingredient.fromJson)
          .toList(),
      steps: stepItems.map((step) => step.toString()).toList(),
    );
  }

  Map<String, Object?> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'description': description,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'imageUrl': imageUrl,
      'prepTime': prepTime,
      'cookTime': cookTime,
      'servings': servings,
      'difficulty': difficulty,
      'rating': rating,
      'isFavorite': isFavorite,
      'ownerId': ownerId,
      'ownerName': ownerName,
      'ingredients': ingredients.map((item) => item.toJson()).toList(),
      'steps': steps,
    };
  }

  Recipe copyWith({
    int? id,
    String? name,
    String? description,
    int? categoryId,
    String? categoryName,
    String? imageUrl,
    int? prepTime,
    int? cookTime,
    int? servings,
    String? difficulty,
    double? rating,
    bool? isFavorite,
    String? ownerId,
    String? ownerName,
    List<Ingredient>? ingredients,
    List<String>? steps,
  }) {
    return Recipe(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      imageUrl: imageUrl ?? this.imageUrl,
      prepTime: prepTime ?? this.prepTime,
      cookTime: cookTime ?? this.cookTime,
      servings: servings ?? this.servings,
      difficulty: difficulty ?? this.difficulty,
      rating: rating ?? this.rating,
      isFavorite: isFavorite ?? this.isFavorite,
      ownerId: ownerId ?? this.ownerId,
      ownerName: ownerName ?? this.ownerName,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
    );
  }
}
