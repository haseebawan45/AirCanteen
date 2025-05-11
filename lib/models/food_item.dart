class FoodItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final double rating;
  final int reviewCount;
  final bool isAvailable;
  final int preparationTimeMinutes;
  final List<String> ingredients;
  final List<String> allergens;
  final bool isVegetarian;
  final bool isSpicy;
  final bool compact;

  FoodItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.isAvailable = true,
    this.preparationTimeMinutes = 15,
    this.ingredients = const [],
    this.allergens = const [],
    this.isVegetarian = false,
    this.isSpicy = false,
    this.compact = false,
  });

  // Create a copy of this food item with given fields replaced with new values
  FoodItem copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    String? category,
    double? rating,
    int? reviewCount,
    bool? isAvailable,
    int? preparationTimeMinutes,
    List<String>? ingredients,
    List<String>? allergens,
    bool? isVegetarian,
    bool? isSpicy,
    bool? compact,
  }) {
    return FoodItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      isAvailable: isAvailable ?? this.isAvailable,
      preparationTimeMinutes: preparationTimeMinutes ?? this.preparationTimeMinutes,
      ingredients: ingredients ?? this.ingredients,
      allergens: allergens ?? this.allergens,
      isVegetarian: isVegetarian ?? this.isVegetarian,
      isSpicy: isSpicy ?? this.isSpicy,
      compact: compact ?? this.compact,
    );
  }

  // Convert to JSON (for future API integration)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
      'rating': rating,
      'reviewCount': reviewCount,
      'isAvailable': isAvailable,
      'preparationTimeMinutes': preparationTimeMinutes,
      'ingredients': ingredients,
      'allergens': allergens,
      'isVegetarian': isVegetarian,
      'isSpicy': isSpicy,
      'compact': compact,
    };
  }

  // Create from JSON (for future API integration)
  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      imageUrl: json['imageUrl'],
      category: json['category'],
      rating: json['rating'] ?? 0.0,
      reviewCount: json['reviewCount'] ?? 0,
      isAvailable: json['isAvailable'] ?? true,
      preparationTimeMinutes: json['preparationTimeMinutes'] ?? 15,
      ingredients: List<String>.from(json['ingredients'] ?? []),
      allergens: List<String>.from(json['allergens'] ?? []),
      isVegetarian: json['isVegetarian'] ?? false,
      isSpicy: json['isSpicy'] ?? false,
      compact: json['compact'] ?? false,
    );
  }
} 