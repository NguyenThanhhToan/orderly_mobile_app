import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orderly/screens/tableDetail/controller/table_detail_controller.dart';
import 'package:orderly/screens/tableDetail/widget/order_item_card.dart';

class TableDetailScreen extends StatelessWidget {
  const TableDetailScreen({super.key});

  String formatCurrency(int? value) {
    if (value == null) return '0 đ';
    return '${value.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    )} đ';
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TableDetailController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Bàn ${controller.table.tableCode ?? ''}'),
        centerTitle: true,
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final order = controller.activeOrder.value;

        // Nếu chưa có order
        if (order == null) {
          return const Center(
            child: Text(
              'Chưa có đơn hàng',
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        return Column(
          children: [
            // ===== ORDER HEADER =====
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order ID: ${order.orderId}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text('Trạng thái: ${order.status ?? ''}'),
                  const SizedBox(height: 6),
                  Text('Tổng món: ${order.totalItems ?? 0}'),
                  Text(
                    'Tổng tiền: ${formatCurrency(order.totalAmount)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ===== LIST ITEMS =====
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const Text(
                    'Danh sách món',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 12),

                  ...order.items?.map((item) => OrderItemCard(
                    item: item,
                    onTap: (item) {
                      controller.openItemActions(item);
                    },
                    onRemove: (item) {
                      controller.removeItem(item.orderItemId);
                    },
                  )) ?? [],
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
