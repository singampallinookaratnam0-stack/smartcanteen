import 'package:flutter/material.dart';
import '../models/order.dart';
import '../theme/app_theme.dart';

/// Interactive visual stepper component displaying the 4 stages of order fulfillment
class OrderStatusStepper extends StatelessWidget {
  final OrderStatus currentStatus;
  final ValueChanged<OrderStatus>? onStatusSelected;

  const OrderStatusStepper({
    super.key,
    required this.currentStatus,
    this.onStatusSelected,
  });

  static const List<Map<String, dynamic>> _steps = [
    {
      'status': OrderStatus.orderReceived,
      'title': 'Order Received',
      'subtitle': 'Canteen system confirmed your order details',
      'icon': Icons.receipt_long,
    },
    {
      'status': OrderStatus.preparing,
      'title': 'Preparing Food',
      'subtitle': 'Kitchen staff is actively preparing your hot meal',
      'icon': Icons.soup_kitchen,
    },
    {
      'status': OrderStatus.readyForPickup,
      'title': 'Ready for Pickup',
      'subtitle': 'Food is packaged! Collect from Counter 1 with Student ID',
      'icon': Icons.shopping_bag_outlined,
    },
    {
      'status': OrderStatus.completed,
      'title': 'Completed',
      'subtitle': 'Order has been safely collected. Have a great day!',
      'icon': Icons.done_all,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final currentIdx = currentStatus.stepIndex;

    return Column(
      children: List.generate(_steps.length, (index) {
        final step = _steps[index];
        final stepStatus = step['status'] as OrderStatus;
        final isPassed = index < currentIdx;
        final isCurrent = index == currentIdx;
        final isLast = index == _steps.length - 1;

        Color circleColor;
        Widget indicatorContent;

        if (isPassed) {
          circleColor = Colors.green;
          indicatorContent = const Icon(Icons.check, color: Colors.white, size: 18);
        } else if (isCurrent) {
          circleColor = AppTheme.primaryColor;
          indicatorContent = const Icon(Icons.sync, color: Colors.white, size: 18);
        } else {
          circleColor = const Color(0xFFE0E0E0);
          indicatorContent = Text(
            '${index + 1}',
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          );
        }

        return InkWell(
          onTap: onStatusSelected != null ? () => onStatusSelected!(stepStatus) : null,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Timeline column: Indicator node + connecting vertical line
                Column(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: circleColor,
                        shape: BoxShape.circle,
                        boxShadow: isCurrent
                            ? [
                                BoxShadow(
                                  color: AppTheme.primaryColor.withAlpha(90),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                )
                              ]
                            : [],
                      ),
                      alignment: Alignment.center,
                      child: indicatorContent,
                    ),
                    if (!isLast)
                      Container(
                        width: 3,
                        height: 54,
                        margin: const EdgeInsets.symmetric(vertical: 2),
                        color: isPassed ? Colors.green : const Color(0xFFE0E0E0),
                      ),
                  ],
                ),
                const SizedBox(width: 16),

                // Step Description Details
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4.0, bottom: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              step['title'] as String,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: isCurrent ? FontWeight.bold : FontWeight.w600,
                                color: isCurrent
                                    ? AppTheme.primaryColor
                                    : (isPassed ? Colors.green.shade800 : AppTheme.textSecondary),
                              ),
                            ),
                            if (isCurrent) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryColor.withAlpha(25),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  'IN PROGRESS',
                                  style: TextStyle(
                                    color: AppTheme.primaryColor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ],
                            if (isPassed) ...[
                              const SizedBox(width: 8),
                              const Icon(Icons.check_circle_outline, color: Colors.green, size: 16),
                            ],
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          step['subtitle'] as String,
                          style: TextStyle(
                            fontSize: 13,
                            color: isCurrent ? AppTheme.textPrimary : AppTheme.textSecondary,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
