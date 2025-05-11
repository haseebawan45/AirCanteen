import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../models/order.dart';
import '../../providers/order_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/order_card.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    
    // Load orders
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);
      orderProvider.loadOrders();
    });
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Order History'),
        backgroundColor: AppTheme.primaryColor,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Active'),
            Tab(text: 'Completed'),
            Tab(text: 'All'),
          ],
        ),
      ),
      body: Consumer<OrderProvider>(
        builder: (context, orderProvider, child) {
          final activeOrders = orderProvider.activeOrders;
          final completedOrders = orderProvider.orders.where(
            (order) => order.status == OrderStatus.delivered || 
                      order.status == OrderStatus.cancelled
          ).toList();
          final allOrders = orderProvider.orders;
          
          return TabBarView(
            controller: _tabController,
            children: [
              // Active orders tab
              _buildOrderList(
                context, 
                activeOrders,
                emptyMessage: 'No active orders',
              ),
              
              // Completed orders tab
              _buildOrderList(
                context, 
                completedOrders,
                emptyMessage: 'No completed orders',
              ),
              
              // All orders tab
              _buildOrderList(
                context, 
                allOrders,
                emptyMessage: 'No order history',
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildOrderList(
    BuildContext context,
    List<Order> orders, {
    required String emptyMessage,
  }) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              emptyMessage,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return OrderCard(
          order: order,
          onTrackOrder: order.status != OrderStatus.delivered && 
                       order.status != OrderStatus.cancelled
              ? () => context.push('/order-tracking/${order.id}', extra: order)
              : null,
        );
      },
    );
  }
} 