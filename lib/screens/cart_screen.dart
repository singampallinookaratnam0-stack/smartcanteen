import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/cart_item.dart';
import 'checkout_screen.dart';

/// Shopping Cart Page allowing students to review selections and proceed to checkout
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 860;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Food Cart'),
        actions: [
          if (cart.itemCount > 0)
            TextButton.icon(
              style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
              icon: const Icon(Icons.delete_sweep_outlined, size: 20),
              label: const Text('Clear Cart'),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Clear Shopping Cart?'),
                    content: const Text('Are you sure you want to remove all food items from your cart?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                        onPressed: () {
                          cart.clearCart();
                          Navigator.pop(ctx);
                        },
                        child: const Text('Clear All'),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: cart.itemCount == 0
          ? _buildEmptyCart(context)
          : Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: isDesktop
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Cart items list (Expanded)
                            Expanded(
                              flex: 3,
                              child: _buildCartItemList(cart),
                            ),
                            const SizedBox(width: 24),
                            // Order Summary Card (Sidebar)
                            Expanded(
                              flex: 2,
                              child: _buildSummaryCard(context, cart),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            Expanded(
                              child: _buildCartItemList(cart),
                            ),
                            const SizedBox(height: 16),
                            _buildSummaryCard(context, cart),
                          ],
                        ),
                ),
              ),
            ),
    );
  }

  /// Empty Cart state presentation
  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3E0),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.remove_shopping_cart_outlined,
                size: 72,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Your Cart is Empty!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Looks like you haven\'t added any delicious canteen food yet.\nExplore our breakfast, meals, snacks and beverages.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              icon: const Icon(Icons.arrow_back),
              label: const Text('Browse Menu'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// List of items currently in cart
  Widget _buildCartItemList(CartProvider cart) {
    return ListView.builder(
      itemCount: cart.itemList.length,
      itemBuilder: (context, index) {
        final item = cart.itemList[index];
        return CartItemWidget(
          key: ValueKey(item.foodItem.id),
          orderItem: item,
          onIncrement: () => cart.incrementQuantity(item.foodItem.id),
          onDecrement: () => cart.decrementQuantity(item.foodItem.id),
          onRemove: () => cart.removeItem(item.foodItem.id),
        );
      },
    );
  }

  /// Order billing summary card
  Widget _buildSummaryCard(BuildContext context, CartProvider cart) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEEEEE)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(12),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Order Summary',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 16),

          // Total items & quantity
          _buildSummaryRow('Distinct Items', '${cart.itemCount}'),
          const SizedBox(height: 8),
          _buildSummaryRow('Total Quantity', '${cart.totalQuantity} items'),
          const SizedBox(height: 8),
          _buildSummaryRow('Subtotal', '₹${cart.subtotal.toStringAsFixed(0)}'),
          const SizedBox(height: 8),
          _buildSummaryRow('Canteen Packaging & Fee', 'FREE (₹0)', isFree: true),

          const Divider(height: 24, thickness: 1),

          // Grand Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Grand Total',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              Text(
                '₹${cart.totalAmount.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Buttons
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Proceed to Checkout'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CheckoutScreen(),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.restaurant_menu),
              label: const Text('Continue Shopping'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isFree = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: AppTheme.textSecondary),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isFree ? Colors.green : AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }
}
