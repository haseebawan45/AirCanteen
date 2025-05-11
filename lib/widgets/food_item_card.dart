import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../models/food_item.dart';
import '../providers/user_provider.dart';
import '../theme/app_theme.dart';

class FoodItemCard extends StatelessWidget {
  final FoodItem foodItem;
  final VoidCallback? onTap;
  final bool showAddButton;
  final VoidCallback? onAddToCart;
  final bool compact;

  const FoodItemCard({
    super.key,
    required this.foodItem,
    this.onTap,
    this.showAddButton = true,
    this.onAddToCart,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final isFavorite = userProvider.isFavorite(foodItem.id);
    
    // Create a modified food item with the compact property set
    final modifiedFoodItem = foodItem.copyWith(compact: compact);
    
    return GestureDetector(
      onTap: onTap != null ? onTap : () {
        // Based on the current route, determine which path to use
        final currentRoute = GoRouterState.of(context).uri.path;
        if (currentRoute.startsWith('/home')) {
          context.push('/home/food-detail/${foodItem.id}', extra: modifiedFoodItem);
        } else if (currentRoute.startsWith('/menu')) {
          context.push('/menu/food-detail/${foodItem.id}', extra: modifiedFoodItem);
        } else if (currentRoute.startsWith('/search')) {
          context.push('/search/food-detail/${foodItem.id}', extra: modifiedFoodItem);
        } else {
          // Default fallback
          context.push('/home/food-detail/${foodItem.id}', extra: modifiedFoodItem);
        }
      },
      child: Container(
        width: compact ? 180 : double.infinity,
        height: compact ? 210 : 130,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, 3),
              blurRadius: 8,
            ),
          ],
        ),
        child: compact ? _buildCompactCard(context, isFavorite) : _buildStandardCard(context, isFavorite),
      ),
    );
  }

  Widget _buildStandardCard(BuildContext context, bool isFavorite) {
    // Generate a unique ID for this specific card instance
    final uniqueCardId = '${foodItem.id}-${DateTime.now().millisecondsSinceEpoch}-${identityHashCode(this)}';
    
    return Row(
      children: [
        // Food image
        ClipRRect(
          borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
          child: Hero(
            tag: 'food-standard-$uniqueCardId',
            child: CachedNetworkImage(
              imageUrl: foodItem.imageUrl,
              width: 130,
              height: 130,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.grey.shade200,
                child: const Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey.shade200,
                child: const Icon(Icons.error),
              ),
            ),
          ),
        ),
        
        // Food details
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Name and favorite button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        foodItem.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    _buildFavoriteButton(context, isFavorite),
                  ],
                ),
                
                // Description
                Expanded(
                  child: Text(
                    foodItem.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                
                // Price and add button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Price
                    Text(
                      '\$${foodItem.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    
                    // Add button if needed
                    if (showAddButton && onAddToCart != null)
                      _buildAddButton(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCompactCard(BuildContext context, bool isFavorite) {
    // Generate a unique ID for this specific card instance
    final uniqueCardId = '${foodItem.id}-${DateTime.now().millisecondsSinceEpoch}-${identityHashCode(this)}';
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Food image with favorite button overlay
        Stack(
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Hero(
                tag: 'food-compact-$uniqueCardId',
                child: CachedNetworkImage(
                  imageUrl: foodItem.imageUrl,
                  width: 180,
                  height: 120,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey.shade200,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.error),
                  ),
                ),
              ),
            ),
            
            // Favorite button
            Positioned(
              top: 8,
              right: 8,
              child: _buildFavoriteButton(context, isFavorite),
            ),
            
            // Veg/Non-veg indicator
            if (foodItem.isVegetarian)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'VEG',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
        
        // Food details
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Name
                Text(
                  foodItem.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                
                // Rating
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      foodItem.rating.toString(),
                      style: const TextStyle(fontSize: 12),
                    ),
                    Text(
                      ' (${foodItem.reviewCount})',
                      style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                    ),
                  ],
                ),
                
                // Price and add button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Price
                    Text(
                      '\$${foodItem.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    
                    // Add button if needed
                    if (showAddButton && onAddToCart != null)
                      SizedBox(
                        width: 28,
                        height: 28,
                        child: _buildAddButton(),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFavoriteButton(BuildContext context, bool isFavorite) {
    return GestureDetector(
      onTap: () {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.toggleFavorite(foodItem.id);
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          color: isFavorite ? Colors.red : Colors.grey,
          size: 18,
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return Material(
      color: AppTheme.primaryColor,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onAddToCart,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 18,
          ),
        ),
      ),
    );
  }
} 