// ============================================================
// services/product_service.dart
// Concept: Service layer, async/await, Future, separation of concerns.
// ============================================================

import '../models/product.dart';

class ProductService {
  static final ProductService _instance = ProductService._internal();
  factory ProductService() => _instance;
  ProductService._internal();

  Future<List<Product>> fetchProducts() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    return _dummyProductData.map((map) => Product.fromMap(map)).toList();
  }

  Future<List<Product>> fetchProductsByCategory(String category) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final all = await fetchProducts();
    if (category == 'All') return all;
    return all.where((p) => p.category == category).toList();
  }

  Future<Product?> fetchProductById(String id) async {
    await Future.delayed(const Duration(milliseconds: 600));
    try {
      return _dummyProductData
          .map((map) => Product.fromMap(map))
          .firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<List<String>> fetchCategories() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return ['All', 'Electronics', 'Fashion', 'Home', 'Sports', 'Books'];
  }

  static const List<Map<String, dynamic>> _dummyProductData = [
    {
      'id': 'p001',
      'name': 'Wireless Noise-Cancelling Headphones',
      'description': 'Experience crystal-clear audio with our premium wireless headphones. Featuring active noise cancellation, 30-hour battery life, and ultra-comfortable ear cushions. Perfect for work, travel, and immersive music sessions.',
      'price': 79.99,
      'originalPrice': 129.99,
      'imageUrl': 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400&h=400&fit=crop',
      'category': 'Electronics',
      'rating': 4.7,
      'reviewCount': 1284,
      'isNew': false,
      'isFeatured': true,
    },
    {
      'id': 'p002',
      'name': 'Smart Fitness Tracker Pro',
      'description': 'Track your health metrics in style. Heart rate monitoring, sleep analysis, GPS, and 7-day battery. Compatible with iOS and Android. Water-resistant up to 50m.',
      'price': 49.99,
      'originalPrice': 69.99,
      'imageUrl': 'https://images.unsplash.com/photo-1575311373937-040b8e1fd5b6?w=400&h=400&fit=crop',
      'category': 'Electronics',
      'rating': 4.5,
      'reviewCount': 872,
      'isNew': true,
      'isFeatured': false,
    },
    {
      'id': 'p003',
      'name': 'Premium Leather Sneakers',
      'description': 'Crafted from genuine full-grain leather, these sneakers offer unmatched comfort and durability. Minimalist design pairs effortlessly with casual and smart-casual outfits.',
      'price': 89.99,
      'originalPrice': 89.99,
      'imageUrl': 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400&h=400&fit=crop',
      'category': 'Fashion',
      'rating': 4.3,
      'reviewCount': 456,
      'isNew': false,
      'isFeatured': false,
    },
    {
      'id': 'p004',
      'name': 'Portable Bluetooth Speaker',
      'description': 'Bold 360 sound in a compact body. Waterproof IPX7, 12-hour playback, and a built-in power bank to charge your devices. The ultimate outdoor companion.',
      'price': 34.99,
      'originalPrice': 59.99,
      'imageUrl': 'https://images.unsplash.com/photo-1608043152269-423dbba4e7e1?w=400&h=400&fit=crop',
      'category': 'Electronics',
      'rating': 4.6,
      'reviewCount': 2103,
      'isNew': false,
      'isFeatured': true,
    },
    {
      'id': 'p005',
      'name': 'Minimalist Desk Lamp',
      'description': 'USB-C powered with 3 colour temperatures and 5 brightness levels. Touch-sensitive controls, flexible neck, and slim Nordic design that fits any workspace.',
      'price': 22.99,
      'originalPrice': 34.99,
      'imageUrl': 'https://images.unsplash.com/photo-1507473885765-e6ed057f782c?w=400&h=400&fit=crop',
      'category': 'Home',
      'rating': 4.4,
      'reviewCount': 619,
      'isNew': true,
      'isFeatured': false,
    },
    {
      'id': 'p006',
      'name': 'Yoga Mat Ultra Grip',
      'description': 'Non-slip, eco-friendly TPE material. 6mm thickness for superior joint support. Alignment lines, carry strap included. Ideal for yoga, pilates, and stretching.',
      'price': 28.99,
      'originalPrice': 44.99,
      'imageUrl': 'https://images.unsplash.com/photo-1601925228010-f55c6c12b62d?w=400&h=400&fit=crop',
      'category': 'Sports',
      'rating': 4.8,
      'reviewCount': 3247,
      'isNew': false,
      'isFeatured': true,
    },
    {
      'id': 'p007',
      'name': 'Stainless Steel Water Bottle',
      'description': 'Triple-insulated keeps drinks cold 24h and hot 12h. Leak-proof lid, BPA-free, fits standard cup holders. Available in 500ml and 750ml.',
      'price': 18.99,
      'originalPrice': 24.99,
      'imageUrl': 'https://images.unsplash.com/photo-1602143407151-7111542de6e8?w=400&h=400&fit=crop',
      'category': 'Sports',
      'rating': 4.6,
      'reviewCount': 5421,
      'isNew': false,
      'isFeatured': false,
    },
    {
      'id': 'p008',
      'name': 'Atomic Habits by James Clear',
      'description': 'The number 1 New York Times bestseller. Discover how tiny changes can produce remarkable results. A practical guide to building good habits and breaking bad ones.',
      'price': 12.99,
      'originalPrice': 19.99,
      'imageUrl': 'https://images.unsplash.com/photo-1544947950-fa07a98d237f?w=400&h=400&fit=crop',
      'category': 'Books',
      'rating': 4.9,
      'reviewCount': 18743,
      'isNew': false,
      'isFeatured': true,
    },
    {
      'id': 'p009',
      'name': 'Mechanical Gaming Keyboard',
      'description': 'Cherry MX Blue switches, full RGB backlighting with 20 effects, aluminium top plate, and detachable USB-C cable. Built for competitive gaming and coding marathons.',
      'price': 64.99,
      'originalPrice': 99.99,
      'imageUrl': 'https://images.unsplash.com/photo-1618384887929-16ec33fab9ef?w=400&h=400&fit=crop',
      'category': 'Electronics',
      'rating': 4.5,
      'reviewCount': 988,
      'isNew': true,
      'isFeatured': false,
    },
    {
      'id': 'p010',
      'name': 'Ceramic Pour-Over Coffee Set',
      'description': 'Handcrafted ceramic dripper with 600ml carafe and measuring spoon. For coffee lovers who appreciate the ritual. Compatible with standard paper filters.',
      'price': 39.99,
      'originalPrice': 55.99,
      'imageUrl': 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=400&h=400&fit=crop',
      'category': 'Home',
      'rating': 4.7,
      'reviewCount': 743,
      'isNew': false,
      'isFeatured': false,
    },
  ];
}
