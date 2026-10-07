import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/order.dart';
import '../providers/cart_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/order_status_stepper.dart';
import 'home_screen.dart';

/// Screen for tracking real-time status of orders with interactive simulation tools
class OrderTrackingScreen extends StatefulWidget {
  const OrderTrackingScreen({super.key});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  Timer? _autoTimer;
  bool _isAutoSimulating = false;

  @override
  void dispose() {
    _autoTimer?.cancel();
    super.dispose();
  }

  void _toggleAutoSimulation(CartProvider cart) {
    if (_isAutoSimulating) {
      _autoTimer?.cancel();
      setState(() {
        _isAutoSimulating = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Auto-simulation stopped.'),
          duration: Duration(milliseconds: 1000),
        ),
      );
    } else {
      setState(() {
        _isAutoSimulating = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Auto-simulation started (advancing stage every 4s)...'),
          duration: Duration(milliseconds: 1400),
        ),
      );
      _autoTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }
        final currentOrder = cart.currentOrder;
        if (currentOrder == null || currentOrder.status == OrderStatus.completed) {
          timer.cancel();
          setState(() {
            _isAutoSimulating = false;
          });
        } else {
          cart.advanceOrderStatus();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final order = cart.currentOrder;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Order Tracking'),
        actions: [
          IconButton(
            tooltip: 'Return to Food Menu',
            icon: const Icon(Icons.home_outlined),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: order == null
          ? _buildNoActiveOrder(context)
          : Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 820),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Card with Order ID and Live Status Banner
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF2E2E38), Color(0xFF1E1E24)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(25),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.qr_code_2, color: Colors.white70, size: 28),
                                    const SizedBox(width: 8),
                                    Text(
                                      order.orderId,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        letterSpacing: 1.1,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: _getStatusBadgeColor(order.status),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.circle, size: 8, color: Colors.white),
                                      const SizedBox(width: 6),
                                      Text(
                                        order.status.displayName,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Pickup Time: ${order.pickupTime}',
                              style: const TextStyle(
                                color: Color(0xFFFFB74D),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Student: ${order.studentName} (${order.studentId})',
                              style: const TextStyle(color: Colors.white70, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Order Stages Stepper Card
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFEEEEEE)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(8),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Order Progress Stages',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Click any stage below or use demo simulation controls to test status transitions.',
                              style: TextStyle(fontSize: 12.5, color: AppTheme.textSecondary),
                            ),
                            const SizedBox(height: 20),

                            // Stepper
                            OrderStatusStepper(
                              currentStatus: order.status,
                              onStatusSelected: (selectedStatus) {
                                cart.updateOrderStatus(selectedStatus);
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Demo Simulation Controls (Highlight for mini-project presentation)
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF8E1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFFFE082)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.science_outlined, color: AppTheme.primaryDark),
                                SizedBox(width: 8),
                                Text(
                                  'Mini-Project Viva / Demo Controls',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.primaryDark,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Simulate canteen staff actions to demonstrate the workflow to faculty/evaluators:',
                              style: TextStyle(fontSize: 12.5, color: Color(0xFF5D4037)),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.primaryColor,
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                  ),
                                  onPressed: order.status == OrderStatus.completed
                                      ? null
                                      : () => cart.advanceOrderStatus(),
                                  icon: const Icon(Icons.skip_next, size: 18),
                                  label: const Text('Simulate Next Stage', style: TextStyle(fontSize: 13)),
                                ),
                                OutlinedButton.icon(
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                    foregroundColor: AppTheme.primaryDark,
                                  ),
                                  onPressed: () => _toggleAutoSimulation(cart),
                                  icon: Icon(
                                    _isAutoSimulating ? Icons.stop_circle : Icons.play_circle_outline,
                                    size: 18,
                                  ),
                                  label: Text(
                                    _isAutoSimulating ? 'Stop Auto-Timer' : 'Auto Advance (Every 4s)',
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ),
                                OutlinedButton.icon(
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                    foregroundColor: Colors.brown,
                                  ),
                                  onPressed: () => cart.updateOrderStatus(OrderStatus.orderReceived),
                                  icon: const Icon(Icons.restart_alt, size: 18),
                                  label: const Text('Restart Tracking', style: TextStyle(fontSize: 13)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Canteen Counter Guide Card
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFEEEEEE)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.storefront, color: AppTheme.primaryColor),
                                SizedBox(width: 8),
                                Text(
                                  'Canteen Counter Pickup Directions',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            _buildCounterTile(
                              counter: 'Counter 1 (Main Hall)',
                              items: 'Breakfast & Snacks (Idly, Dosa, Vada, Samosa, Puff, Fries)',
                              icon: Icons.breakfast_dining,
                            ),
                            const SizedBox(height: 8),
                            _buildCounterTile(
                              counter: 'Counter 2 (Beverage Section)',
                              items: 'Meals & Drinks (Veg Meals, Fried Rice, Biryani, Chai, Coffee, Juice)',
                              icon: Icons.lunch_dining,
                            ),
                            const Divider(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Canteen Helpline: Intercom Ext. 204',
                                  style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                                ),
                                Text(
                                  'Total: ₹${order.totalAmount.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Return to Menu Button
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (_) => const HomeScreen()),
                              (route) => false,
                            );
                          },
                          icon: const Icon(Icons.arrow_back),
                          label: const Text('Back to Food Menu / Home'),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildCounterTile({
    required String counter,
    required String items,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9FB),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryColor, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  counter,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13.5,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Text(
                  items,
                  style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusBadgeColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.orderReceived:
        return const Color(0xFF1976D2);
      case OrderStatus.preparing:
        return const Color(0xFFF57C00);
      case OrderStatus.readyForPickup:
        return const Color(0xFF7B1FA2);
      case OrderStatus.completed:
        return const Color(0xFF388E3C);
    }
  }

  Widget _buildNoActiveOrder(BuildContext context) {
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
                Icons.receipt_long_outlined,
                size: 72,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'No Active Orders Found',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'You don\'t have any placed orders currently awaiting pickup.\nBrowse our canteen menu and place an order first.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.restaurant_menu),
              label: const Text('Order Food Now'),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
