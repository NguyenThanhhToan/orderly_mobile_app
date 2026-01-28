import 'package:get/get.dart';
import 'package:orderly/data/model/order_item_model.dart';
import 'package:orderly/data/model/table.dart';
import 'package:orderly/data/model/order_model.dart';
import 'package:orderly/service/order_service/order_service.dart';

class TableDetailController extends GetxController {
  final OrderService _orderService = OrderService();

  late final TableModel table;

  final isLoading = false.obs;
  final activeOrder = Rxn<OrderModel>();

  @override
  void onInit() {
    super.onInit();

    table = Get.arguments as TableModel;

    loadActiveOrder();
  }

  void openItemActions(OrderItemModel item) {
    print('Tapped item: ${item.productName}');
    print('Item ID: ${item.orderItemId}');
  }

  Future<void> addProductToOrder({
    required String productId,
    required int quantity,
    String? notes,
  }) async {
    try {
      final order = activeOrder.value;

      if (order == null) {
        Get.snackbar('Lỗi', 'Chưa có order đang hoạt động');
        return;
      }

      isLoading.value = true;

      final updatedOrder = await _orderService.addProductToOrder(
        order.orderId,
        productId,
        quantity,
        notes ?? '',
      );

      activeOrder.value = updatedOrder;

      activeOrder.refresh();
      Get.snackbar('Thành công', 'Thêm món thành công');

    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể thêm món');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> removeItemFromOrder(String itemId) async {
    try {
      final order = activeOrder.value;

      if (order == null) {
        Get.snackbar('Lỗi', 'Chưa có order đang hoạt động');
        return;
      }

      isLoading.value = true;

      final updatedOrder = await _orderService.removeProductFromOrder(
        order.orderId,
        itemId,
      );

      activeOrder.value = updatedOrder;
      activeOrder.refresh();

      Get.snackbar('Thành công', 'Đã xoá món');

    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể xoá món');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadActiveOrder() async {
    try {
      isLoading.value = true;
      final order = await _orderService.getActiveOrderByTable(table.id);
      activeOrder.value = order;
    } catch (e) {
      activeOrder.value = null;
    } finally {
      isLoading.value = false;
    }
  }
}
