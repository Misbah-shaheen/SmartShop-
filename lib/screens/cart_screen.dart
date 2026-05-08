// screens/cart_screen.dart
// Concept: StreamBuilder, Stream, Provider, ListView.builder, real-time updates

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../streams/cart_stream.dart';
import '../widgets/cart_item_tile.dart';
import '../utils/constants.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: Text('My Cart', style: AppTextStyles.h3),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Consumer<CartProvider>(builder: (_, cart, __) {
            if (cart.isEmpty) return const SizedBox.shrink();
            return TextButton(
              onPressed: () => _confirmClear(context, cart),
              child: Text('Clear all',
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.error, fontWeight: FontWeight.w600)),
            );
          }),
        ],
      ),

      // Concept: StreamBuilder — listens to real-time CartStream
      body: StreamBuilder<List<CartItem>>(
        stream: CartStream().cartStream,
        initialData: context.read<CartProvider>().items,
        builder: (context, snap) {
          final items = snap.data ?? [];
          if (items.isEmpty) return _empty(context);
          return Column(children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
                itemCount: items.length,
                // Concept: ListView.builder
                itemBuilder: (_, i) => CartItemTile(cartItem: items[i]),
              ),
            ),
            _summary(context, items),
          ]);
        },
      ),
    );
  }

  Widget _summary(BuildContext context, List<CartItem> items) {
    final subtotal = items.fold(0.0, (s, i) => s + i.totalPrice);
    const shipping = 4.99;
    final total = subtotal + shipping;

    return Container(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + MediaQuery.of(context).padding.bottom),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Column(children: [
        _row('Subtotal', '\$${subtotal.toStringAsFixed(2)}'),
        const SizedBox(height: 6),
        _row('Shipping', '\$${shipping.toStringAsFixed(2)}'),
        const SizedBox(height: 10),
        const Divider(color: AppColors.border, height: 1),
        const SizedBox(height: 10),
        _row('Total', '\$${total.toStringAsFixed(2)}', bold: true),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity, height: 50,
          child: ElevatedButton(
            onPressed: () => _checkout(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text('Checkout — \$${total.toStringAsFixed(2)}', style: AppTextStyles.button),
          ),
        ),
      ]),
    );
  }

  Widget _row(String label, String value, {bool bold = false}) {
    return Row(children: [
      Text(label, style: bold ? AppTextStyles.h3 : AppTextStyles.body),
      const Spacer(),
      Text(value,
          style: bold
              ? AppTextStyles.h3.copyWith(color: AppColors.accent)
              : AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
    ]);
  }

  Widget _empty(BuildContext context) {
    return Center(child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          width: 80, height: 80,
          decoration: BoxDecoration(color: AppColors.lightGrey, shape: BoxShape.circle),
          child: const Icon(Icons.shopping_cart_outlined, size: 36, color: AppColors.midGrey),
        ),
        const SizedBox(height: 16),
        Text('Your cart is empty', style: AppTextStyles.h2.copyWith(fontSize: 18)),
        const SizedBox(height: 8),
        Text('Add some products to get started', style: AppTextStyles.bodySmall, textAlign: TextAlign.center),
        const SizedBox(height: 24),
        SizedBox(
          width: 160, height: 46,
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Browse Products', style: AppTextStyles.button.copyWith(fontSize: 13)),
          ),
        ),
      ]),
    ));
  }

  Future<void> _confirmClear(BuildContext context, CartProvider cart) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: Text('Clear cart?', style: AppTextStyles.h3),
        content: Text('Remove all items from your cart.', style: AppTextStyles.body),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false),
              child: Text('Cancel', style: AppTextStyles.body.copyWith(color: AppColors.midGrey))),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, minimumSize: const Size(80, 36)),
            child: Text('Clear', style: AppTextStyles.button.copyWith(fontSize: 13)),
          ),
        ],
      ),
    );
    if (ok == true) cart.clearCart();
  }

  void _checkout(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + MediaQuery.of(context).padding.bottom),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 36, height: 4, decoration: BoxDecoration(
              color: AppColors.border, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 24),
          Container(
            width: 56, height: 56,
            decoration: BoxDecoration(color: AppColors.success.withOpacity(0.12), shape: BoxShape.circle),
            child: const Icon(Icons.check_circle_outline_rounded, size: 30, color: AppColors.success),
          ),
          const SizedBox(height: 14),
          Text('Order Placed!', style: AppTextStyles.h2),
          const SizedBox(height: 8),
          Text('Thank you for shopping with SmartShop+.\nYour order is being processed.',
              style: AppTextStyles.bodySmall, textAlign: TextAlign.center),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity, height: 48,
            child: ElevatedButton(
              onPressed: () {
                context.read<CartProvider>().clearCart();
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text('Continue Shopping', style: AppTextStyles.button),
            ),
          ),
        ]),
      ),
    );
  }
}
