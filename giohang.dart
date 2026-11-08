import 'package:flutter/material.dart';
import 'sanpham.dart';

// Biến lưu trữ sản phẩm giỏ hàng
Map<Product, int> cart = {};

int get cartCount => cart.values.fold(0, (sum, count) => sum + count);

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final items = cart.entries.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Giỏ hàng của bạn'),
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
      ),
      body: items.isEmpty
          ? const Center(
              child: Text(
                'Giỏ hàng của bạn đang trống',
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final product = items[index].key;
                final count = items[index].value;

                return ListTile(
                  leading: CircleAvatar(
                    child: Text(product.name[0]),
                  ),
                  title: Text(product.name),
                  subtitle: Text('${product.price} x $count'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            if (count > 1) {
                              cart[product] = count - 1;
                            } else {
                              cart.remove(product);
                            }
                          });
                        },
                      ),
                      Text('$count', style: const TextStyle(fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            cart[product] = count + 1;
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}