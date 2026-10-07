import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/food_item.dart';
import '../models/order.dart';

/// Provider managing shopping cart state and active order tracking
class CartProvider extends ChangeNotifier {
  // In-memory map of food item ID -> OrderItem
  final Map<String, OrderItem> _items = {};

  // Currently active order for demo & tracking
  Order? _currentOrder;

  /// Map of all current cart items
  Map<String, OrderItem> get items => Map.unmodifiable(_items);

  /// List of cart items for easy ListView rendering
  List<OrderItem> get itemList => _items.values.toList();

  /// Total distinct items in cart
  int get itemCount => _items.length;

  /// Total cumulative food units in cart
  int get totalQuantity {
    return _items.values.fold(0, (sum, item) => sum + item.quantity);
  }

  /// Total cost of items in cart
  double get subtotal {
    return _items.values.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  /// Campus tax or service charge (₹0 for college canteen)
  double get taxAmount => 0.0;

  /// Final amount payable
  double get totalAmount => subtotal + taxAmount;

  /// Check whether a food item is already in the cart
  bool isItemInCart(String foodId) => _items.containsKey(foodId);

  /// Get the quantity of a specific food item in the cart
  int getItemQuantity(String foodId) => _items[foodId]?.quantity ?? 0;

  /// Add a food item or increment its quantity if already present
  void addItem(FoodItem food) {
    if (_items.containsKey(food.id)) {
      _items[food.id]!.quantity += 1;
    } else {
      _items[food.id] = OrderItem(foodItem: food, quantity: 1);
    }
    notifyListeners();
  }

  /// Increment quantity of an existing cart item
  void incrementQuantity(String foodId) {
    if (_items.containsKey(foodId)) {
      _items[foodId]!.quantity += 1;
      notifyListeners();
    }
  }

  /// Decrement quantity or remove item if quantity drops to zero
  void decrementQuantity(String foodId) {
    if (!_items.containsKey(foodId)) return;

    if (_items[foodId]!.quantity > 1) {
      _items[foodId]!.quantity -= 1;
    } else {
      _items.remove(foodId);
    }
    notifyListeners();
  }

  /// Completely remove an item regardless of its quantity
  void removeItem(String foodId) {
    _items.remove(foodId);
    notifyListeners();
  }

  /// Empty all items from the cart
  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  // --- ORDER LIFECYCLE MANAGEMENT ---

  /// Currently active order being tracked
  Order? get currentOrder => _currentOrder;

  /// True if a user has placed an order that can be tracked
  bool get hasActiveOrder => _currentOrder != null;

  /// Converts the current cart items into a confirmed Order
  Order placeOrder({
    required String studentName,
    required String studentId,
    required String phoneNumber,
    required String pickupTime,
    required String specialInstructions,
  }) {
    final now = DateTime.now();
    final randomSuffix = Random().nextInt(900) + 100;
    final year = now.year.toString();
    final month = now.month.toString().padLeft(2, '0');
    final day = now.day.toString().padLeft(2, '0');
    final generatedOrderId = 'SC$year$month$day$randomSuffix';

    // Create confirmed order snapshot
    final order = Order(
      orderId: generatedOrderId,
      items: itemList.map((e) => e.copyWith()).toList(),
      totalAmount: totalAmount,
      studentName: studentName.trim(),
      studentId: studentId.trim().toUpperCase(),
      phoneNumber: phoneNumber.trim(),
      pickupTime: pickupTime,
      specialInstructions: specialInstructions.trim(),
      status: OrderStatus.orderReceived,
      createdAt: now,
    );

    _currentOrder = order;

    // Clear cart after placing order
    _items.clear();
    notifyListeners();

    return order;
  }

  /// Update the active order's preparation status
  void updateOrderStatus(OrderStatus newStatus) {
    if (_currentOrder != null) {
      _currentOrder = _currentOrder!.copyWith(status: newStatus);
      notifyListeners();
    }
  }

  /// Cycle forward to the next order status (for demo presentation)
  void advanceOrderStatus() {
    if (_currentOrder == null) return;

    switch (_currentOrder!.status) {
      case OrderStatus.orderReceived:
        updateOrderStatus(OrderStatus.preparing);
        break;
      case OrderStatus.preparing:
        updateOrderStatus(OrderStatus.readyForPickup);
        break;
      case OrderStatus.readyForPickup:
        updateOrderStatus(OrderStatus.completed);
        break;
      case OrderStatus.completed:
        // Already at last stage
        break;
    }
  }

  /// Reset active order to start fresh
  void resetCurrentOrder() {
    _currentOrder = null;
    notifyListeners();
  }
}
