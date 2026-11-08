import 'package:flutter/material.dart';

import 'sanpham.dart';

void main() {
  runApp(const MyApp());
}

ValueNotifier<String> langNotifier = ValueNotifier('vi');
ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

bool isDark(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark;

const Map<String, Map<String, String>> localizedStrings = {
  'vi': {
    'login_title': 'Đăng nhập',
    'username': 'Tên đăng nhập',
    'password': 'Mật khẩu',
    'login_btn': 'ĐĂNG NHẬP',
    'settings': 'Cài đặt hệ thống',
    'dark_mode': 'Chế độ tối',
    'language': 'Ngôn ngữ',
    'logout': 'Đăng xuất',
    'tab_home': 'Trang chủ',
    'tab_favorite': 'Yêu thích',
    'tab_account': 'Tài khoản',
    'search_hint': 'Tìm kiếm sản phẩm...',
    'cat_all': 'Tất cả',
    'cat_phone': 'Điện thoại',
    'cat_laptop': 'Laptop',
    'cat_accessory': 'Phụ kiện',
    'cat_watch': 'Đồng hồ',
    'no_product': 'Không tìm thấy sản phẩm nào',
    'added': 'Đã thêm',
    'to_cart': 'vào giỏ hàng',
    'dashboard_title': 'Tổng quan hệ thống',
  },
  'en': {
    'login_title': 'Login',
    'username': 'Username',
    'password': 'Password',
    'login_btn': 'LOG IN',
    'settings': 'System Settings',
    'dark_mode': 'Dark Mode',
    'language': 'Language',
    'logout': 'Log out',
    'tab_home': 'Home',
    'tab_favorite': 'Favorites',
    'tab_account': 'Account',
    'search_hint': 'Search products...',
    'cat_all': 'All',
    'cat_phone': 'Phones',
    'cat_laptop': 'Laptops',
    'cat_accessory': 'Accessories',
    'cat_watch': 'Watches',
    'no_product': 'No products found',
    'added': 'Added',
    'to_cart': 'to cart',
    'dashboard_title': 'System Dashboard',
  }
};

String tr(String key) {
  return localizedStrings[langNotifier.value]?[key] ?? key;
}

void showMessage(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(msg), duration: const Duration(seconds: 1)),
  );
}

void go(BuildContext context, Widget screen) {
  Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, themeMode, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'ShopEasy App',
          themeMode: themeMode,
          theme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: const Color(0xFF1E3A8A),
            brightness: Brightness.light,
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: const Color(0xFF1E3A8A),
            brightness: Brightness.dark,
          ),
          home: const LoginScreen(),
        );
      },
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final userCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool obscurePass = true;

  void handleLogin() {
    if (userCtrl.text.trim().isEmpty || passCtrl.text.trim().isEmpty) {
      showMessage(context, 'Vui lòng nhập đầy đủ thông tin');
      return;
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const ProductListScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            child: Padding(
              padding: const EdgeInsets.all(28.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E3A8A).withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.shopping_bag_rounded, size: 60, color: Color(0xFF1E3A8A)),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'ShopEasy',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A)),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: userCtrl,
                    decoration: InputDecoration(
                      labelText: tr('username'),
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: passCtrl,
                    obscureText: obscurePass,
                    decoration: InputDecoration(
                      labelText: tr('password'),
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(obscurePass ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() => obscurePass = !obscurePass),
                      ),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E3A8A),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: handleLogin,
                      child: Text(tr('login_btn'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// =====================================================
// MÀN HÌNH TÀI KHOẢN & CÀI ĐẶT (SETTINGS SCREEN REDESIGNED)
// =====================================================
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool enableNotification = true;

  // Dialog xác nhận đăng xuất
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Đăng xuất'),
        content: const Text('Bạn có chắc chắn muốn đăng xuất khỏi tài khoản này?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            child: const Text('Đăng xuất'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = isDark(context);

    return ValueListenableBuilder<String>(
      valueListenable: langNotifier,
      builder: (context, lang, _) {
        return SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 30),
          child: Column(
            children: [
              // 1. HEADER USER PROFILE
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                decoration: const BoxDecoration(
                  color: Color(0xFF1E3A8A),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(28),
                  ),
                ),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage('https://i.pravatar.cc/300?img=12'),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Colors.amber,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.edit, size: 14, color: Colors.black87),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Mai Thị Hà',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '23T1020147@husc.edu.vn',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.2),
                        border: Border.all(color: Colors.amber, width: 1.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.workspace_premium, color: Colors.amber, size: 16),
                          SizedBox(width: 6),
                          Text(
                            'Thành viên Kim Cương 💎',
                            style: TextStyle(
                              color: Colors.amber,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 3. KHỐI ĐƠN HÀNG CỦA TÔI
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Đơn hàng của tôi',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            InkWell(
                              onTap: () {},
                              child: const Text(
                                'Xem lịch sử >',
                                style: TextStyle(fontSize: 12, color: Color(0xFF1E3A8A), fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildOrderBadge(Icons.payment_outlined, 'Chờ xác nhận', '2'),
                            _buildOrderBadge(Icons.inventory_2_outlined, 'Chờ lấy hàng', '1'),
                            _buildOrderBadge(Icons.local_shipping_outlined, 'Đang giao', '3'),
                            _buildOrderBadge(Icons.star_outline, 'Đánh giá', ''),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // 4. DANH MỤC CÀI ĐẶT
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 4, bottom: 8),
                      child: Text(
                        'Tài khoản & Bảo mật',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.grey),
                      ),
                    ),
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.person_outline, color: Color(0xFF1E3A8A)),
                            title: const Text('Thông tin cá nhân'),
                            trailing: const Icon(Icons.chevron_right, size: 20),
                            onTap: () {},
                          ),
                          const Divider(height: 1, indent: 50),
                          ListTile(
                            leading: const Icon(Icons.location_on_outlined, color: Color(0xFF1E3A8A)),
                            title: const Text('Sổ địa chỉ nhận hàng'),
                            trailing: const Icon(Icons.chevron_right, size: 20),
                            onTap: () {},
                          ),
                          const Divider(height: 1, indent: 50),
                          ListTile(
                            leading: const Icon(Icons.credit_card_outlined, color: Color(0xFF1E3A8A)),
                            title: const Text('Tài khoản ngân hàng / Ví'),
                            trailing: const Icon(Icons.chevron_right, size: 20),
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    const Padding(
                      padding: EdgeInsets.only(left: 4, bottom: 8),
                      child: Text(
                        'Cài đặt hệ thống',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.grey),
                      ),
                    ),
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Column(
                        children: [
                          SwitchListTile(
                            title: Text(tr('dark_mode')),
                            secondary: const Icon(Icons.dark_mode_outlined, color: Color(0xFF1E3A8A)),
                            value: themeNotifier.value == ThemeMode.dark,
                            onChanged: (val) {
                              themeNotifier.value = val ? ThemeMode.dark : ThemeMode.light;
                            },
                          ),
                          const Divider(height: 1, indent: 50),
                          ListTile(
                            leading: const Icon(Icons.language_outlined, color: Color(0xFF1E3A8A)),
                            title: Text(tr('language')),
                            trailing: DropdownButton<String>(
                              value: lang,
                              underline: const SizedBox(),
                              items: const [
                                DropdownMenuItem(value: 'vi', child: Text('Tiếng Việt')),
                                DropdownMenuItem(value: 'en', child: Text('English')),
                              ],
                              onChanged: (val) {
                                if (val != null) langNotifier.value = val;
                              },
                            ),
                          ),
                          const Divider(height: 1, indent: 50),
                          SwitchListTile(
                            title: const Text('Thông báo ứng dụng'),
                            secondary: const Icon(Icons.notifications_none_outlined, color: Color(0xFF1E3A8A)),
                            value: enableNotification,
                            onChanged: (val) => setState(() => enableNotification = val),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // 5. NÚT ĐĂNG XUẤT
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.redAccent, width: 1.5),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        icon: const Icon(Icons.logout, color: Colors.redAccent),
                        label: Text(
                          tr('logout'),
                          style: const TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        onPressed: () => _showLogoutDialog(context),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF1E3A8A)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
      ],
    );
  }

  Widget _buildOrderBadge(IconData icon, String label, String badgeCount) {
    return Column(
      children: [
        Badge(
          label: badgeCount.isNotEmpty ? Text(badgeCount) : null,
          isLabelVisible: badgeCount.isNotEmpty,
          child: Icon(icon, size: 26, color: const Color(0xFF1E3A8A)),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 11)),
      ],
    );
  }
}