// ============================================================
// providers/cart_provider.dart
// Global cart state using Provider + ChangeNotifier.
// Concept: Provider, ChangeNotifier, notifyListeners(), Consumer.
// ============================================================

import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../streams/cart_stream.dart';

/// CartProvider holds the global shopping cart state.
/// Extends ChangeNotifier so that Consumer widgets rebuild on changes.
///
/// Concept checklist covered here:
///   ✔ ChangeNotifier
///   ✔ notifyListeners()
///   ✔ Provider pattern
///   ✔ Stream integration (CartStream.updateCart)
class CartProvider extends ChangeNotifier {
  // Internal cart list
  final List<CartItem> _items = [];

  // CartStream instance for real-time broadcast
  final CartStream _cartStream = CartStream();

  // ============================================================
  // GETTERS
  // ============================================================

  /// Returns an unmodifiable view of the cart items
  List<CartItem> get items => List.unmodifiable(_items);

  /// Total number of individual products (sum of quantities)
  int get totalQuantity =>
      _items.fold(0, (sum, item) => sum + item.quantity);

  /// Total price of all items in the cart
  double get totalPrice =>
      _items.fold(0.0, (sum, item) => sum + item.totalPrice);

  /// Whether the cart is empty
  bool get isEmpty => _items.isEmpty;

  /// Number of distinct products in the cart
  int get itemCount => _items.length;

  // ============================================================
  // METHODS
  // ============================================================

  /// Add a product to the cart.
  /// If it already exists, increment its quantity.
  void addToCart(Product product) {
    final existingIndex =
        _items.indexWhere((item) => item.product.id == product.id);

    if (existingIndex >= 0) {
      // Product already in cart — increase quantity
      _items[existingIndex].quantity++;
    } else {
      // New product — add as a CartItem with qty 1
      _items.add(CartItem(product: product, quantity: 1));
    }

    _notifyAll();
  }

  /// Remove a product from the cart entirely.
  void removeFromCart(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
    _notifyAll();
  }

  /// Decrease quantity by 1; remove if quantity reaches 0.
  void decreaseQuantity(String productId) {
    final index =
        _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
    }
    _notifyAll();
  }

  /// Increase quantity of an existing cart item.
  void increaseQuantity(String productId) {
    final index =
        _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      _items[index].quantity++;
    }
    _notifyAll();
  }

  /// Clear the entire cart.
  void clearCart() {
    _items.clear();
    _notifyAll();
  }

  /// Check if a specific product is already in the cart.
  bool containsProduct(String productId) =>
      _items.any((item) => item.product.id == productId);

  /// Get the quantity of a specific product in the cart.
  int quantityOf(String productId) {
    try {
      return _items
          .firstWhere((item) => item.product.id == productId)
          .quantity;
    } catch (_) {
      return 0;
    }
  }

  // ============================================================
  // PRIVATE HELPERS
  // ============================================================

  /// Notifies both Provider listeners AND the Stream.
  /// Concept: notifyListeners() + Stream.add()
  void _notifyAll() {
    notifyListeners(); // Rebuilds all Consumer<CartProvider> widgets
    _cartStream.updateCart(_items); // Pushes snapshot to StreamBuilder listeners
  }

  @override
  void dispose() {
    _cartStream.dispose();
    super.dispose();
  }
}
