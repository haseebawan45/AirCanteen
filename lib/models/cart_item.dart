import 'food_item.dart';

class CartItem {
  final FoodItem foodItem;
  final int quantity;
  final String? specialInstructions;

  CartItem({
    required this.foodItem,
    this.quantity = 1,
    this.specialInstructions,
  });

  // Calculate total price for this cart item
  double get totalPrice => foodItem.price * quantity;

  // Create a copy of this cart item with given fields replaced with new values
  CartItem copyWith({
    FoodItem? foodItem,
    int? quantity,
    String? specialInstructions,
  }) {
    return CartItem(
      foodItem: foodItem ?? this.foodItem,
      quantity: quantity ?? this.quantity,
      specialInstructions: specialInstructions ?? this.specialInstructions,
    );
  }

  // Convert to JSON (for future API integration)
  Map<String, dynamic> toJson() {
    return {
      'foodItem': foodItem.toJson(),
      'quantity': quantity,
      'specialInstructions': specialInstructions,
    };
  }

  // Create from JSON (for future API integration)
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      foodItem: FoodItem.fromJson(json['foodItem']),
      quantity: json['quantity'] ?? 1,
      specialInstructions: json['specialInstructions'],
    );
  }
} 