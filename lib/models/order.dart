import 'package:flutter/material.dart';

import 'cart_item.dart';

enum OrderStatus {
  pending,
  confirmed,
  preparing,
  readyForPickup,
  pickedUp,
  delivered,
  cancelled
}

class Order {
  final String id;
  final List<CartItem> items;
  final DateTime orderTime;
  final OrderStatus status;
  final double total;
  final String? deliveryLocation;
  final DateTime? estimatedDeliveryTime;
  final String userId;
  final String? paymentMethod;
  final bool isPaid;

  Order({
    required this.id,
    required this.items,
    required this.orderTime,
    this.status = OrderStatus.pending,
    required this.total,
    this.deliveryLocation,
    this.estimatedDeliveryTime,
    required this.userId,
    this.paymentMethod,
    this.isPaid = false,
  });

  // Get color associated with order status
  Color get statusColor {
    switch (status) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.confirmed:
        return Colors.blue;
      case OrderStatus.preparing:
        return Colors.amber;
      case OrderStatus.readyForPickup:
        return Colors.green;
      case OrderStatus.pickedUp:
        return Colors.teal;
      case OrderStatus.delivered:
        return Colors.green.shade800;
      case OrderStatus.cancelled:
        return Colors.red;
    }
  }

  // Get human-readable status
  String get statusText {
    switch (status) {
      case OrderStatus.pending:
        return "Pending";
      case OrderStatus.confirmed:
        return "Confirmed";
      case OrderStatus.preparing:
        return "Preparing";
      case OrderStatus.readyForPickup:
        return "Ready for Pickup";
      case OrderStatus.pickedUp:
        return "Picked Up";
      case OrderStatus.delivered:
        return "Delivered";
      case OrderStatus.cancelled:
        return "Cancelled";
    }
  }

  // Create a copy of this order with given fields replaced with new values
  Order copyWith({
    String? id,
    List<CartItem>? items,
    DateTime? orderTime,
    OrderStatus? status,
    double? total,
    String? deliveryLocation,
    DateTime? estimatedDeliveryTime,
    String? userId,
    String? paymentMethod,
    bool? isPaid,
  }) {
    return Order(
      id: id ?? this.id,
      items: items ?? this.items,
      orderTime: orderTime ?? this.orderTime,
      status: status ?? this.status,
      total: total ?? this.total,
      deliveryLocation: deliveryLocation ?? this.deliveryLocation,
      estimatedDeliveryTime: estimatedDeliveryTime ?? this.estimatedDeliveryTime,
      userId: userId ?? this.userId,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      isPaid: isPaid ?? this.isPaid,
    );
  }

  // Convert to JSON (for future API integration)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((item) => item.toJson()).toList(),
      'orderTime': orderTime.toIso8601String(),
      'status': status.index,
      'total': total,
      'deliveryLocation': deliveryLocation,
      'estimatedDeliveryTime': estimatedDeliveryTime?.toIso8601String(),
      'userId': userId,
      'paymentMethod': paymentMethod,
      'isPaid': isPaid,
    };
  }

  // Create from JSON (for future API integration)
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      items: (json['items'] as List)
          .map((itemJson) => CartItem.fromJson(itemJson))
          .toList(),
      orderTime: DateTime.parse(json['orderTime']),
      status: OrderStatus.values[json['status']],
      total: json['total'],
      deliveryLocation: json['deliveryLocation'],
      estimatedDeliveryTime: json['estimatedDeliveryTime'] != null
          ? DateTime.parse(json['estimatedDeliveryTime'])
          : null,
      userId: json['userId'],
      paymentMethod: json['paymentMethod'],
      isPaid: json['isPaid'] ?? false,
    );
  }
} 