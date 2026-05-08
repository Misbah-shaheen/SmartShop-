// widgets/cart_item_tile.dart
// Concept: StatelessWidget, reusable widget, Consumer

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../utils/constants.dart';

class CartItemTile extends StatelessWidget {
  final CartItem cartItem;
  const CartItemTile({super.key, required this.cartItem});

  @override
  Widget build(BuildContext context) {
    final p = cartItem.product;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(children: [
        // image
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 68, height: 68,
            color: AppColors.lightGrey,
            child: Image.network(p.imageUrl, fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(Icons.image_outlined, color: AppColors.midGrey, size: 24)),
          ),
        ),
        const SizedBox(width: 10),

        // info
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(p.name,
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600, fontSize: 13),
              maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 3),
          Text(p.category, style: AppTextStyles.caption),
          const SizedBox(height: 6),
          Text('\$${p.price.toStringAsFixed(2)}',
              style: AppTextStyles.price.copyWith(color: AppColors.accent, fontSize: 13)),
        ])),

        const SizedBox(width: 8),

        // controls
        Consumer<CartProvider>(builder: (_, cart, __) {
          return Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            // remove
            GestureDetector(
              onTap: () => cart.removeFromCart(p.id),
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(color: AppColors.error.withOpacity(0.1), borderRadius: BorderRadius.circular(5)),
                child: const Icon(Icons.close_rounded, color: AppColors.error, size: 12),
              ),
            ),
            const SizedBox(height: 10),

            // stepper
            Container(
              decoration: BoxDecoration(color: AppColors.lightGrey, borderRadius: BorderRadius.circular(8)),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                _Btn(icon: Icons.remove_rounded, onTap: () => cart.decreaseQuantity(p.id)),
                SizedBox(width: 26,
                    child: Text('${cartItem.quantity}', textAlign: TextAlign.center,
                        style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700, fontSize: 13))),
                _Btn(icon: Icons.add_rounded, onTap: () => cart.increaseQuantity(p.id)),
              ]),
            ),
            const SizedBox(height: 6),
            Text('\$${cartItem.totalPrice.toStringAsFixed(2)}',
                style: AppTextStyles.price.copyWith(fontSize: 13)),
          ]);
        }),
      ]),
    );
  }
}

class _Btn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _Btn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 26, height: 26,
        decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(6),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 3)]),
        child: Icon(icon, size: 13, color: AppColors.primary),
      ),
    );
  }
}
