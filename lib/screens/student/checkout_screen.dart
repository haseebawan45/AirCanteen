import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../models/order.dart';
import '../../models/cart_item.dart';
import '../../providers/cart_provider.dart';
import '../../providers/order_provider.dart';
import '../../providers/user_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/cart_item_card.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String? _selectedDeliveryLocation;
  String _selectedPaymentMethod = 'Credit Card';
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _initDeliveryLocation();
  }

  void _initDeliveryLocation() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.currentUser;
    
    if (user != null && user.deliveryAddresses.isNotEmpty) {
      setState(() {
        _selectedDeliveryLocation = user.deliveryAddresses.first;
      });
    }
  }

  Future<void> _placeOrder() async {
    if (_selectedDeliveryLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a delivery location'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      
      if (userProvider.currentUser == null) {
        throw Exception('User not logged in');
      }
      
      final userId = userProvider.currentUser!.id;
      final cartItems = cartProvider.items;
      final subtotal = cartProvider.totalPrice;
      final deliveryFee = subtotal > 15 ? 0.0 : 2.0;
      final total = subtotal + deliveryFee;
      
      // Place order
      final order = await orderProvider.placeOrder(
        items: cartItems,
        total: total,
        userId: userId,
        deliveryLocation: _selectedDeliveryLocation,
        paymentMethod: _selectedPaymentMethod,
        isPaid: _selectedPaymentMethod != 'Cash',
      );
      
      // Clear cart
      cartProvider.clear();
      
      // Navigate to order confirmation screen
      if (mounted) {
        context.go('/order-confirmation/${order.id}', extra: order);
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to place order: ${error.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.currentUser;
    
    final cartItems = cartProvider.items;
    final subtotal = cartProvider.totalPrice;
    final deliveryFee = subtotal > 15 ? 0.0 : 2.0;
    final total = subtotal + deliveryFee;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: cartItems.isEmpty
          ? _buildEmptyCheckout(context)
          : _buildCheckoutContent(context, cartItems, user, subtotal, deliveryFee, total),
    );
  }

  Widget _buildEmptyCheckout(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Your cart is empty',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add items before checkout',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              context.go('/menu');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Browse Menu',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutContent(
    BuildContext context,
    List<CartItem> cartItems,
    user,
    double subtotal,
    double deliveryFee,
    double total,
  ) {
    return Column(
      children: [
        // Order details
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Order summary section
              const Text(
                'Order Summary',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              // Cart items
              ...cartItems.map((item) => CartItemCard(cartItem: item)),
              
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              
              // Delivery location section
              const Text(
                'Delivery Location',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              if (user?.deliveryAddresses.isEmpty ?? true)
                const Text(
                  'No saved delivery locations. Please add one.',
                  style: TextStyle(color: Colors.red),
                )
              else
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    children: user!.deliveryAddresses.map<Widget>((address) {
                      return RadioListTile<String>(
                        title: Text(address),
                        value: address,
                        groupValue: _selectedDeliveryLocation,
                        onChanged: (value) {
                          setState(() {
                            _selectedDeliveryLocation = value;
                          });
                        },
                        activeColor: AppTheme.primaryColor,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      );
                    }).toList(),
                  ),
                ),
              
              const SizedBox(height: 24),
              
              // Payment method section
              const Text(
                'Payment Method',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    RadioListTile<String>(
                      title: Row(
                        children: [
                          const Icon(Icons.credit_card, color: AppTheme.primaryColor),
                          const SizedBox(width: 8),
                          const Text('Credit Card'),
                          const Spacer(),
                          Image.network(
                            'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5e/Visa_Inc._logo.svg/1200px-Visa_Inc._logo.svg.png',
                            height: 20,
                          ),
                          const SizedBox(width: 8),
                          Image.network(
                            'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2a/Mastercard-logo.svg/1200px-Mastercard-logo.svg.png',
                            height: 20,
                          ),
                        ],
                      ),
                      value: 'Credit Card',
                      groupValue: _selectedPaymentMethod,
                      onChanged: (value) {
                        setState(() {
                          _selectedPaymentMethod = value!;
                        });
                      },
                      activeColor: AppTheme.primaryColor,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    const Divider(height: 1),
                    RadioListTile<String>(
                      title: Row(
                        children: [
                          const Icon(Icons.payments_outlined, color: AppTheme.primaryColor),
                          const SizedBox(width: 8),
                          const Text('Cash on Delivery'),
                        ],
                      ),
                      value: 'Cash',
                      groupValue: _selectedPaymentMethod,
                      onChanged: (value) {
                        setState(() {
                          _selectedPaymentMethod = value!;
                        });
                      },
                      activeColor: AppTheme.primaryColor,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        // Order summary and place order button
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                offset: const Offset(0, -3),
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            children: [
              // Price summary
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Subtotal',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    '\$${subtotal.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Delivery Fee',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    deliveryFee == 0 ? 'FREE' : '\$${deliveryFee.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: deliveryFee == 0 ? Colors.green : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              
              const Divider(),
              const SizedBox(height: 8),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '\$${total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Place order button
              ElevatedButton(
                onPressed: _isProcessing ? null : _placeOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isProcessing
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Place Order',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }
} 