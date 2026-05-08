// screens/product_detail_screen.dart
// Concept: StatelessWidget, route arguments, Consumer, SliverAppBar, Responsive UI

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../utils/constants.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)!.settings.arguments as Product;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _sliverAppBar(context, product),
          SliverToBoxAdapter(child: _details(context, product)),
        ],
      ),
      bottomNavigationBar: _bottomBar(context, product),
    );
  }

  Widget _sliverAppBar(BuildContext context, Product product) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: AppColors.white,
      surfaceTintColor: AppColors.white,
      leading: Padding(
        padding: const EdgeInsets.all(8),
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            decoration: BoxDecoration(color: AppColors.white, shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)]),
            child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: AppColors.primary),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Consumer<CartProvider>(builder: (_, cart, __) {
            return GestureDetector(
              onTap: () => Navigator.pushNamed(context, AppRoutes.cart),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: AppColors.white, shape: BoxShape.circle,
                    boxShadow: [const BoxShadow(color: Colors.black12, blurRadius: 8)]),
                child: Stack(alignment: Alignment.center, children: [
                  const Icon(Icons.shopping_cart_outlined, size: 18, color: AppColors.primary),
                  if (cart.totalQuantity > 0)
                    Positioned(top: 0, right: 0,
                      child: Container(width: 8, height: 8,
                          decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle))),
                ]),
              ),
            );
          }),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          color: AppColors.white,
          child: Stack(fit: StackFit.expand, children: [
          Image.network(
            product.imageUrl,
            fit: BoxFit.contain,
            width: double.infinity,
            height: double.infinity,
            loadingBuilder: (_, child, p) => p == null ? child
                : Container(color: AppColors.shimmer,
                    child: const Center(child: CircularProgressIndicator(strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(AppColors.midGrey)))),
            errorBuilder: (_, __, ___) => Container(color: AppColors.lightGrey,
                child: const Icon(Icons.image_outlined, size: 48, color: AppColors.midGrey)),
          ),
          // bottom fade
          Positioned(bottom: 0, left: 0, right: 0,
            child: Container(height: 60,
              decoration: BoxDecoration(gradient: LinearGradient(
                begin: Alignment.bottomCenter, end: Alignment.topCenter,
                colors: [AppColors.background, AppColors.background.withOpacity(0)])))),
          // badges
          if (product.discountPercent > 0)
            Positioned(bottom: 16, left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: AppColors.error, borderRadius: BorderRadius.circular(6)),
                child: Text('-${product.discountPercent}% OFF',
                    style: AppTextStyles.caption.copyWith(color: AppColors.white, fontWeight: FontWeight.w700)),
              )),
        ]),
        ),
      ),
    );
  }

  Widget _details(BuildContext context, Product product) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // category chip
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
              color: AppColors.lightGrey, borderRadius: BorderRadius.circular(20)),
          child: Text(product.category,
              style: AppTextStyles.caption.copyWith(color: AppColors.darkGrey, fontWeight: FontWeight.w600)),
        ),
        const SizedBox(height: 10),

        // name
        Text(product.name, style: AppTextStyles.h2),
        const SizedBox(height: 10),

        // rating row
        Row(children: [
          ...List.generate(5, (i) => Icon(
            i < product.rating.floor() ? Icons.star_rounded : Icons.star_outline_rounded,
            color: AppColors.star, size: 16)),
          const SizedBox(width: 6),
          Text(product.rating.toStringAsFixed(1),
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(width: 4),
          Text('(${product.reviewCount} reviews)', style: AppTextStyles.bodySmall),
        ]),
        const SizedBox(height: 14),

        // price
        Row(crossAxisAlignment: CrossAxisAlignment.baseline, textBaseline: TextBaseline.alphabetic, children: [
          Text('\$${product.price.toStringAsFixed(2)}',
              style: AppTextStyles.h1.copyWith(color: AppColors.primary, fontSize: 26)),
          if (product.discountPercent > 0) ...[
            const SizedBox(width: 10),
            Text('\$${product.originalPrice.toStringAsFixed(2)}',
                style: AppTextStyles.body.copyWith(decoration: TextDecoration.lineThrough, color: AppColors.midGrey)),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(color: AppColors.error.withOpacity(0.1), borderRadius: BorderRadius.circular(5)),
              child: Text('Save \$${(product.originalPrice - product.price).toStringAsFixed(2)}',
                  style: AppTextStyles.caption.copyWith(color: AppColors.error, fontWeight: FontWeight.w600)),
            ),
          ],
        ]),
        const SizedBox(height: 20),

        Divider(color: AppColors.border, thickness: 1),
        const SizedBox(height: 16),

        Text('About this product', style: AppTextStyles.h3),
        const SizedBox(height: 8),
        Text(product.description, style: AppTextStyles.body.copyWith(height: 1.7, color: AppColors.darkGrey)),
        const SizedBox(height: 20),

        // feature pills
        Wrap(spacing: 8, runSpacing: 8, children: [
          _pill(Icons.local_shipping_outlined, 'Free Shipping'),
          _pill(Icons.refresh_rounded, 'Easy Returns'),
          _pill(Icons.verified_user_outlined, 'Secure Pay'),
          _pill(Icons.headset_mic_outlined, '24/7 Support'),
        ]),
      ]),
    );
  }

  Widget _pill(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
          color: AppColors.white, borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 13, color: AppColors.darkGrey),
        const SizedBox(width: 5),
        Text(label, style: AppTextStyles.caption.copyWith(color: AppColors.darkGrey, fontWeight: FontWeight.w500)),
      ]),
    );
  }

  Widget _bottomBar(BuildContext context, Product product) {
    return Consumer<CartProvider>(builder: (context, cart, _) {
      final inCart = cart.containsProduct(product.id);
      return Container(
        padding: EdgeInsets.fromLTRB(16, 12, 16, 12 + MediaQuery.of(context).padding.bottom),
        decoration: const BoxDecoration(
          color: AppColors.white,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: Row(children: [
          // wishlist
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
                border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.favorite_border_rounded, color: AppColors.error, size: 20),
          ),
          const SizedBox(width: 12),

          // add / qty
          Expanded(
            child: inCart
                ? Container(
                    height: 48,
                    decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(12)),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                      IconButton(icon: const Icon(Icons.remove_rounded, color: AppColors.white, size: 18),
                          onPressed: () => cart.decreaseQuantity(product.id)),
                      Text('${cart.quantityOf(product.id)} in cart',
                          style: AppTextStyles.button.copyWith(fontSize: 13)),
                      IconButton(icon: const Icon(Icons.add_rounded, color: AppColors.white, size: 18),
                          onPressed: () => cart.increaseQuantity(product.id)),
                    ]),
                  )
                : SizedBox(
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: () => cart.addToCart(product),
                      icon: const Icon(Icons.shopping_cart_outlined, size: 16),
                      label: const Text('Add to Cart'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
          ),
        ]),
      );
    });
  }
}
