import 'package:flutter/material.dart';

import 'chitietsp.dart';
import 'giaodien.dart';
import 'giohang.dart';
import 'tongquan.dart';

// =====================================================
// MODEL & DATA SẢN PHẨM
// =====================================================
class Product {
  final String name;
  final String price;
  final String category;
  final String image;

  const Product(this.name, this.price, this.category, this.image);
}

const categories = [
  'cat_all',
  'cat_phone',
  'cat_laptop',
  'cat_accessory',
  'cat_watch',
];

const products = [
  Product('iPhone 15 Pro', '28.990.000đ', 'cat_phone', 'https://shopdidong.vn/wp-content/uploads/2026/06/iphone-15-pro-max-shopdidong-1.webp'),
  Product('Samsung Galaxy S24', '22.990.000đ', 'cat_phone', 'https://shopdidong.vn/wp-content/uploads/2026/06/samsung-galaxy-s24-shopdidong-1.webp'),
  Product('MacBook Air M2', '24.990.000đ', 'cat_laptop', 'https://shopdidong.vn/wp-content/uploads/2026/06/macbook-air-m2-shopdidong-1.webp'),
  Product('Dell XPS 13', '31.990.000đ', 'cat_laptop', 'https://shopdidong.vn/wp-content/uploads/2026/06/dell-xps-13-shopdidong-1.webp'),
  Product('Tai nghe Bluetooth', '1.290.000đ', 'cat_accessory', 'https://shopdidong.vn/wp-content/uploads/2026/06/tai-nghe-bluetooth-shopdidong-1.webp'),
  Product('Sạc nhanh 65W', '490.000đ', 'cat_accessory', 'https://shopdidong.vn/wp-content/uploads/2026/06/sac-nhanh-65w-shopdidong-1.webp'),
  Product('Chuột Logitech MX', '1.890.000đ', 'cat_accessory', 'https://shopdidong.vn/wp-content/uploads/2026/06/chuot-logitech-mx-shopdidong-1.webp'),
  Product('Bàn phím cơ', '2.290.000đ', 'cat_accessory', 'https://shopdidong.vn/wp-content/uploads/2026/06/ban-phim-co-shopdidong-1.webp'),
  Product('Apple Watch SE', '6.990.000đ', 'cat_watch', 'https://shopdidong.vn/wp-content/uploads/2026/06/apple-watch-se-shopdidong-1.webp'),
  Product('Galaxy Watch 6', '6.490.000đ', 'cat_watch', 'https://shopdidong.vn/wp-content/uploads/2026/06/galaxy-watch-6-shopdidong-1.webp'),
];

// Helper hiển thị ảnh từ URL
Widget productImage(String url) {
  return Image.network(
    url,
    fit: BoxFit.cover,
    loadingBuilder: (context, child, progress) => progress == null
        ? child
        : const Center(child: CircularProgressIndicator(strokeWidth: 2)),
    errorBuilder: (context, error, stack) =>
        const Icon(Icons.image_not_supported, size: 36, color: Colors.grey),
  );
}

// =====================================================
// CARD SẢN PHẨM SINGLE ITEM
// =====================================================
class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onAdd;

  const ProductCard({super.key, required this.product, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = isDark(context);

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(product: product),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 3,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column( 
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Hero(
                    tag: 'product-img-${product.name}',
                    child: Container(
                      width: double.infinity,
                      color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade100,
                      child: productImage(product.image),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.star, color: Colors.amber, size: 12),
                          SizedBox(width: 2),
                          Text('4.9', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product.price,
                        style: const TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      InkWell(
                        onTap: onAdd,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Color(0xFF1E3A8A),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.add, size: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================
// MÀN HÌNH CHÍNH (PRODUCT LIST SCREEN)
// =====================================================
class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final searchFocus = FocusNode();
  String keyword = '';
  String category = 'cat_all';
  int tab = 0;

  @override
  void dispose() {
    searchFocus.dispose();
    super.dispose();
  }

  List<Product> get filtered => products
      .where((p) =>
          (category == 'cat_all' || p.category == category) &&
          p.name.toLowerCase().contains(keyword.toLowerCase()))
      .toList();

  void focusSearch() {
    setState(() => tab = 0);
    WidgetsBinding.instance.addPostFrameCallback((_) => searchFocus.requestFocus());
  }

  Widget buildHome() {
    final list = filtered;
    return Column(
      children: [
        // Thanh tìm kiếm nâng cấp
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
          child: TextField(
            focusNode: searchFocus,
            onChanged: (v) => setState(() => keyword = v.trim()),
            decoration: InputDecoration(
              hintText: tr('search_hint'),
              prefixIcon: const Icon(Icons.search, color: Color(0xFF1E3A8A)),
              suffixIcon: keyword.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 18),
                      onPressed: () => setState(() => keyword = ''),
                    )
                  : null,
              filled: true,
              fillColor: isDark(context) ? Colors.grey[850] : Colors.grey[100],
              contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),

        // Thanh chọn danh mục
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: categories
                .map((c) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(tr(c)),
                        selected: category == c,
                        selectedColor: const Color.fromARGB(255, 8, 18, 161),
                        labelStyle: TextStyle(
                          color: category == c ? Colors.white : null,
                          fontWeight: category == c ? FontWeight.bold : FontWeight.normal,
                        ),
                        onSelected: (_) => setState(() => category = c),
                      ),
                    ))
                .toList(),
          ),
        ),

        const SizedBox(height: 8),

        // Lưới sản phẩm
        Expanded(
          child: list.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.search_off, size: 60, color: Colors.grey),
                      const SizedBox(height: 8),
                      Text(tr('no_product'), style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    mainAxisExtent: 240,
                  ),
                  itemCount: list.length,
                  itemBuilder: (context, i) => ProductCard(
                    product: list[i],
                    onAdd: () {
                      setState(() => cart[list[i]] = (cart[list[i]] ?? 0) + 1);
                      showMessage(context, '${tr('added')} ${list[i].name} ${tr('to_cart')}');
                    },
                  ),
                ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: langNotifier,
      builder: (context, _) => Scaffold(
        appBar: AppBar(
          elevation: 2,
          backgroundColor: const Color(0xFF1E3A8A),
          foregroundColor: Colors.white,
          title: Text(
            tab == 2 ? tr('settings') : 'ShopEasy',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: tab != 0
              ? null
              : [
                  IconButton(
                    icon: const Icon(Icons.dashboard_outlined),
                    tooltip: tr('dashboard_title'),
                    onPressed: () => go(context, const DashboardScreen()),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: focusSearch,
                  ),
                  IconButton(
                    icon: Badge(
                      label: Text('$cartCount'),
                      isLabelVisible: cartCount > 0,
                      child: const Icon(Icons.shopping_cart),
                    ),
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CartScreen()),
                      );
                      if (mounted) setState(() {});
                    },
                  ),
                ],
        ),
        body: IndexedStack(
          index: tab,
          children: [
            buildHome(),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                  const SizedBox(height: 12),
                  Text(tr('tab_favorite'), style: const TextStyle(fontSize: 16, color: Colors.grey)),
                ],
              ),
            ),
            const SettingsScreen(),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: tab,
          onDestinationSelected: (i) => setState(() => tab = i),
          destinations: [
            NavigationDestination(icon: const Icon(Icons.home_outlined), selectedIcon: const Icon(Icons.home), label: tr('tab_home')),
            NavigationDestination(icon: const Icon(Icons.favorite_outline), selectedIcon: const Icon(Icons.favorite), label: tr('tab_favorite')),
            NavigationDestination(icon: const Icon(Icons.person_outline), selectedIcon: const Icon(Icons.person), label: tr('tab_account')),
          ],
        ),
      ),
    );
  }
}