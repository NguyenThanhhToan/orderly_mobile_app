import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orderly/router/app_route.dart';
import 'package:orderly/screens/home/controller/home_controller.dart';
import 'package:orderly/screens/tableDetail/controller/table_detail_controller.dart';
import 'package:orderly/screens/tableDetail/widget/order_item_card.dart';
import 'package:orderly/screens/tableDetail/widget/payment_preview_dialog.dart';

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

    return PopScope(
      onPopInvokedWithResult: (didPop, result) async {
        if (Get.isRegistered<HomeController>()) {
          await Get.find<HomeController>().reloadTables();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Bàn ${controller.table.tableCode ?? ''}'),
          centerTitle: true,
        ),

        // ===== MULTI FAB =====
        bottomNavigationBar: Obx(() {
          final order = controller.activeOrder.value;
          final isPaid = order?.status == 'PAID';

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  if (!isPaid)
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.check),
                        label: const Text('Xác nhận'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.confirmOrder,
                      ),
                    ),
                  if (!isPaid) const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('Thêm món'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {
                        Get.toNamed(AppRoutes.menu);
                      },
                    ),
                  ),
                ],
              ),
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
              child: Text('Chưa có đơn hàng', style: TextStyle(fontSize: 16)),
            );
          }

          final bool isPaid = order.status == 'PAID';

          /// ===== GROUP ITEMS BY BATCH =====
          final items = order.items ?? [];
          final Map<int, List<dynamic>> itemsByBatch = {};

          for (final item in items) {
            final batch = item.batchNo ?? 0;
            itemsByBatch.putIfAbsent(batch, () => []);
            itemsByBatch[batch]!.add(item);
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

                    /// ===== BUTTON AREA =====
                    if (!isPaid)
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.payment),
                              label: const Text('Thanh toán'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: controller.isLoading.value
                                  ? null
                                  : () {
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (_) => PaymentPreviewDialog(
                                          order: order,
                                          controller: controller,
                                        ),
                                      );
                                    },
                            ),
                          ),

                          const SizedBox(width: 12),              
                          Expanded(
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.cancel, color: Colors.white),
                              label: const Text(
                                'Huỷ bàn',
                                style: TextStyle(color: Colors.white),
                              ),
  
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: controller.isLoading.value
                                  ? null
                                  : () {
                                      showDialog(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                          title: const Text('Xác nhận'),
                                          content: const Text(
                                            'Bạn có chắc chắn muốn huỷ bàn này không?',
                                          ),
                                          actions: [
                                            TextButton(
                                              child: const Text('Không'),
                                              onPressed: () => Navigator.pop(context),
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.red,
                                              ),
                                              child: const Text('Huỷ bàn'),
                                              onPressed: () {
                                                Navigator.pop(context);
                                                controller.cancelOrder();
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                            ),
                          ),
                        ],
                      )
                    else
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.check_circle, color: Colors.green),
                          label: const Text('Đã thanh toán'),
                          onPressed: null,
                        ),
                      ),
                  ],
                ),
              ),


              const SizedBox(height: 12),

              // ===== LIST ITEMS BY BATCH =====
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

                    ...(() {
                      final sortedBatches = itemsByBatch.entries.toList()
                        ..sort((a, b) => b.key.compareTo(a.key)); // 🔥 batch mới nhất lên đầu

                      return sortedBatches.map((entry) {
                        final batchNo = entry.key;
                        final batchItems = entry.value;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ===== BATCH HEADER =====
                            Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(top: 12, bottom: 8),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: batchNo == order.currentBatchNo
                                    ? Colors.orange.shade100
                                    : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '🧾 Lần gọi món #$batchNo',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),

                            // ===== ITEMS =====
                            ...batchItems.map(
                              (item) => OrderItemCard(
                                item: item,
                                onTap: controller.openItemActions,
                                onRemove: isPaid
                                    ? null
                                    : (item) {
                                        controller.removeItemFromOrder(item.orderItemId);
                                      },
                              ),
                            ),
                          ],
                        );
                      });
                    })(),
                  ],
                ),
              ),

            ],
          );
        }),
      ),
    );
  }
}
