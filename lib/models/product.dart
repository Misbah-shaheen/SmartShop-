// ============================================================
// models/product.dart
// Model class representing a Product entity.
// Concept: Model classes, MVC architecture, Dart OOP
// ============================================================

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final double originalPrice; // For showing discount
  final String imageUrl;
  final String category;
  final double rating;
  final int reviewCount;
  final bool isNew;
  final bool isFeatured;

  // Constructor
  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.originalPrice,
    required this.imageUrl,
    required this.category,
    required this.rating,
    required this.reviewCount,
    this.isNew = false,
    this.isFeatured = false,
  });

  /// Computed getter: discount percentage
  int get discountPercent {
    if (originalPrice <= price) return 0;
    return (((originalPrice - price) / originalPrice) * 100).round();
  }

  /// Factory constructor: creates a Product from a JSON Map.
  /// Firebase-ready pattern — fromMap() mirrors Firestore document structure.
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      price: (map['price'] as num).toDouble(),
      originalPrice: (map['originalPrice'] as num).toDouble(),
      imageUrl: map['imageUrl'] as String,
      category: map['category'] as String,
      rating: (map['rating'] as num).toDouble(),
      reviewCount: map['reviewCount'] as int,
      isNew: map['isNew'] as bool? ?? false,
      isFeatured: map['isFeatured'] as bool? ?? false,
    );
  }

  /// Convert Product to Map — used for Firestore / local storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'originalPrice': originalPrice,
      'imageUrl': imageUrl,
      'category': category,
      'rating': rating,
      'reviewCount': reviewCount,
      'isNew': isNew,
      'isFeatured': isFeatured,
    };
  }

  /// copyWith pattern — useful for state updates
  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    double? originalPrice,
    String? imageUrl,
    String? category,
    double? rating,
    int? reviewCount,
    bool? isNew,
    bool? isFeatured,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      isNew: isNew ?? this.isNew,
      isFeatured: isFeatured ?? this.isFeatured,
    );
  }

  @override
  String toString() => 'Product(id: $id, name: $name, price: $price)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Product && other.id == id);

  @override
  int get hashCode => id.hashCode;
}

// ============================================================
// CartItem model — wraps a Product with a quantity
// ============================================================

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  /// Total price for this cart line
  double get totalPrice => product.price * quantity;

  /// Firebase-ready map
  Map<String, dynamic> toMap() {
    return {
      'product': product.toMap(),
      'quantity': quantity,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      product: Product.fromMap(map['product'] as Map<String, dynamic>),
      quantity: map['quantity'] as int,
    );
  }
}
