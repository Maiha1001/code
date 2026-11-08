import 'package:flutter/material.dart';
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
        const Icon(Icons.image_not_supported, size: 32, color: Colors.grey),
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
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              color: isDark(context) ? Colors.grey.shade800 : Colors.grey.shade100,
              child: productImage(product.image),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 4, 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        product.price,
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_shopping_cart, size: 20),
                      onPressed: onAdd,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
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

  // Danh sách sản phẩm được lọc theo từ khóa & danh mục
  List<Product> get filtered => products
      .where((p) =>
          (category == 'cat_all' || p.category == category) &&
          p.name.toLowerCase().contains(keyword.toLowerCase()))
      .toList();

  void focusSearch() {
    setState(() => tab = 0);
    WidgetsBinding.instance.addPostFrameCallback((_) => searchFocus.requestFocus());
  }

  // Widget hiển thị Trang chủ sản phẩm
  Widget buildHome() {
    final list = filtered;
    return Column(
      children: [
        // Thanh tìm kiếm
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: TextField(
            focusNode: searchFocus,
            onChanged: (v) => setState(() => keyword = v.trim()),
            decoration: InputDecoration(
              hintText: tr('search_hint'),
              prefixIcon: const Icon(Icons.search),
              filled: true,
              contentPadding: EdgeInsets.zero,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),

        // Thanh chọn danh mục (Categories)
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: categories
                .map((c) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(tr(c)),
                        selected: category == c,
                        showCheckmark: false,
                        selectedColor: const Color(0xFF1E3A8A),
                        labelStyle: TextStyle(color: category == c ? Colors.white : null),
                        onSelected: (_) => setState(() => category = c),
                      ),
                    ))
                .toList(),
          ),
        ),

        // Lưới hiển thị danh sách sản phẩm
        Expanded(
          child: list.isEmpty
              ? Center(child: Text(tr('no_product')))
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    mainAxisExtent: 250,
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
          backgroundColor: const Color(0xFF1E3A8A),
          foregroundColor: Colors.white,
          title: Text(tab == 2 ? tr('settings') : 'ShopEasy'),
          actions: tab != 0
              ? null
              : [
                  // Nút chuyển sang màn hình Tổng quan (Dashboard)
                  IconButton(
                    icon: const Icon(Icons.dashboard_outlined),
                    tooltip: tr('dashboard_title'),
                    onPressed: () => go(context, const DashboardScreen()),
                  ),

                  // Nút con trỏ tìm kiếm
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: focusSearch,
                  ),

                  // Nút Giỏ hàng có Badge báo số lượng
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
            Center(child: Text(tr('tab_favorite'))),
            const SettingsScreen(),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: tab,
          onDestinationSelected: (i) => setState(() => tab = i),
          destinations: [
            NavigationDestination(icon: const Icon(Icons.home), label: tr('tab_home')),
            NavigationDestination(icon: const Icon(Icons.favorite), label: tr('tab_favorite')),
            NavigationDestination(icon: const Icon(Icons.person), label: tr('tab_account')),
          ],
        ),
      ),
    );
  }
}