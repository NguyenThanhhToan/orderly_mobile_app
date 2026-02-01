import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orderly/router/app_route.dart';
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

      // ===== MULTI FAB =====
      floatingActionButton: Obx(() {
        final order = controller.activeOrder.value;
        final isPaid = order?.status == 'PAID';

        return Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ===== CONFIRM BUTTON =====
              if (!isPaid)
                Transform.scale(
                  scale: 1.2,
                  child: FloatingActionButton(
                    heroTag: 'confirm',
                    backgroundColor: Colors.orange,
                    onPressed: controller.isLoading.value
                        ? null
                        : controller.confirmOrder,
                    child: const Icon(Icons.check, size: 28),
                  ),
                ),

              const SizedBox(height: 16),

              // ===== ADD PRODUCT BUTTON =====
              Transform.scale(
                scale: 1.2,
                child: FloatingActionButton(
                  heroTag: 'add',
                  onPressed: () {
                    Get.toNamed(AppRoutes.menu);
                  },
                  child: const Icon(Icons.add, size: 30),
                ),
              ),
            ],
          ),
        );
      }),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final order = controller.activeOrder.value;

        if (order == null) {
          return const Center(
            child: Text(
              'Chưa có đơn hàng',
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        final bool isPaid = order.status == 'PAID';

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

                  Text('Tổng món: ${order.totalItems ?? 0}'),
                  const SizedBox(height: 6),

                  Text(
                    'Tổng tiền: ${formatCurrency(order.totalAmount)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.green,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ===== PAY BUTTON =====
                  if (!isPaid)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.payment),
                        label: const Text('Thanh toán'),
                        style: ElevatedButton.styleFrom(
                          padding:
                              const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.payOrder,
                      ),
                    )
                  else
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.check_circle,
                            color: Colors.green),
                        label: const Text('Đã thanh toán'),
                        onPressed: null,
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
                        onTap: controller.openItemActions,
                        onRemove: isPaid
                            ? null
                            : (item) {
                                controller
                                    .removeItemFromOrder(item.orderItemId);
                              },
                      )) ??
                      [],
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
