import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../models/order.dart';
import '../../providers/order_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/order_card.dart';

class OrderConfirmationScreen extends StatelessWidget {
  final String orderId;
  final Order? order;

  const OrderConfirmationScreen({
    super.key,
    required this.orderId,
    this.order,
  });

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final confirmedOrder = order ?? orderProvider.getOrderById(orderId);

    if (confirmedOrder == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Order Confirmation'),
          backgroundColor: AppTheme.primaryColor,
        ),
        body: const Center(
          child: Text('Order not found'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Order Confirmation'),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Success icon
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                size: 80,
                color: Colors.green,
              ),
            ).animate()
              .fadeIn(duration: 600.ms)
              .scale(delay: 200.ms, duration: 400.ms),
            
            const SizedBox(height: 24),
            
            // Success message
            Text(
              'Order Placed Successfully!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade800,
              ),
              textAlign: TextAlign.center,
            ).animate()
              .fadeIn(delay: 400.ms, duration: 600.ms),
            
            const SizedBox(height: 8),
            
            Text(
              'Your order has been confirmed and is being prepared.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ).animate()
              .fadeIn(delay: 600.ms, duration: 600.ms),
            
            const SizedBox(height: 32),
            
            // Order details
            OrderCard(
              order: confirmedOrder,
              isDetailed: true,
              onTrackOrder: () {
                context.push('/order-tracking/${confirmedOrder.id}', extra: confirmedOrder);
              },
            ).animate()
              .fadeIn(delay: 800.ms, duration: 600.ms)
              .slideY(begin: 0.2, end: 0, delay: 800.ms, duration: 600.ms),
            
            const SizedBox(height: 32),
            
            // Estimated time info
            if (confirmedOrder.estimatedDeliveryTime != null) ...[
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
                            '${confirmedOrder.estimatedDeliveryTime!.hour}:${confirmedOrder.estimatedDeliveryTime!.minute.toString().padLeft(2, '0')}',
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
              ).animate()
                .fadeIn(delay: 1000.ms, duration: 600.ms),
              
              const SizedBox(height: 32),
            ],
            
            // Track order button
            ElevatedButton(
              onPressed: () {
                context.push('/order-tracking/${confirmedOrder.id}', extra: confirmedOrder);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Track Order',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ).animate()
              .fadeIn(delay: 1200.ms, duration: 600.ms),
            
            const SizedBox(height: 16),
            
            // Go to home button
            TextButton(
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
            ).animate()
              .fadeIn(delay: 1400.ms, duration: 600.ms),
          ],
        ),
      ),
    );
  }
} 