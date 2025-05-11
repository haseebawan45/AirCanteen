// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../models/order.dart';
import '../../providers/order_provider.dart';
import '../../providers/user_provider.dart';
import '../../theme/app_theme.dart';
import '../../utils/mock_data.dart';
import '../../widgets/order_card.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  void initState() {
    super.initState();
    // Load active orders
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);
      orderProvider.loadActiveOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.currentUser;
    
    if (user == null || !user.isAdmin) {
      return const Scaffold(
        body: Center(
          child: Text('Access denied. Admin privileges required.'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting
            Text(
              'Welcome, ${user.name}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 4),
            
            Text(
              'Here\'s what\'s happening today',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // KPI cards
            _buildKpiSection(),
            
            const SizedBox(height: 24),
            
            // Sales chart
            _buildSalesChartSection(),
            
            const SizedBox(height: 24),
            
            // Active orders
            const Text(
              'Active Orders',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Orders list
            _buildActiveOrdersList(),
          ],
        ),
      ),
    );
  }

  Widget _buildKpiSection() {
    // Get mock data for KPIs
    final salesData = MockData.getSalesData();
    final popularItems = MockData.getPopularItems();
    final todaySales = salesData.isNotEmpty ? salesData.last['sales'] as int : 0;
    final totalOrders = popularItems.fold(0, (sum, item) => sum + (item['orders'] as int));
    
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildKpiCard(
          title: 'Total Sales Today',
          value: '\$${todaySales.toStringAsFixed(2)}',
          icon: Icons.attach_money,
          color: Colors.green,
        ),
        _buildKpiCard(
          title: 'New Orders',
          value: '$totalOrders',
          icon: Icons.shopping_cart,
          color: AppTheme.primaryColor,
        ),
        _buildKpiCard(
          title: 'Pending Deliveries',
          value: '5',
          icon: Icons.delivery_dining,
          color: Colors.orange,
        ),
        _buildKpiCard(
          title: 'Total Items',
          value: '${MockData.getFoodItems().length}',
          icon: Icons.restaurant,
          color: Colors.purple,
        ),
      ],
    );
  }

  Widget _buildKpiCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 3),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSalesChartSection() {
    final salesData = MockData.getSalesData();
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 3),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Weekly Sales',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Sales performance of the past week',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 5000,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: Colors.black.withOpacity(0.8),
                    tooltipPadding: const EdgeInsets.all(8),
                    tooltipMargin: 8,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final sales = salesData[groupIndex]['sales'] as int;
                      return BarTooltipItem(
                        '\$$sales',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < salesData.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              salesData[index]['day'] as String,
                              style: const TextStyle(fontSize: 12),
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                      reservedSize: 30,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Text(
                            '\$${value.toInt()}',
                            style: const TextStyle(fontSize: 10),
                          ),
                        );
                      },
                      reservedSize: 40,
                    ),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                barGroups: salesData.asMap().entries.map((entry) {
                  final index = entry.key;
                  final data = entry.value;
                  final sales = data['sales'] as int;
                  
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: sales.toDouble(),
                        color: AppTheme.primaryColor,
                        width: 16,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveOrdersList() {
    return Consumer<OrderProvider>(
      builder: (context, orderProvider, child) {
        final activeOrders = orderProvider.activeOrders;
        
        if (activeOrders.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Icon(
                    Icons.receipt_long,
                    size: 80,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No active orders',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: activeOrders.length,
          itemBuilder: (context, index) {
            final order = activeOrders[index];
            return OrderCard(
              order: order,
              isDetailed: true,
              onUpdateStatus: () {
                _showUpdateOrderStatusDialog(context, order);
              },
            );
          },
        );
      },
    );
  }

  void _showUpdateOrderStatusDialog(BuildContext context, Order order) {
    final statuses = [
      OrderStatus.pending,
      OrderStatus.confirmed,
      OrderStatus.preparing,
      OrderStatus.readyForPickup,
      OrderStatus.pickedUp,
      OrderStatus.delivered,
    ];
    
    OrderStatus selectedStatus = order.status;
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Update Order Status'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Order #${order.id.length > 6 ? order.id.substring(order.id.length - 6) : order.id}'),
                const SizedBox(height: 16),
                const Text('Current Status:'),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: order.statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Text(
                    order.statusText,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: order.statusColor,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text('New Status:'),
                const SizedBox(height: 8),
                DropdownButtonFormField<OrderStatus>(
                  value: selectedStatus,
                  onChanged: (newStatus) {
                    if (newStatus != null) {
                      setState(() {
                        selectedStatus = newStatus;
                      });
                    }
                  },
                  items: statuses.map((status) {
                    final order = Order(
                      id: 'temp',
                      items: [],
                      orderTime: DateTime.now(),
                      status: status,
                      total: 0,
                      userId: 'temp',
                    );
                    
                    return DropdownMenuItem<OrderStatus>(
                      value: status,
                      child: Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: order.statusColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(order.statusText),
                        ],
                      ),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Update order status
                  final orderProvider = Provider.of<OrderProvider>(context, listen: false);
                  orderProvider.updateOrderStatus(order.id, selectedStatus);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Update'),
              ),
            ],
          );
        },
      ),
    );
  }
} 