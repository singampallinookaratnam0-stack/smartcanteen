import 'package:flutter/material.dart';
import '../models/order.dart';
import '../theme/app_theme.dart';

/// Reusable widget representing an individual item entry in the shopping cart
class CartItemWidget extends StatelessWidget {
  final OrderItem orderItem;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  const CartItemWidget({
    super.key,
    required this.orderItem,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  Widget _buildVegIndicator(bool isVeg) {
    final color = isVeg ? AppTheme.vegColor : AppTheme.nonVegColor;
    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 1.5),
        borderRadius: BorderRadius.circular(3),
      ),
      alignment: Alignment.center,
      child: Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final food = orderItem.foodItem;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEEEEEE)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Food Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: 68,
              height: 68,
              child: Image.network(
                food.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (ctx, err, stack) => Container(
                  color: const Color(0xFFFFF3E0),
                  child: const Icon(Icons.fastfood, color: AppTheme.primaryColor),
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Food Info & Unit Price
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildVegIndicator(food.isVeg),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        food.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '₹${food.price.toStringAsFixed(0)} each',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Subtotal: ₹${orderItem.totalPrice.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ),

          // Quantity Modifier Pill
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E0),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.primaryColor.withAlpha(60)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  visualDensity: VisualDensity.compact,
                  iconSize: 16,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
                  icon: const Icon(Icons.remove, color: AppTheme.primaryColor),
                  onPressed: onDecrement,
                  tooltip: 'Decrease quantity',
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Text(
                    '${orderItem.quantity}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryDark,
                    ),
                  ),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  iconSize: 16,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
                  icon: const Icon(Icons.add, color: AppTheme.primaryColor),
                  onPressed: onIncrement,
                  tooltip: 'Increase quantity',
                ),
              ],
            ),
          ),

          const SizedBox(width: 6),

          // Delete Button
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
            onPressed: onRemove,
            tooltip: 'Remove from cart',
          ),
        ],
      ),
    );
  }
}
