import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../models/order.dart';
import '../../providers/order_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/order_card.dart';

class OrderTrackingScreen extends StatefulWidget {
  final String orderId;
  final Order? order;

  const OrderTrackingScreen({
    super.key,
    required this.orderId,
    this.order,
  });

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  Order? _order;
  final List<OrderStatus> _statuses = [
    OrderStatus.pending,
    OrderStatus.confirmed,
    OrderStatus.preparing,
    OrderStatus.readyForPickup,
    OrderStatus.pickedUp,
    OrderStatus.delivered,
  ];

  @override
  void initState() {
    super.initState();
    _loadOrder();
    
    // Mock refreshing order status every 10 seconds
    Future.delayed(const Duration(seconds: 10), () {
      _refreshOrderStatus();
    });
  }

  void _loadOrder() {
    if (widget.order != null) {
      setState(() {
        _order = widget.order;
      });
      return;
    }

    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final order = orderProvider.getOrderById(widget.orderId);
    
    setState(() {
      _order = order;
    });
  }

  void _refreshOrderStatus() {
    if (!mounted) return;

    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final updatedOrder = orderProvider.getOrderById(widget.orderId);
    
    if (updatedOrder != null && updatedOrder.status != _order?.status) {
      setState(() {
        _order = updatedOrder;
      });
    }
    
    // Schedule next refresh if order is not in a final state
    if (mounted && updatedOrder != null && 
        updatedOrder.status != OrderStatus.delivered && 
        updatedOrder.status != OrderStatus.cancelled) {
      Future.delayed(const Duration(seconds: 10), () {
        _refreshOrderStatus();
      });
    }
  }

  int _getCompletedSteps() {
    if (_order == null) return 0;
    
    return _statuses.indexWhere((status) => status == _order!.status) + 1;
  }

  @override
  Widget build(BuildContext context) {
    if (_order == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Order Tracking'),
          backgroundColor: AppTheme.primaryColor,
        ),
        body: const Center(
          child: Text('Order not found'),
        ),
      );
    }

    final completedSteps = _getCompletedSteps();
    
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Order Tracking'),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order info
            OrderCard(
              order: _order!,
              isDetailed: true,
            ),
            
            const SizedBox(height: 24),
            
            // Estimated delivery time
            if (_order!.estimatedDeliveryTime != null) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.access_time,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Estimated Delivery',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            DateFormat('hh:mm a').format(_order!.estimatedDeliveryTime!),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
            ],
            
            // Order status timeline
            const Text(
              'Order Status',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Timeline
            _buildTimeline(completedSteps),
            
            const SizedBox(height: 32),
            
            // Support section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Need Help?',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'If you have any questions or issues with your order, please contact us.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            // Call action
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.primaryColor,
                            side: const BorderSide(color: AppTheme.primaryColor),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.phone, size: 16),
                              SizedBox(width: 8),
                              Text('Call'),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            // Message action
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.primaryColor,
                            side: const BorderSide(color: AppTheme.primaryColor),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.message, size: 16),
                              SizedBox(width: 8),
                              Text('Message'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Back to home button
            Center(
              child: TextButton(
                onPressed: () {
                  context.go('/home');
                },
                child: const Text(
                  'Back to Home',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildTimeline(int completedSteps) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          _buildTimelineItem(
            status: OrderStatus.pending,
            title: 'Order Placed',
            description: 'Your order has been received',
            isCompleted: completedSteps >= 1,
            showConnector: true,
          ),
          _buildTimelineItem(
            status: OrderStatus.confirmed,
            title: 'Order Confirmed',
            description: 'Restaurant has confirmed your order',
            isCompleted: completedSteps >= 2,
            showConnector: true,
          ),
          _buildTimelineItem(
            status: OrderStatus.preparing,
            title: 'Preparing',
            description: 'Your food is being prepared',
            isCompleted: completedSteps >= 3,
            showConnector: true,
          ),
          _buildTimelineItem(
            status: OrderStatus.readyForPickup,
            title: 'Ready for Pickup/Delivery',
            description: 'Your order is ready for pickup or delivery',
            isCompleted: completedSteps >= 4,
            showConnector: true,
          ),
          _buildTimelineItem(
            status: OrderStatus.pickedUp,
            title: 'On the Way',
            description: 'Your order is on the way',
            isCompleted: completedSteps >= 5,
            showConnector: true,
          ),
          _buildTimelineItem(
            status: OrderStatus.delivered,
            title: 'Delivered',
            description: 'Your order has been delivered',
            isCompleted: completedSteps >= 6,
            showConnector: false,
          ),
        ],
      ),
    );
  }
  
  Widget _buildTimelineItem({
    required OrderStatus status,
    required String title,
    required String description,
    required bool isCompleted,
    required bool showConnector,
  }) {
    Color dotColor = isCompleted ? Colors.green : Colors.grey.shade300;
    
    // Current step (in progress)
    if (_order?.status == status) {
      dotColor = AppTheme.primaryColor;
    }
    
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
                child: isCompleted
                    ? const Icon(Icons.check, color: Colors.white, size: 12)
                    : null,
              ),
              if (showConnector)
                Expanded(
                  child: Container(
                    width: 2,
                    color: isCompleted ? Colors.green : Colors.grey.shade300,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isCompleted || _order?.status == status
                          ? Colors.black
                          : Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: isCompleted || _order?.status == status
                          ? Colors.grey.shade700
                          : Colors.grey.shade400,
                    ),
                  ),
                  if (_order?.status == status) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'In Progress',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
} 