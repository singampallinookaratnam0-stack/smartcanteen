import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Reusable category filter chip widget with icon and selected state animation
class CategoryChipWidget extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChipWidget({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Breakfast':
        return Icons.breakfast_dining;
      case 'Meals':
        return Icons.lunch_dining;
      case 'Snacks':
        return Icons.fastfood;
      case 'Beverages':
        return Icons.local_cafe;
      case 'All':
      default:
        return Icons.restaurant_menu;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primaryColor : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isSelected ? AppTheme.primaryColor : const Color(0xFFE0E0E0),
              width: 1.2,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppTheme.primaryColor.withAlpha(70),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    )
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withAlpha(8),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    )
                  ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _getCategoryIcon(label),
                size: 18,
                color: isSelected ? Colors.white : AppTheme.primaryColor,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : AppTheme.textPrimary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
