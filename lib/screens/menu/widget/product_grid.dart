import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:orderly/data/model/product_model.dart';
import 'package:orderly/screens/tableDetail/controller/table_detail_controller.dart';
import 'product_card.dart';

class ProductGrid extends StatelessWidget {
  final List<ProductModel> products;

  const ProductGrid({
    super.key,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const Center(child: Text('Không có sản phẩm'));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.7,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemBuilder: (_, index) {
        return ProductCard(
          product: products[index],
          onTap: (productId) {
            _showAddToOrderDialog(context, products[index]);
          },
        );
      },
    );
  }
}

void _showAddToOrderDialog(BuildContext context, ProductModel product) {
  final qty = ValueNotifier<int>(1);
  final noteController = TextEditingController();

  final tableDetailController = Get.find<TableDetailController>();

  showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(product.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (product.imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  product.imageUrl!,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),

            const SizedBox(height: 12),

            // UNIT PRICE
            Text(
              '${product.price} đ / món',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 6),

            // TOTAL PRICE
            ValueListenableBuilder<int>(
              valueListenable: qty,
              builder: (_, value, __) {
                final total = product.price * value;

                return Text(
                  '$total đ',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.orange,
                  ),
                );
              },
            ),

            const SizedBox(height: 14),

            // QUANTITY
            ValueListenableBuilder<int>(
              valueListenable: qty,
              builder: (_, value, __) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        if (qty.value > 1) qty.value--;
                      },
                      icon: const Icon(Icons.remove_circle_outline),
                    ),
                    Text(
                      value.toString(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        qty.value++;
                      },
                      icon: const Icon(Icons.add_circle_outline),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 12),

            // NOTE
            TextField(
              controller: noteController,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: 'Thêm ghi chú...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),

        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Huỷ'),
          ),

          ElevatedButton(
            onPressed: () async {
              final quantity = qty.value;
              final note = noteController.text;

              await tableDetailController.addProductToOrder(
                productId: product.productId,
                quantity: quantity,
                notes: note,
              );

              Navigator.pop(context);
            },
            child: const Text('Thêm món'),
          ),
        ],
      );
    },
  );
}
