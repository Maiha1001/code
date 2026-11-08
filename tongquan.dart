import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final stats = [
      {'title': 'Đơn hàng', 'value': '128', 'icon': Icons.shopping_bag, 'color': Colors.blue},
      {'title': 'Doanh thu', 'value': '45.2M', 'icon': Icons.attach_money, 'color': Colors.green},
      {'title': 'Khách hàng', 'value': '1,240', 'icon': Icons.people, 'color': Colors.orange},
      {'title': 'Sản phẩm', 'value': '86', 'icon': Icons.inventory, 'color': Colors.purple},
    ];

    final orders = [
      {'id': '#DH-9012', 'customer': 'Nguyễn Văn A', 'status': 'Đã giao', 'color': Colors.green},
      {'id': '#DH-9011', 'customer': 'Trần Thị B', 'status': 'Đang giao', 'color': Colors.blue},
      {'id': '#DH-9010', 'customer': 'Lê Văn C', 'status': 'Chờ xử lý', 'color': Colors.orange},
      {'id': '#DH-9009', 'customer': 'Phạm Thị D', 'status': 'Đã hủy', 'color': Colors.red},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tổng quan hệ thống'),
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Các thẻ thống kê (Grid 2x2)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.3,
              ),
              itemCount: stats.length,
              itemBuilder: (context, i) {
                final item = stats[i];
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundColor: (item['color'] as Color).withAlpha(40),
                          child: Icon(item['icon'] as IconData, color: item['color'] as Color),
                        ),
                        const Spacer(),
                        Text(
                          item['value'] as String,
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          item['title'] as String,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // Tiêu đề đơn hàng gần đây
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Đơn hàng gần đây',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('Xem tất cả'),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Danh sách đơn hàng
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: orders.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final order = orders[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFF1F5F9),
                    child: Icon(Icons.receipt_long, color: Color(0xFF1E3A8A)),
                  ),
                  title: Text(order['id'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(order['customer'] as String),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: (order['color'] as Color).withAlpha(40),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      order['status'] as String,
                      style: TextStyle(
                        color: order['color'] as Color,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}