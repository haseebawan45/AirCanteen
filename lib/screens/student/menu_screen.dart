import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../models/food_item.dart';
import '../../providers/cart_provider.dart';
import '../../theme/app_theme.dart';
import '../../utils/mock_data.dart';
import '../../widgets/category_card.dart';
import '../../widgets/food_item_card.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<String> _categories;
  late Map<String, List<FoodItem>> _categorizedItems;

  @override
  void initState() {
    super.initState();
    _categories = MockData.foodCategories;
    _tabController = TabController(length: _categories.length, vsync: this);
    _loadCategorizedItems();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadCategorizedItems() {
    _categorizedItems = {};
    for (final category in _categories) {
      _categorizedItems[category] = MockData.getItemsByCategory(category);
    }
  }

  void _navigateToFoodDetail(FoodItem foodItem) {
    context.push('/menu/food/${foodItem.id}', extra: foodItem);
  }

  void _addToCart(FoodItem foodItem) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    cartProvider.addItem(foodItem);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${foodItem.name} added to cart'),
        action: SnackBarAction(
          label: 'VIEW CART',
          onPressed: () {
            context.push('/cart');
          },
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Menu'),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withOpacity(0.7),
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          tabs: _categories.map((category) {
            return Tab(
              text: category,
              icon: Icon(CategoryCard.getIconForCategory(category)),
            );
          }).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _categories.map((category) {
          final items = _categorizedItems[category] ?? [];
          
          if (items.isEmpty) {
            return const Center(
              child: Text('No items available in this category'),
            );
          }
          
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final foodItem = items[index];
              return FoodItemCard(
                foodItem: foodItem,
                onTap: () => _navigateToFoodDetail(foodItem),
                onAddToCart: () => _addToCart(foodItem),
              );
            },
          );
        }).toList(),
      ),
    );
  }
} 