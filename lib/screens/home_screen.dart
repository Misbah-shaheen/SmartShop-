// screens/home_screen.dart
// Concept: StatefulWidget, FutureBuilder, GridView, ListView.builder,
//          Consumer, MediaQuery, AppBar, async/await

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../services/product_service.dart';
import '../widgets/product_card.dart';
import '../utils/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _service = ProductService();
  late Future<List<Product>> _productsFuture;
  late Future<List<String>> _categoriesFuture;
  String _selectedCategory = 'All';
  String _searchQuery = '';
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _load() {
    _productsFuture = _service.fetchProducts();
    _categoriesFuture = _service.fetchCategories();
  }

  void _selectCategory(String cat) => setState(() {
        _selectedCategory = cat;
        _productsFuture = _service.fetchProductsByCategory(cat);
      });

  List<Product> _filter(List<Product> list) {
    if (_searchQuery.isEmpty) return list;
    final q = _searchQuery.toLowerCase();
    return list.where((p) => p.name.toLowerCase().contains(q) || p.category.toLowerCase().contains(q)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _appBar(context),
      body: RefreshIndicator(
        color: AppColors.accent,
        onRefresh: () async => setState(_load),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _searchBar()),
            SliverToBoxAdapter(
              child: FutureBuilder<List<String>>(
                future: _categoriesFuture,
                builder: (_, snap) => snap.hasData ? _categories(snap.data!) : const SizedBox(height: 48),
              ),
            ),
            SliverToBoxAdapter(child: _sectionTitle()),
            _grid(),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
      floatingActionButton: _cartFab(context),
    );
  }

  // ---- AppBar ----
  AppBar _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      title: Row(children: [
        Container(
          width: 28, height: 28,
          decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(7)),
          child: const Icon(Icons.shopping_bag_rounded, color: AppColors.white, size: 16),
        ),
        const SizedBox(width: 8),
        Text('SmartShop+', style: AppTextStyles.h3.copyWith(fontSize: 17)),
      ]),
      actions: [
        Consumer<CartProvider>(builder: (_, cart, __) {
          return Stack(alignment: Alignment.center, children: [
            IconButton(
              icon: const Icon(Icons.shopping_cart_outlined, color: AppColors.primary, size: 22),
              onPressed: () => Navigator.pushNamed(context, AppRoutes.cart),
            ),
            if (cart.totalQuantity > 0)
              Positioned(
                top: 8, right: 8,
                child: Container(
                  width: 15, height: 15,
                  decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
                  child: Center(child: Text('${cart.totalQuantity > 9 ? '9+' : cart.totalQuantity}',
                      style: AppTextStyles.caption.copyWith(color: AppColors.white, fontSize: 8, fontWeight: FontWeight.w800))),
                ),
              ),
          ]);
        }),
        const SizedBox(width: 4),
      ],
    );
  }

  // ---- Search bar ----
  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 6),
      child: TextField(
        controller: _searchController,
        onChanged: (v) => setState(() => _searchQuery = v),
        style: AppTextStyles.body.copyWith(fontSize: 14),
        decoration: InputDecoration(
          hintText: 'Search products...',
          prefixIcon: const Icon(Icons.search, color: AppColors.midGrey, size: 18),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(icon: const Icon(Icons.close, size: 16, color: AppColors.midGrey),
                  onPressed: () { _searchController.clear(); setState(() => _searchQuery = ''); })
              : null,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          filled: true, fillColor: AppColors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
        ),
      ),
    );
  }

  // ---- Categories ----
  // Concept: ListView.builder horizontal
  Widget _categories(List<String> cats) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: cats.length,
        itemBuilder: (_, i) {
          final selected = cats[i] == _selectedCategory;
          return GestureDetector(
            onTap: () => _selectCategory(cats[i]),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: selected ? AppColors.primary : AppColors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: selected ? AppColors.primary : AppColors.border),
              ),
              child: Text(cats[i],
                  style: AppTextStyles.caption.copyWith(
                      color: selected ? AppColors.white : AppColors.darkGrey,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                      fontSize: 12)),
            ),
          );
        },
      ),
    );
  }

  Widget _sectionTitle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
      child: Row(children: [
        Text(_selectedCategory == 'All' ? 'All Products' : _selectedCategory, style: AppTextStyles.h3),
        const Spacer(),
        if (_searchQuery.isNotEmpty)
          Text('"$_searchQuery"', style: AppTextStyles.bodySmall.copyWith(color: AppColors.accent)),
      ]),
    );
  }

  // ---- Products Grid ----
  // Concept: FutureBuilder, GridView, loading/error/empty states
  Widget _grid() {
    final w = MediaQuery.of(context).size.width;
    final cols = w > 600 ? 3 : 2;

    return FutureBuilder<List<Product>>(
      future: _productsFuture,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate((_, __) => _shimmerCard(), childCount: 6),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: cols, childAspectRatio: 0.75, crossAxisSpacing: 10, mainAxisSpacing: 10),
            ),
          );
        }
        if (snap.hasError) return SliverToBoxAdapter(child: _errorState());
        final products = _filter(snap.data ?? []);
        if (products.isEmpty) return SliverToBoxAdapter(child: _emptyState());

        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (ctx, i) => ProductCard(product: products[i]),
              childCount: products.length,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: cols,
              childAspectRatio: 0.75,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
          ),
        );
      },
    );
  }

  Widget _shimmerCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white, borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        AspectRatio(
          aspectRatio: 1.1,
          child: Container(decoration: const BoxDecoration(
              color: AppColors.shimmer, borderRadius: BorderRadius.vertical(top: Radius.circular(11)))),
        ),
        Padding(padding: const EdgeInsets.all(8), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(height: 10, width: double.infinity, color: AppColors.shimmer),
          const SizedBox(height: 5),
          Container(height: 10, width: 80, color: AppColors.shimmer),
          const SizedBox(height: 8),
          Container(height: 12, width: 50, color: AppColors.shimmer),
        ])),
      ]),
    );
  }

  Widget _errorState() => Padding(
    padding: const EdgeInsets.all(32),
    child: Column(children: [
      const Icon(Icons.wifi_off_rounded, size: 48, color: AppColors.midGrey),
      const SizedBox(height: 12),
      Text('Failed to load', style: AppTextStyles.h3),
      const SizedBox(height: 16),
      SizedBox(width: 120, child: ElevatedButton(onPressed: () => setState(_load), child: const Text('Retry'))),
    ]),
  );

  Widget _emptyState() => Padding(
    padding: const EdgeInsets.all(32),
    child: Column(children: [
      const Icon(Icons.search_off_rounded, size: 48, color: AppColors.midGrey),
      const SizedBox(height: 12),
      Text('No results found', style: AppTextStyles.h3),
    ]),
  );

  Widget _cartFab(BuildContext context) {
    return Consumer<CartProvider>(builder: (_, cart, __) {
      if (cart.isEmpty) return const SizedBox.shrink();
      return FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.cart),
        backgroundColor: AppColors.primary,
        elevation: 4,
        icon: const Icon(Icons.shopping_cart_rounded, color: AppColors.white, size: 18),
        label: Text(
          '${cart.totalQuantity} item${cart.totalQuantity > 1 ? 's' : ''} · \$${cart.totalPrice.toStringAsFixed(2)}',
          style: AppTextStyles.button.copyWith(fontSize: 13),
        ),
      );
    });
  }
}
