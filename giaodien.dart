import 'package:flutter/material.dart';
import 'sanpham.dart';

void main() {
  runApp(const MyApp());
}

// =====================================================
// NGÔN NGỮ & CHẾ ĐỘ TỐI/SÁNG (GLOBAL NOTIFIERS)
// =====================================================
ValueNotifier<String> langNotifier = ValueNotifier('vi');
ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

bool isDark(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark;

// Từ điển đa ngôn ngữ
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

// =====================================================
// ROOT APP
// =====================================================
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

// =====================================================
// MÀN HÌNH ĐĂNG NHẬP
// =====================================================
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final userCtrl = TextEditingController();
  final passCtrl = TextEditingController();

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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.shopping_bag, size: 80, color: Color(0xFF1E3A8A)),
              const SizedBox(height: 16),
              const Text(
                'ShopEasy',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: userCtrl,
                decoration: InputDecoration(
                  labelText: tr('username'),
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passCtrl,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: tr('password'),
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E3A8A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: handleLogin,
                  child: Text(tr('login_btn'), style: const TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =====================================================
// MÀN HÌNH CÀI ĐẶT (TAB TÀI KHOẢN)
// =====================================================
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: langNotifier,
      builder: (context, lang, _) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              tr('settings'),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: Text(tr('dark_mode')),
              secondary: const Icon(Icons.dark_mode),
              value: themeNotifier.value == ThemeMode.dark,
              onChanged: (val) {
                themeNotifier.value = val ? ThemeMode.dark : ThemeMode.light;
              },
            ),
            ListTile(
              leading: const Icon(Icons.language),
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
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: Text(tr('logout'), style: const TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }
}