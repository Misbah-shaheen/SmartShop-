// ============================================================
// streams/cart_stream.dart
// Real-time cart updates using Dart Streams.
// Concept: StreamController, broadcast Stream, Streams, real-time updates.
// ============================================================

import 'dart:async';
import '../models/product.dart';

/// CartStream manages a broadcast stream that emits the current cart state
/// whenever items are added or removed.
///
/// StreamController.broadcast() allows MULTIPLE listeners (e.g. cart icon
/// badge on AppBar AND the full CartScreen both listen simultaneously).
class CartStream {
  // Singleton — one stream source for the whole app
  static final CartStream _instance = CartStream._internal();
  factory CartStream() => _instance;
  CartStream._internal();

  // ============================================================
  // STREAM CONTROLLER
  // Concept: StreamController<T>
  // broadcast() → allows multiple listeners at once
  // ============================================================
  final StreamController<List<CartItem>> _cartController =
      StreamController<List<CartItem>>.broadcast();

  /// Public stream that widgets can listen to via StreamBuilder
  /// Concept: Stream<T>
  Stream<List<CartItem>> get cartStream => _cartController.stream;

  /// Push a new cart snapshot into the stream.
  /// Called by CartProvider every time the cart changes.
  /// Concept: StreamController.add()
  void updateCart(List<CartItem> items) {
    // Only add if the controller hasn't been closed
    if (!_cartController.isClosed) {
      _cartController.add(List<CartItem>.from(items));
    }
  }

  /// Closes the stream when the app disposes (memory management)
  void dispose() {
    _cartController.close();
  }
}
