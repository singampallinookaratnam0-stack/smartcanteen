import 'food_item.dart';

/// Enum defining the stages in order processing lifecycle
enum OrderStatus {
  orderReceived,
  preparing,
  readyForPickup,
  completed,
}

extension OrderStatusExtension on OrderStatus {
  String get displayName {
    switch (this) {
      case OrderStatus.orderReceived:
        return 'Order Received';
      case OrderStatus.preparing:
        return 'Preparing Food';
      case OrderStatus.readyForPickup:
        return 'Ready for Pickup';
      case OrderStatus.completed:
        return 'Completed';
    }
  }

  String get description {
    switch (this) {
      case OrderStatus.orderReceived:
        return 'Your order has been acknowledged by the canteen kitchen.';
      case OrderStatus.preparing:
        return 'Kitchen staff is actively preparing your hot meal fresh.';
      case OrderStatus.readyForPickup:
        return 'Your meal is packaged! Collect from Counter 1 with Student ID.';
      case OrderStatus.completed:
        return 'Order picked up successfully. Bon Appetit!';
    }
  }

  int get stepIndex {
    switch (this) {
      case OrderStatus.orderReceived:
        return 0;
      case OrderStatus.preparing:
        return 1;
      case OrderStatus.readyForPickup:
        return 2;
      case OrderStatus.completed:
        return 3;
    }
  }
}

/// Represents an individual item and its quantity within an order or cart
class OrderItem {
  final FoodItem foodItem;
  int quantity;

  OrderItem({
    required this.foodItem,
    this.quantity = 1,
  });

  double get totalPrice => foodItem.price * quantity;

  OrderItem copyWith({
    FoodItem? foodItem,
    int? quantity,
  }) {
    return OrderItem(
      foodItem: foodItem ?? this.foodItem,
      quantity: quantity ?? this.quantity,
    );
  }
}

/// Represents a student's placed order with verification and tracking details
class Order {
  final String orderId;
  final List<OrderItem> items;
  final double totalAmount;
  final String studentName;
  final String studentId;
  final String phoneNumber;
  final String pickupTime;
  final String specialInstructions;
  final OrderStatus status;
  final DateTime createdAt;

  const Order({
    required this.orderId,
    required this.items,
    required this.totalAmount,
    required this.studentName,
    required this.studentId,
    required this.phoneNumber,
    required this.pickupTime,
    required this.specialInstructions,
    this.status = OrderStatus.orderReceived,
    required this.createdAt,
  });

  Order copyWith({
    String? orderId,
    List<OrderItem>? items,
    double? totalAmount,
    String? studentName,
    String? studentId,
    String? phoneNumber,
    String? pickupTime,
    String? specialInstructions,
    OrderStatus? status,
    DateTime? createdAt,
  }) {
    return Order(
      orderId: orderId ?? this.orderId,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      studentName: studentName ?? this.studentName,
      studentId: studentId ?? this.studentId,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      pickupTime: pickupTime ?? this.pickupTime,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
