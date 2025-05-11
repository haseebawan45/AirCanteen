import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/order.dart';
import '../utils/mock_data.dart';

class OrderProvider with ChangeNotifier {
  List<Order> _orders = [];

  // Get all orders
  List<Order> get orders => [..._orders];

  // Get active orders (not delivered or cancelled)
  List<Order> get activeOrders => _orders.where(
    (order) => order.status != OrderStatus.delivered && 
               order.status != OrderStatus.cancelled
  ).toList();

  // Initialize orders with mock data
  void loadOrders() {
    _orders = MockData.getOrderHistory();
    notifyListeners();
  }

  // Initialize orders for admin dashboard
  void loadActiveOrders() {
    _orders = MockData.getActiveOrders();
    notifyListeners();
  }

  // Add new order
  Future<Order> placeOrder({
    required List<CartItem> items,
    required double total,
    required String userId,
    required String? deliveryLocation,
    String? paymentMethod,
    bool isPaid = false,
  }) async {
    // Simulate server delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Create new order
    final newOrder = Order(
      id: 'ord_${DateTime.now().millisecondsSinceEpoch}',
      items: items,
      orderTime: DateTime.now(),
      status: OrderStatus.pending,
      total: total,
      userId: userId,
      deliveryLocation: deliveryLocation,
      estimatedDeliveryTime: DateTime.now().add(const Duration(minutes: 30)),
      paymentMethod: paymentMethod,
      isPaid: isPaid,
    );
    
    _orders.add(newOrder);
    notifyListeners();
    
    return newOrder;
  }

  // Update order status
  Future<Order?> updateOrderStatus(String orderId, OrderStatus newStatus) async {
    // Simulate server delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    final orderIndex = _orders.indexWhere((order) => order.id == orderId);
    if (orderIndex >= 0) {
      _orders[orderIndex] = _orders[orderIndex].copyWith(status: newStatus);
      
      // Update estimated delivery time based on status
      if (newStatus == OrderStatus.confirmed) {
        _orders[orderIndex] = _orders[orderIndex].copyWith(
          estimatedDeliveryTime: DateTime.now().add(const Duration(minutes: 25)),
        );
      } else if (newStatus == OrderStatus.preparing) {
        _orders[orderIndex] = _orders[orderIndex].copyWith(
          estimatedDeliveryTime: DateTime.now().add(const Duration(minutes: 15)),
        );
      } else if (newStatus == OrderStatus.readyForPickup) {
        _orders[orderIndex] = _orders[orderIndex].copyWith(
          estimatedDeliveryTime: DateTime.now().add(const Duration(minutes: 5)),
        );
      }
      
      notifyListeners();
      return _orders[orderIndex];
    }
    
    return null;
  }

  // Get order by ID
  Order? getOrderById(String orderId) {
    try {
      return _orders.firstWhere((order) => order.id == orderId);
    } catch (e) {
      return null;
    }
  }

  // Mark order as paid
  Future<bool> markOrderAsPaid(String orderId) async {
    // Simulate server delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    final orderIndex = _orders.indexWhere((order) => order.id == orderId);
    if (orderIndex >= 0) {
      _orders[orderIndex] = _orders[orderIndex].copyWith(isPaid: true);
      notifyListeners();
      return true;
    }
    
    return false;
  }
} 