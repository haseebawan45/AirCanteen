import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../models/order.dart';
import '../../providers/order_provider.dart';
import '../../providers/user_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/order_card.dart';

class OrderManagementScreen extends StatefulWidget {
  const OrderManagementScreen({super.key});

  @override
  State<OrderManagementScreen> createState() => _OrderManagementScreenState();
}

class _OrderManagementScreenState extends State<OrderManagementScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = ['All Orders', 'Pending', 'Confirmed', 'Preparing', 'Ready', 'Delivered', 'Cancelled'];
  final TextEditingController _searchController = TextEditingController();
  List<Order> _filteredOrders = [];
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(_onTabChanged);
    _searchController.addListener(_onSearchChanged);
    
    // Load orders
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);
      orderProvider.loadOrders();
      orderProvider.loadActiveOrders();
      _filterOrders();
    });
  }
  
  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) {
      _filterOrders();
    }
  }

  void _onSearchChanged() {
    _filterOrders();
  }

  void _filterOrders() {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final allOrders = [...orderProvider.orders, ...orderProvider.activeOrders];
    final searchQuery = _searchController.text.toLowerCase();
    
    setState(() {
      // Filter by tab/status
      _filteredOrders = allOrders.where((order) {
        // Filter by tab selection
        if (_tabController.index > 0) {
          final targetStatus = _getStatusForTabIndex(_tabController.index);
          if (order.status != targetStatus) {
            return false;
          }
        }
        
        // Filter by search query (order ID or customer ID)
        if (searchQuery.isNotEmpty) {
          return order.id.toLowerCase().contains(searchQuery) || 
                 order.userId.toLowerCase().contains(searchQuery);
        }
        
        return true;
      }).toList();
      
      // Sort by order time (newest first)
      _filteredOrders.sort((a, b) => b.orderTime.compareTo(a.orderTime));
    });
  }
  
  OrderStatus _getStatusForTabIndex(int index) {
    switch (index) {
      case 1: return OrderStatus.pending;
      case 2: return OrderStatus.confirmed;
      case 3: return OrderStatus.preparing;
      case 4: return OrderStatus.readyForPickup;
      case 5: return OrderStatus.delivered;
      case 6: return OrderStatus.cancelled;
      default: return OrderStatus.pending;
    }
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
        title: const Text('Order Management'),
        backgroundColor: AppTheme.primaryColor,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
        ),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by order ID or customer ID...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          
          // Order statistics
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildOrderStatistics(),
          ),
          
          const SizedBox(height: 16),
          
          // Orders list
          Expanded(
            child: Consumer<OrderProvider>(
              builder: (context, orderProvider, child) {
                // Refresh filtered orders when provider data changes
                if (_filteredOrders.isEmpty) {
                  _filterOrders();
                }
                
                if (_filteredOrders.isEmpty) {
                  return _buildEmptyState();
                }
                
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _filteredOrders.length,
                  itemBuilder: (context, index) {
                    final order = _filteredOrders[index];
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
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildOrderStatistics() {
    final orderProvider = Provider.of<OrderProvider>(context);
    final allOrders = [...orderProvider.orders, ...orderProvider.activeOrders];
    
    // Calculate stats
    final totalOrders = allOrders.length;
    final pendingOrders = allOrders.where((o) => o.status == OrderStatus.pending).length;
    final processingOrders = allOrders.where((o) => 
      o.status == OrderStatus.confirmed || 
      o.status == OrderStatus.preparing || 
      o.status == OrderStatus.readyForPickup
    ).length;
    final completedOrders = allOrders.where((o) => o.status == OrderStatus.delivered).length;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatCard('Total', totalOrders, Colors.blue),
        _buildStatCard('Pending', pendingOrders, Colors.orange),
        _buildStatCard('Processing', processingOrders, Colors.amber),
        _buildStatCard('Completed', completedOrders, Colors.green),
      ],
    );
  }
  
  Widget _buildStatCard(String title, int value, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value.toString(),
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    String message = 'No orders found';
    
    if (_searchController.text.isNotEmpty) {
      message = 'No orders found for "${_searchController.text}"';
    } else if (_tabController.index > 0) {
      message = 'No ${_tabs[_tabController.index].toLowerCase()} orders';
    }
    
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
            message,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
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
      OrderStatus.cancelled,
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
                Text(
                  'Order #${order.id.substring(order.id.length - 6)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  DateFormat('MMM dd, yyyy - hh:mm a').format(order.orderTime),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Order details summary
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${order.items.length} items • \$${order.total.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      if (order.deliveryLocation != null)
                        Text('Delivery: ${order.deliveryLocation}'),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text('Payment: ${order.paymentMethod ?? 'N/A'}'),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: order.isPaid ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              order.isPaid ? 'Paid' : 'Unpaid',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: order.isPaid ? Colors.green : Colors.orange,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
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
                    final statusOrder = Order(
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
                              color: statusOrder.statusColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(statusOrder.statusText),
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
                  _filterOrders(); // Refresh filtered list
                  Navigator.pop(context);
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Order status updated to ${Order(
                        id: '',
                        items: [],
                        orderTime: DateTime.now(),
                        status: selectedStatus,
                        total: 0,
                        userId: '',
                      ).statusText}'),
                      backgroundColor: Colors.green,
                    ),
                  );
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