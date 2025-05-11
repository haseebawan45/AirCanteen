import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/food_item.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  // Get all items in the cart
  List<CartItem> get items => [..._items];

  // Get total number of items in the cart
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  // Get total price of all items in the cart
  double get totalPrice => _items.fold(
        0,
        (sum, item) => sum + (item.foodItem.price * item.quantity),
      );

  // Check if cart is empty
  bool get isEmpty => _items.isEmpty;

  // Find cart item by food item
  CartItem? findByFoodItem(FoodItem foodItem) {
    final index = _items.indexWhere((item) => item.foodItem.id == foodItem.id);
    if (index >= 0) {
      return _items[index];
    }
    return null;
  }

  // Add item to cart
  void addItem(FoodItem foodItem, {int quantity = 1, String? specialInstructions}) {
    final existingIndex = _items.indexWhere((item) => item.foodItem.id == foodItem.id);

    if (existingIndex >= 0) {
      // Item already exists, update quantity
      _items[existingIndex] = _items[existingIndex].copyWith(
        quantity: _items[existingIndex].quantity + quantity,
        specialInstructions: specialInstructions ?? _items[existingIndex].specialInstructions,
      );
    } else {
      // Add new item
      _items.add(
        CartItem(
          foodItem: foodItem,
          quantity: quantity,
          specialInstructions: specialInstructions,
        ),
      );
    }
    notifyListeners();
  }

  // Remove item from cart
  void removeItem(String foodItemId) {
    _items.removeWhere((item) => item.foodItem.id == foodItemId);
    notifyListeners();
  }

  // Update item quantity
  void updateQuantity(String foodItemId, int quantity) {
    final index = _items.indexWhere((item) => item.foodItem.id == foodItemId);
    if (index >= 0) {
      if (quantity <= 0) {
        // Remove item if quantity is 0 or less
        removeItem(foodItemId);
      } else {
        // Update quantity
        _items[index] = _items[index].copyWith(quantity: quantity);
        notifyListeners();
      }
    }
  }

  // Update special instructions
  void updateSpecialInstructions(String foodItemId, String? specialInstructions) {
    final index = _items.indexWhere((item) => item.foodItem.id == foodItemId);
    if (index >= 0) {
      _items[index] = _items[index].copyWith(specialInstructions: specialInstructions);
      notifyListeners();
    }
  }

  // Clear the cart
  void clear() {
    _items.clear();
    notifyListeners();
  }
} 