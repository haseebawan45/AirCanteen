import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../models/food_item.dart';
import '../../providers/cart_provider.dart';
import '../../providers/user_provider.dart';
import '../../theme/app_theme.dart';
import '../../utils/mock_data.dart';
import '../../widgets/category_card.dart';
import '../../widgets/food_item_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<FoodItem> _featuredItems;
  late List<String> _categories;
  String _selectedCategory = 'All';
  late List<FoodItem> _categoryItems;

  @override
  void initState() {
    super.initState();
    _featuredItems = MockData.getFeaturedItems();
    _categories = ['All', ...MockData.foodCategories];
    _updateCategoryItems();
  }

  void _updateCategoryItems() {
    if (_selectedCategory == 'All') {
      _categoryItems = MockData.getFoodItems();
    } else {
      _categoryItems = MockData.getItemsByCategory(_selectedCategory);
    }
  }

  void _selectCategory(String category) {
    setState(() {
      _selectedCategory = category;
      _updateCategoryItems();
    });
  }

  void _navigateToFoodDetail(FoodItem foodItem) {
    context.push('/home/food-detail/${foodItem.id}', extra: foodItem);
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
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.currentUser;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              floating: true,
              backgroundColor: AppTheme.backgroundColor,
              elevation: 0,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello, ${user?.name.split(' ')[0] ?? 'Guest'}',
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Text(
                    'What would you like to eat?',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              actions: [
                // Profile avatar
                GestureDetector(
                  onTap: () {
                    context.go('/profile');
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 16),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.shade200,
                      image: user?.avatar != null
                          ? DecorationImage(
                              image: NetworkImage(user!.avatar!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: user?.avatar == null
                        ? const Icon(Icons.person, color: Colors.grey)
                        : null,
                  ),
                ),
              ],
            ),

            // Content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Featured Items Section
                    const Text(
                      'Featured Items',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ).animate()
                      .fadeIn(duration: 500.ms)
                      .slideX(begin: -0.2, end: 0, duration: 500.ms),
                    
                    const SizedBox(height: 16),
                    
                    // Featured Items Horizontal List
                    SizedBox(
                      height: 220,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _featuredItems.length,
                        itemBuilder: (context, index) {
                          final foodItem = _featuredItems[index];
                          return Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: FoodItemCard(
                              foodItem: foodItem,
                              compact: true,
                              onTap: () => _navigateToFoodDetail(foodItem),
                              onAddToCart: () => _addToCart(foodItem),
                            ),
                          ).animate(delay: (100 * index).ms)
                            .fadeIn(duration: 500.ms)
                            .slideX(begin: 0.2, end: 0, duration: 500.ms);
                        },
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Categories Section
                    const Text(
                      'Categories',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ).animate()
                      .fadeIn(delay: 300.ms, duration: 500.ms)
                      .slideX(begin: -0.2, end: 0, delay: 300.ms, duration: 500.ms),
                    
                    const SizedBox(height: 16),
                    
                    // Categories Horizontal List
                    SizedBox(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _categories.length,
                        itemBuilder: (context, index) {
                          final category = _categories[index];
                          final isSelected = category == _selectedCategory;
                          final icon = category == 'All'
                              ? Icons.restaurant
                              : CategoryCard.getIconForCategory(category);
                              
                          return CategoryCard(
                            category: category,
                            isSelected: isSelected,
                            onTap: () => _selectCategory(category),
                            icon: icon,
                          ).animate(delay: (50 * index).ms)
                            .fadeIn(duration: 400.ms);
                        },
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // Category Items Grid
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final foodItem = _categoryItems[index];
                    return FoodItemCard(
                      foodItem: foodItem,
                      compact: true,
                      onTap: () => _navigateToFoodDetail(foodItem),
                      onAddToCart: () => _addToCart(foodItem),
                    ).animate(delay: (50 * index).ms)
                      .fadeIn(duration: 500.ms);
                  },
                  childCount: _categoryItems.length,
                ),
              ),
            ),
            
            // Bottom padding
            const SliverToBoxAdapter(
              child: SizedBox(height: 80),
            ),
          ],
        ),
      ),
    );
  }
} 