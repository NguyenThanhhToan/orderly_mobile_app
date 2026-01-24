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

  void removeItem(String? itemId) {
    print('Remove item ID: $itemId');
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
