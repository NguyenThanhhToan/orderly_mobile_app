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

  Future<void> openOrder() async {
    try {
      isLoading.value = true;

      final newOrder = await _orderService.openOrderByTable(table.id);

      activeOrder.value = newOrder;
      activeOrder.refresh();

      Get.snackbar('Thành công', 'Đã mở bàn ${table.tableCode}');
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể mở bàn');
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

  Future<void> loadActiveOrder() async {
    try {
      isLoading.value = true;

      // ===== BÀN ĐANG CÓ NGƯỜI =====
      if (table.status == 'OCCUPIED') {
        final order = await _orderService.getActiveOrderByTable(table.id);
        activeOrder.value = order;
      }

      // ===== BÀN TRỐNG → MỞ BÀN → LẤY ORDER =====
      else if (table.status == 'AVAILABLE') {
        // 1. Open order
        await _orderService.openOrderByTable(table.id);

        // 2. Lấy order vừa mở
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

  Future<void> confirmOrder() async {
    try {
      final order = activeOrder.value;

      if (order == null) {
        Get.snackbar('Lỗi', 'Không có đơn hàng để xác nhận');
        return;
      }

      isLoading.value = true;

      final updatedOrder =
          await _orderService.confirmOrder(order.orderId);

      activeOrder.value = updatedOrder;
      activeOrder.refresh();

      Get.snackbar('Thành công', 'Đã xác nhận đơn hàng');
    } catch (e) {
      Get.snackbar('Lỗi', 'Xác nhận đơn hàng thất bại');
    } finally {
      isLoading.value = false;
    }
  }
}
