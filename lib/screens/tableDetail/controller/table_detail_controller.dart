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

    ever<OrderModel?>(activeOrder, (order) {
      if (order != null && order.status == 'PAID') {
        Future.microtask(() {
          if (Get.isOverlaysOpen) {
            Get.back(closeOverlays: true);
          }

          if (Get.key.currentState?.canPop() ?? false) {
            Get.back();
          }
        });
      }
    });

    loadActiveOrder();
  }

  void openItemActions(OrderItemModel item) {
    print('Tapped item: ${item.productName}');
    print('Item ID: ${item.orderItemId}');
  }

  Future<void> loadActiveOrder() async {
    try {
      isLoading.value = true;

      if (table.status == 'OCCUPIED') {
        final order = await _orderService.getActiveOrderByTable(table.id);
        activeOrder.value = order;
      } else if (table.status == 'AVAILABLE') {
        await _orderService.openOrderByTable(table.id);
        final order = await _orderService.getActiveOrderByTable(table.id);
        activeOrder.value = order;
      }

      activeOrder.refresh();
    } catch (e) {
      activeOrder.value = null;
      Get.snackbar('Lỗi', 'Không thể tải đơn hàng');
    } finally {
      isLoading.value = false;
    }
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

  Future<void> confirmOrder() async {
    try {
      final order = activeOrder.value;
      if (order == null) {
        Get.snackbar('Lỗi', 'Không có đơn hàng để xác nhận');
        return;
      }

      isLoading.value = true;

      await _orderService.confirmOrder(order.orderId);
      final updatedOrder =
          await _orderService.getActiveOrderByTable(table.id);

      activeOrder.value = updatedOrder;
      activeOrder.refresh();

      Get.snackbar('Thành công', 'Đã xác nhận đơn hàng');
    } catch (e) {
      Get.snackbar('Lỗi', 'Xác nhận đơn hàng thất bại');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> cancelOrder() async {
    try {
      final order = activeOrder.value;
      if (order == null) {
        Get.snackbar('Lỗi', 'Không có bàn để hủy');
        return;
      }

      isLoading.value = true;

      await _orderService.cancelOrder(order.orderId);
      final updatedOrder =
          await _orderService.getActiveOrderByTable(table.id);

      activeOrder.value = updatedOrder;
      activeOrder.refresh();

      Get.snackbar('Thành công', 'Đã hủy bàn');
    } catch (e) {
      Get.snackbar('Lỗi', 'Hủy bàn thất bại');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> payOrder() async {
    try {
      final order = activeOrder.value;
      if (order == null) {
        Get.snackbar('Lỗi', 'Không có đơn hàng để thanh toán');
        return;
      }

      isLoading.value = true;

      final paidOrder = await _orderService.payOrder(order.orderId);

      activeOrder.value = paidOrder;
      activeOrder.refresh();

      Get.snackbar('Thành công', 'Thanh toán thành công');
    } catch (e) {
      Get.snackbar('Lỗi', 'Thanh toán thất bại');
    } finally {
      isLoading.value = false;
    }
  }
}
