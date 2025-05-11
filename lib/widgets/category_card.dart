import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CategoryCard extends StatelessWidget {
  final String category;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData? icon;

  const CategoryCard({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, 3),
              blurRadius: 6,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey.shade600,
                size: 18,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              category,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? Colors.white : Colors.grey.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Method to get appropriate icon for a category
  static IconData getIconForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'breakfast':
        return Icons.breakfast_dining;
      case 'lunch':
        return Icons.lunch_dining;
      case 'dinner':
        return Icons.dinner_dining;
      case 'snacks':
        return Icons.fastfood;
      case 'beverages':
        return Icons.local_drink;
      case 'desserts':
        return Icons.cake;
      default:
        return Icons.restaurant;
    }
  }

  // Get color for a category
  static Color getColorForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'breakfast':
        return Colors.orange;
      case 'lunch':
        return AppTheme.primaryColor;
      case 'dinner':
        return Colors.purple;
      case 'snacks':
        return AppTheme.snacksColor;
      case 'beverages':
        return AppTheme.beveragesColor;
      case 'desserts':
        return AppTheme.dessertsColor;
      default:
        return AppTheme.secondaryColor;
    }
  }
} 