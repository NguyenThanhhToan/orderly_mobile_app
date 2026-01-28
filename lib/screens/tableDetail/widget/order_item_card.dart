import 'package:flutter/material.dart';
import 'package:orderly/data/model/order_item_model.dart';

class OrderItemCard extends StatelessWidget {
  final OrderItemModel item;
  final Function(OrderItemModel item)? onTap;
  final Function(OrderItemModel item)? onLongPress;
  final Function(OrderItemModel item)? onRemove;

  const OrderItemCard({
    super.key,
    required this.item,
    this.onTap,
    this.onLongPress,
    this.onRemove,
  });

  String formatCurrency(int? value) {
    if (value == null) return '0 đ';
    return '${value.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    )} đ';
  }

  void _showRemoveConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Xoá món?'),
          content: Text(
            'Bạn có chắc muốn xoá "${item.productName}" khỏi order?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Huỷ'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                Navigator.pop(context);
                onRemove?.call(item);
              },
              child: const Text('Xoá'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap?.call(item),
      onLongPress: () => onLongPress?.call(item),
      child: Stack(
        children: [
          Card(
            margin: const EdgeInsets.only(bottom: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: item.imageUrl != null
                    ? Image.network(
                        item.imageUrl!,
                        width: 55,
                        height: 55,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.image_not_supported, size: 40),
                      )
                    : const Icon(Icons.fastfood, size: 40),
              ),

              title: Text(
                item.productName ?? '',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),

              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Số lượng: ${item.quantity ?? 0}'),

                  if (item.notes != null && item.notes!.isNotEmpty)
                    Text(
                      'Ghi chú: ${item.notes}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                ],
              ),

              trailing: Text(
                formatCurrency(item.totalPrice),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
          ),

          // ❌ Remove Button with Confirm
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () => _showRemoveConfirmDialog(context),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.red.shade600,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
