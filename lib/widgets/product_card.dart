// widgets/product_card.dart
// Concept: StatelessWidget, Consumer<T>, reusable widget, navigation with arguments

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../utils/constants.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, AppRoutes.productDetail, arguments: product),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ImageSection(product: product),
            _InfoSection(product: product),
          ],
        ),
      ),
    );
  }
}

class _ImageSection extends StatelessWidget {
  final Product product;
  const _ImageSection({required this.product});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
          child: AspectRatio(
            aspectRatio: 1.1,
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (_, child, p) => p == null
                  ? child
                  : Container(color: AppColors.shimmer,
                      child: const Center(child: SizedBox(width: 18, height: 18,
                          child: CircularProgressIndicator(strokeWidth: 1.5,
                              valueColor: AlwaysStoppedAnimation(AppColors.midGrey))))),
              errorBuilder: (_, __, ___) => Container(color: AppColors.lightGrey,
                  child: const Icon(Icons.image_outlined, color: AppColors.midGrey, size: 28)),
            ),
          ),
        ),
        // discount badge
        if (product.discountPercent > 0)
          Positioned(
            top: 6, left: 6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(color: AppColors.error, borderRadius: BorderRadius.circular(4)),
              child: Text('-${product.discountPercent}%',
                  style: AppTextStyles.caption.copyWith(color: AppColors.white, fontWeight: FontWeight.w700)),
            ),
          ),
        // wishlist
        Positioned(
          top: 4, right: 4,
          child: Container(
            width: 26, height: 26,
            decoration: BoxDecoration(color: AppColors.white.withOpacity(0.9), shape: BoxShape.circle),
            child: const Icon(Icons.favorite_border_rounded, size: 13, color: AppColors.midGrey),
          ),
        ),
      ],
    );
  }
}

class _InfoSection extends StatelessWidget {
  final Product product;
  const _InfoSection({required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 7, 8, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // name
          Text(product.name,
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600, fontSize: 12, color: AppColors.primary),
              maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),

          // rating
          Row(children: [
            const Icon(Icons.star_rounded, color: AppColors.star, size: 11),
            const SizedBox(width: 2),
            Text(product.rating.toStringAsFixed(1),
                style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600, color: AppColors.darkGrey)),
            const SizedBox(width: 3),
            Text('(${_fmt(product.reviewCount)})', style: AppTextStyles.caption),
          ]),
          const SizedBox(height: 6),

          // price row
          Consumer<CartProvider>(
            builder: (context, cart, _) {
              final inCart = cart.containsProduct(product.id);
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('\$${product.price.toStringAsFixed(2)}', style: AppTextStyles.price.copyWith(fontSize: 13)),
                        if (product.discountPercent > 0)
                          Text('\$${product.originalPrice.toStringAsFixed(2)}',
                              style: AppTextStyles.caption.copyWith(decoration: TextDecoration.lineThrough)),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (inCart) {
                        cart.removeFromCart(product.id);
                      } else {
                        cart.addToCart(product);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Added to cart', style: AppTextStyles.bodySmall.copyWith(color: AppColors.white)),
                          backgroundColor: AppColors.success,
                          duration: const Duration(seconds: 1),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          margin: const EdgeInsets.all(12),
                        ));
                      }
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: 28, height: 28,
                      decoration: BoxDecoration(
                        color: inCart ? AppColors.success : AppColors.primary,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Icon(inCart ? Icons.check_rounded : Icons.add_rounded,
                          color: AppColors.white, size: 15),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  String _fmt(int n) => n >= 1000 ? '${(n / 1000).toStringAsFixed(1)}k' : '$n';
}
