import '../models/food_item.dart';
import '../models/cart_item.dart';
import '../models/order.dart';
import '../models/user.dart';

class MockData {
  // Food categories
  static const List<String> foodCategories = [
    'Breakfast',
    'Lunch',
    'Dinner',
    'Snacks',
    'Beverages',
    'Desserts',
  ];

  // Mock food items
  static List<FoodItem> getFoodItems() {
    return [
      // Breakfast items
      FoodItem(
        id: 'b1',
        name: 'Vegetable Omelette',
        description: 'Fresh eggs with mixed vegetables and cheese.',
        price: 5.99,
        imageUrl: 'https://images.unsplash.com/photo-1525351484163-7529414344d8?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=800&q=80',
        category: 'Breakfast',
        rating: 4.5,
        reviewCount: 128,
        preparationTimeMinutes: 10,
        ingredients: ['Eggs', 'Bell Peppers', 'Onions', 'Tomatoes', 'Cheese'],
        isVegetarian: true,
      ),
      FoodItem(
        id: 'b2',
        name: 'Pancake Stack',
        description: 'Fluffy pancakes served with maple syrup and fresh berries.',
        price: 6.49,
        imageUrl: 'https://images.unsplash.com/photo-1560787313-e80a7e38d90b?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=800&q=80',
        category: 'Breakfast',
        rating: 4.8,
        reviewCount: 156,
        preparationTimeMinutes: 15,
        ingredients: ['Flour', 'Eggs', 'Milk', 'Maple Syrup', 'Berries'],
        isVegetarian: true,
      ),
      FoodItem(
        id: 'b3',
        name: 'Breakfast Sandwich',
        description: 'Egg, cheese, and bacon in a toasted bagel.',
        price: 4.99,
        imageUrl: 'https://images.unsplash.com/photo-1550507992-eb63ffee0847?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=800&q=80',
        category: 'Breakfast',
        rating: 4.2,
        reviewCount: 89,
        preparationTimeMinutes: 8,
        ingredients: ['Bagel', 'Eggs', 'Cheese', 'Bacon'],
      ),
      
      // Lunch items
      FoodItem(
        id: 'l1',
        name: 'Chicken Caesar Salad',
        description: 'Fresh romaine lettuce with grilled chicken, parmesan, and Caesar dressing.',
        price: 8.99,
        imageUrl: 'https://images.unsplash.com/photo-1550304943-4f24f54ddde9?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=800&q=80',
        category: 'Lunch',
        rating: 4.3,
        reviewCount: 112,
        preparationTimeMinutes: 12,
        ingredients: ['Romaine Lettuce', 'Grilled Chicken', 'Parmesan', 'Croutons', 'Caesar Dressing'],
      ),
      FoodItem(
        id: 'l2',
        name: 'Veggie Wrap',
        description: 'Whole wheat wrap filled with hummus and fresh vegetables.',
        price: 7.49,
        imageUrl: 'https://images.unsplash.com/photo-1626700051175-6818013e1d4f?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=800&q=80',
        category: 'Lunch',
        rating: 4.5,
        reviewCount: 98,
        preparationTimeMinutes: 10,
        ingredients: ['Whole Wheat Wrap', 'Hummus', 'Lettuce', 'Tomatoes', 'Cucumbers', 'Bell Peppers'],
        isVegetarian: true,
      ),
      FoodItem(
        id: 'l3',
        name: 'Classic Burger',
        description: 'Juicy beef patty with lettuce, tomato, and cheese in a brioche bun.',
        price: 9.99,
        imageUrl: 'https://images.unsplash.com/photo-1565299507177-b0ac66763828?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=800&q=80',
        category: 'Lunch',
        rating: 4.7,
        reviewCount: 187,
        preparationTimeMinutes: 15,
        ingredients: ['Beef Patty', 'Brioche Bun', 'Lettuce', 'Tomato', 'Cheese', 'Onions', 'Special Sauce'],
      ),
      
      // Dinner items
      FoodItem(
        id: 'd1',
        name: 'Pasta Carbonara',
        description: 'Al dente pasta tossed with creamy sauce, bacon, and parmesan.',
        price: 11.99,
        imageUrl: 'https://images.unsplash.com/photo-1612874742237-6526221588e3?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=800&q=80',
        category: 'Dinner',
        rating: 4.8,
        reviewCount: 145,
        preparationTimeMinutes: 20,
        ingredients: ['Pasta', 'Eggs', 'Bacon', 'Parmesan', 'Black Pepper', 'Garlic'],
      ),
      FoodItem(
        id: 'd2',
        name: 'Vegetable Curry',
        description: 'Aromatic curry with mixed vegetables served with steamed rice.',
        price: 10.49,
        imageUrl: 'https://images.unsplash.com/photo-1565557623262-b51c2513a641?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=800&q=80',
        category: 'Dinner',
        rating: 4.6,
        reviewCount: 108,
        preparationTimeMinutes: 25,
        ingredients: ['Rice', 'Mixed Vegetables', 'Coconut Milk', 'Curry Spices', 'Garlic', 'Ginger'],
        isVegetarian: true,
        isSpicy: true,
      ),
      FoodItem(
        id: 'd3',
        name: 'Grilled Chicken',
        description: 'Tender grilled chicken breast with seasonal vegetables and quinoa.',
        price: 12.99,
        imageUrl: 'https://images.unsplash.com/photo-1532550907401-a500c9a57435?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=800&q=80',
        category: 'Dinner',
        rating: 4.4,
        reviewCount: 92,
        preparationTimeMinutes: 22,
        ingredients: ['Chicken Breast', 'Quinoa', 'Seasonal Vegetables', 'Olive Oil', 'Herbs'],
      ),
      
      // Snacks
      FoodItem(
        id: 's1',
        name: 'Crispy Fries',
        description: 'Golden crispy fries served with ketchup and aioli.',
        price: 3.99,
        imageUrl: 'https://images.unsplash.com/photo-1576107232684-1279f390859f?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=800&q=80',
        category: 'Snacks',
        rating: 4.7,
        reviewCount: 210,
        preparationTimeMinutes: 8,
        ingredients: ['Potatoes', 'Vegetable Oil', 'Salt'],
        isVegetarian: true,
      ),
      FoodItem(
        id: 's2',
        name: 'Nachos',
        description: 'Tortilla chips loaded with cheese, jalapeños, and salsa.',
        price: 5.99,
        imageUrl: 'https://images.unsplash.com/photo-1513456852971-30c0b8199d4d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=800&q=80',
        category: 'Snacks',
        rating: 4.5,
        reviewCount: 178,
        preparationTimeMinutes: 10,
        ingredients: ['Tortilla Chips', 'Cheese', 'Jalapeños', 'Salsa', 'Sour Cream'],
        isVegetarian: true,
        isSpicy: true,
      ),
      
      // Beverages
      FoodItem(
        id: 'bv1',
        name: 'Fresh Orange Juice',
        description: 'Freshly squeezed orange juice.',
        price: 2.99,
        imageUrl: 'https://images.unsplash.com/photo-1600271886742-f049cd451bba?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=800&q=80',
        category: 'Beverages',
        rating: 4.9,
        reviewCount: 165,
        preparationTimeMinutes: 5,
        ingredients: ['Oranges'],
        isVegetarian: true,
      ),
      FoodItem(
        id: 'bv2',
        name: 'Iced Caramel Latte',
        description: 'Espresso with milk, ice, and caramel syrup.',
        price: 4.49,
        imageUrl: 'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=800&q=80',
        category: 'Beverages',
        rating: 4.6,
        reviewCount: 142,
        preparationTimeMinutes: 6,
        ingredients: ['Espresso', 'Milk', 'Caramel Syrup', 'Ice'],
        isVegetarian: true,
      ),
      
      // Desserts
      FoodItem(
        id: 'ds1',
        name: 'Chocolate Brownie',
        description: 'Warm chocolate brownie served with vanilla ice cream.',
        price: 5.49,
        imageUrl: 'https://images.unsplash.com/photo-1611292405120-77c9807b0e2b?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=800&q=80',
        category: 'Desserts',
        rating: 4.8,
        reviewCount: 195,
        preparationTimeMinutes: 12,
        ingredients: ['Chocolate', 'Flour', 'Eggs', 'Sugar', 'Vanilla Ice Cream'],
        isVegetarian: true,
      ),
      FoodItem(
        id: 'ds2',
        name: 'Fruit Parfait',
        description: 'Layers of fresh fruits, yogurt, and granola.',
        price: 4.99,
        imageUrl: 'https://images.unsplash.com/photo-1488477181946-6428a0bfdf42?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=800&q=80',
        category: 'Desserts',
        rating: 4.7,
        reviewCount: 132,
        preparationTimeMinutes: 8,
        ingredients: ['Mixed Fruits', 'Yogurt', 'Granola', 'Honey'],
        isVegetarian: true,
      ),
    ];
  }

  // Get featured food items (items with highest ratings)
  static List<FoodItem> getFeaturedItems() {
    final items = getFoodItems();
    items.sort((a, b) => b.rating.compareTo(a.rating));
    return items.take(5).toList();
  }

  // Get food items by category
  static List<FoodItem> getItemsByCategory(String category) {
    return getFoodItems().where((item) => item.category == category).toList();
  }

  // Mock user data
  static User getCurrentUser() {
    return User(
      id: 'u1',
      name: 'Alex Johnson',
      email: 'alex.johnson@example.com',
      phoneNumber: '123-456-7890',
      avatar: 'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=800&q=80',
      deliveryAddresses: [
        'Dorm A, Room 123, University Campus',
        'Student Center, University Campus',
        'Library, University Campus',
      ],
      favoriteItems: ['b2', 'l3', 'd1'],
    );
  }

  // Mock admin user
  static User getAdminUser() {
    return User(
      id: 'a1',
      name: 'Sam Smith',
      email: 'sam.smith@canteen.com',
      phoneNumber: '987-654-3210',
      avatar: 'https://images.unsplash.com/photo-1568602471122-7832951cc4c5?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=800&q=80',
      role: UserRole.admin,
    );
  }

  // Mock order history
  static List<Order> getOrderHistory() {
    final user = getCurrentUser();
    final items = getFoodItems();
    
    return [
      Order(
        id: 'ord1',
        items: [
          CartItem(foodItem: items[0], quantity: 1),
          CartItem(foodItem: items[4], quantity: 2),
        ],
        orderTime: DateTime.now().subtract(const Duration(days: 2)),
        status: OrderStatus.delivered,
        total: items[0].price + (items[4].price * 2),
        userId: user.id,
        deliveryLocation: user.deliveryAddresses[0],
        estimatedDeliveryTime: DateTime.now().subtract(const Duration(days: 2, hours: 22)),
        paymentMethod: 'Credit Card',
        isPaid: true,
      ),
      Order(
        id: 'ord2',
        items: [
          CartItem(foodItem: items[2], quantity: 1),
          CartItem(foodItem: items[7], quantity: 1),
          CartItem(foodItem: items[10], quantity: 1),
        ],
        orderTime: DateTime.now().subtract(const Duration(days: 1)),
        status: OrderStatus.delivered,
        total: items[2].price + items[7].price + items[10].price,
        userId: user.id,
        deliveryLocation: user.deliveryAddresses[1],
        estimatedDeliveryTime: DateTime.now().subtract(const Duration(days: 1, hours: 23)),
        paymentMethod: 'Cash',
        isPaid: true,
      ),
      Order(
        id: 'ord3',
        items: [
          CartItem(foodItem: items[5], quantity: 1),
          CartItem(foodItem: items[12], quantity: 1),
        ],
        orderTime: DateTime.now().subtract(const Duration(hours: 3)),
        status: OrderStatus.preparing,
        total: items[5].price + items[12].price,
        userId: user.id,
        deliveryLocation: user.deliveryAddresses[2],
        estimatedDeliveryTime: DateTime.now().add(const Duration(minutes: 25)),
        paymentMethod: 'Credit Card',
        isPaid: true,
      ),
    ];
  }

  // Mock active orders for admin dashboard
  static List<Order> getActiveOrders() {
    final allItems = getFoodItems();
    final List<Order> activeOrders = [];
    
    // Order 1 - Pending
    activeOrders.add(
      Order(
        id: 'ord4',
        items: [
          CartItem(foodItem: allItems[3], quantity: 1),
          CartItem(foodItem: allItems[9], quantity: 1),
        ],
        orderTime: DateTime.now().subtract(const Duration(minutes: 10)),
        status: OrderStatus.pending,
        total: allItems[3].price + allItems[9].price,
        userId: 'u2',
        deliveryLocation: 'Dorm B, Room 345, University Campus',
        paymentMethod: 'Credit Card',
        isPaid: true,
      ),
    );
    
    // Order 2 - Confirmed
    activeOrders.add(
      Order(
        id: 'ord5',
        items: [
          CartItem(foodItem: allItems[1], quantity: 2),
          CartItem(foodItem: allItems[11], quantity: 2),
        ],
        orderTime: DateTime.now().subtract(const Duration(minutes: 25)),
        status: OrderStatus.confirmed,
        total: (allItems[1].price * 2) + (allItems[11].price * 2),
        userId: 'u3',
        deliveryLocation: 'Engineering Building, University Campus',
        estimatedDeliveryTime: DateTime.now().add(const Duration(minutes: 20)),
        paymentMethod: 'Cash',
        isPaid: false,
      ),
    );
    
    // Order 3 - Preparing
    activeOrders.add(
      Order(
        id: 'ord6',
        items: [
          CartItem(foodItem: allItems[4], quantity: 1),
          CartItem(foodItem: allItems[6], quantity: 1),
          CartItem(foodItem: allItems[13], quantity: 1),
        ],
        orderTime: DateTime.now().subtract(const Duration(minutes: 35)),
        status: OrderStatus.preparing,
        total: allItems[4].price + allItems[6].price + allItems[13].price,
        userId: 'u4',
        deliveryLocation: 'Student Union, University Campus',
        estimatedDeliveryTime: DateTime.now().add(const Duration(minutes: 10)),
        paymentMethod: 'Credit Card',
        isPaid: true,
      ),
    );
    
    // Order 4 - Ready for Pickup
    activeOrders.add(
      Order(
        id: 'ord7',
        items: [
          CartItem(foodItem: allItems[8], quantity: 3),
        ],
        orderTime: DateTime.now().subtract(const Duration(minutes: 45)),
        status: OrderStatus.readyForPickup,
        total: allItems[8].price * 3,
        userId: 'u5',
        deliveryLocation: 'Pickup at Canteen',
        estimatedDeliveryTime: DateTime.now(),
        paymentMethod: 'Cash',
        isPaid: false,
      ),
    );
    
    return activeOrders;
  }

  // Mock sales data for admin analytics
  static List<Map<String, dynamic>> getSalesData() {
    return [
      {'day': 'Mon', 'sales': 2400},
      {'day': 'Tue', 'sales': 1600},
      {'day': 'Wed', 'sales': 2800},
      {'day': 'Thu', 'sales': 3200},
      {'day': 'Fri', 'sales': 4100},
      {'day': 'Sat', 'sales': 3800},
      {'day': 'Sun', 'sales': 2200},
    ];
  }

  // Mock popular items data for admin analytics
  static List<Map<String, dynamic>> getPopularItems() {
    return [
      {'name': 'Classic Burger', 'orders': 47},
      {'name': 'Crispy Fries', 'orders': 42},
      {'name': 'Pancake Stack', 'orders': 38},
      {'name': 'Iced Caramel Latte', 'orders': 31},
      {'name': 'Chocolate Brownie', 'orders': 28},
    ];
  }
} 