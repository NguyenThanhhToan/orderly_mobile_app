import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orderly/data/model/order_model.dart';
import 'package:orderly/screens/tableDetail/controller/table_detail_controller.dart';

class PaymentPreviewDialog extends StatelessWidget {
  final OrderModel order;
  final TableDetailController controller;

  const PaymentPreviewDialog({
    super.key,
    required this.order,
    required this.controller,
  });

  String formatCurrency(int? value) {
    if (value == null) return '0 đ';
    return '${value.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    )} đ';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: const Text(
        'Xác nhận thanh toán',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ===== LIST ITEMS =====
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: order.items?.length ?? 0,
                separatorBuilder: (_, __) =>
                    Divider(color: Colors.grey.shade300),
                itemBuilder: (_, index) {
                  final item = order.items![index];
                  final total =
                      (item.totalPrice ?? 0);

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          item.productName ?? '',
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Text(
                        'x${item.quantity}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        formatCurrency(total),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            // ===== TOTAL =====
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Tổng thanh toán',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    formatCurrency(order.totalAmount),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Huỷ'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () async {
            Get.back();
            await controller.payOrder();
          },
          child: const Text('Xác nhận'),
        ),
      ],
    );
  }
}
