import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../theme/app_theme.dart';
import 'confirmation_screen.dart';

/// Checkout and Student Information Form Screen with strict input validation
class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _studentIdController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();

  String _selectedPickupTime = '10-15 mins (Ready Soon)';
  bool _isSubmitting = false;

  final List<String> _pickupSlots = [
    '10-15 mins (Ready Soon)',
    '12:30 PM (Lunch Break)',
    '01:15 PM (Afternoon Shift)',
    '03:45 PM (Break Time)',
    '05:00 PM (Evening Snack)',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _studentIdController.dispose();
    _phoneController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  Future<void> _handlePlaceOrder(CartProvider cart) async {
    // Validate form inputs
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text('Please correct the errors in the form before placing your order.'),
        ),
      );
      return;
    }

    if (cart.itemList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your cart is empty. Please add items before checking out.'),
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    // Simulate quick order processing latency (800ms)
    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;

    final createdOrder = cart.placeOrder(
      studentName: _nameController.text,
      studentId: _studentIdController.text,
      phoneNumber: _phoneController.text,
      pickupTime: _selectedPickupTime,
      specialInstructions: _instructionsController.text.isEmpty ? 'None' : _instructionsController.text,
    );

    setState(() {
      _isSubmitting = false;
    });

    // Navigate to confirmation page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ConfirmationScreen(order: createdOrder),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 860;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout & Order Details'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: isDesktop
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Form on left
                      Expanded(
                        flex: 3,
                        child: _buildOrderForm(cart),
                      ),
                      const SizedBox(width: 28),
                      // Mini cart overview on right
                      Expanded(
                        flex: 2,
                        child: _buildOrderSummaryMini(cart),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      _buildOrderSummaryMini(cart),
                      const SizedBox(height: 20),
                      _buildOrderForm(cart),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderForm(CartProvider cart) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEEEEE)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.badge_outlined, color: AppTheme.primaryColor),
                SizedBox(width: 8),
                Text(
                  'Student Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Please provide accurate details for food pickup identification.',
              style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 20),

            // Student Full Name
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Student Full Name *',
                hintText: 'e.g. Rahul Sharma',
                prefixIcon: Icon(Icons.person_outline),
              ),
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Student name is required';
                }
                if (value.trim().length < 2) {
                  return 'Name must contain at least 2 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Student ID / Roll Number
            TextFormField(
              controller: _studentIdController,
              decoration: const InputDecoration(
                labelText: 'Student ID / Roll Number *',
                hintText: 'e.g. 21BCE1042 or CS202409',
                prefixIcon: Icon(Icons.school_outlined),
              ),
              textCapitalization: TextCapitalization.characters,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Student ID / Roll Number cannot be empty';
                }
                if (value.trim().length < 3) {
                  return 'Please enter a valid Student ID (min 3 characters)';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Phone Number
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              decoration: const InputDecoration(
                labelText: 'Phone Number (10 digits) *',
                hintText: 'e.g. 9876543210',
                prefixIcon: Icon(Icons.phone_outlined),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Phone number is required';
                }
                final cleaned = value.replaceAll(RegExp(r'\D'), '');
                if (cleaned.length != 10) {
                  return 'Phone number must contain exactly 10 digits';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Canteen Pickup Time
            const Text(
              'Preferred Pickup Time Slot *',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedPickupTime,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.access_time),
              ),
              items: _pickupSlots.map((slot) {
                return DropdownMenuItem<String>(
                  value: slot,
                  child: Text(slot),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    _selectedPickupTime = val;
                  });
                }
              },
            ),
            const SizedBox(height: 16),

            // Special Instructions
            TextFormField(
              controller: _instructionsController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Special Instructions / Notes (Optional)',
                hintText: 'e.g. Extra spicy sambar, no sugar, separate packing...',
                prefixIcon: Icon(Icons.notes_outlined),
              ),
            ),
            const SizedBox(height: 24),

            // Payment method note
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFA5D6A7)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.payment, color: Colors.green, size: 22),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Payment Mode: Pay at Canteen Counter / UPI on Pickup. (Mini-project Demo: No online gateway needed)',
                      style: TextStyle(
                        fontSize: 12.5,
                        color: Color(0xFF1B5E20),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _isSubmitting ? null : () => _handlePlaceOrder(cart),
                icon: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Icon(Icons.check_circle_outline),
                label: Text(
                  _isSubmitting ? 'Placing Order...' : 'Place Order (₹${cart.totalAmount.toStringAsFixed(0)})',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummaryMini(CartProvider cart) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Items Summary',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: cart.itemList.length,
            separatorBuilder: (_, __) => const Divider(height: 16),
            itemBuilder: (context, index) {
              final item = cart.itemList[index];
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${item.foodItem.name} × ${item.quantity}',
                      style: const TextStyle(fontSize: 14, color: AppTheme.textPrimary),
                    ),
                  ),
                  Text(
                    '₹${item.totalPrice.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              );
            },
          ),
          const Divider(height: 24, thickness: 1.2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Payable',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                '₹${cart.totalAmount.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
