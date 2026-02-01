import 'package:get/get.dart';
import 'package:orderly/data/model/table.dart';
import 'package:orderly/service/tableService/table_service.dart';

class HomeController extends GetxController {
  final TableService _tableService = TableService();

  final RxList<TableModel> tables = <TableModel>[].obs;
  final RxBool isTableLoading = false.obs;

  final RxInt currentPage = 0.obs;
  final int pageSize = 9; // 3 cột x 3 hàng cho đẹp UI
  final RxBool hasMore = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadTables(page: 0);
  }

  Future<void> reloadTables() async {
    currentPage.value = 0;
    hasMore.value = true;
    await loadTables(page: 0);
  }

  Future<void> loadTables({required int page}) async {
    if (isTableLoading.value) return;

    try {
      isTableLoading.value = true;

      final tableList = await _tableService.getTables(
        page: page,
        size: pageSize,
      );

      tables.assignAll(tableList);

      currentPage.value = page;
      hasMore.value = tableList.length == pageSize;
    } catch (e) {
      tables.clear();
      rethrow;
    } finally {
      isTableLoading.value = false;
    }
  }

  void nextPage() {
    if (hasMore.value) {
      loadTables(page: currentPage.value + 1);
    }
  }

  void previousPage() {
    if (currentPage.value > 0) {
      loadTables(page: currentPage.value - 1);
    }
  }
}
