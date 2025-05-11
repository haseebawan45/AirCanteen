import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../models/food_item.dart';
import '../../providers/cart_provider.dart';
import '../../theme/app_theme.dart';
import '../../utils/mock_data.dart';
import '../../widgets/category_card.dart';
import '../../widgets/food_item_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<FoodItem> _allItems = MockData.getFoodItems();
  List<FoodItem> _searchResults = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _searchResults = [];
      });
      return;
    }
    
    setState(() {
      _isSearching = true;
      _searchResults = _allItems.where((item) {
        return item.name.toLowerCase().contains(query) ||
               item.description.toLowerCase().contains(query) ||
               item.category.toLowerCase().contains(query) ||
               item.ingredients.any((ingredient) => 
                 ingredient.toLowerCase().contains(query));
      }).toList();
    });
  }

  void _clearSearch() {
    _searchController.clear();
  }

  void _navigateToFoodDetail(FoodItem foodItem) {
    context.push('/search/food/${foodItem.id}', extra: foodItem);
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
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search for food, ingredients...',
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
            border: InputBorder.none,
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.white),
                    onPressed: _clearSearch,
                  )
                : null,
          ),
          style: const TextStyle(color: Colors.white),
          cursorColor: Colors.white,
        ),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
      ),
      body: _isSearching
          ? _buildSearchResults()
          : _buildSuggestions(),
    );
  }

  Widget _buildSearchResults() {
    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No results found for "${_searchController.text}"',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try different keywords or check for typos',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final foodItem = _searchResults[index];
        return FoodItemCard(
          foodItem: foodItem,
          onTap: () => _navigateToFoodDetail(foodItem),
          onAddToCart: () => _addToCart(foodItem),
        );
      },
    );
  }

  Widget _buildSuggestions() {
    // Get popular categories
    final categories = MockData.foodCategories;
    
    // Get popular items
    final popularItems = MockData.getPopularItems()
        .map((item) => item['name'] as String)
        .toList();
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search prompt
          const Text(
            'What are you looking for today?',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Categories
          const Text(
            'Popular Categories',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: categories.map((category) {
              return GestureDetector(
                onTap: () {
                  _searchController.text = category;
                },
                child: Chip(
                  label: Text(category),
                  avatar: Icon(
                    CategoryCard.getIconForCategory(category),
                    size: 18,
                    color: AppTheme.primaryColor,
                  ),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
              );
            }).toList(),
          ),
          
          const SizedBox(height: 24),
          
          // Popular items
          const Text(
            'Popular Items',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: popularItems.map((item) {
              return GestureDetector(
                onTap: () {
                  _searchController.text = item;
                },
                child: Chip(
                  label: Text(item),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
              );
            }).toList(),
          ),
          
          const SizedBox(height: 24),
          
          // Recent searches (would be implemented with shared preferences in a real app)
          const Text(
            'Recent Searches',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Vegetable Curry'),
            onTap: () {
              _searchController.text = 'Vegetable Curry';
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Breakfast'),
            onTap: () {
              _searchController.text = 'Breakfast';
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Coffee'),
            onTap: () {
              _searchController.text = 'Coffee';
            },
          ),
        ],
      ),
    );
  }
} 