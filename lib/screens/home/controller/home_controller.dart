import 'package:get/get.dart';
import 'package:orderly/data/model/table.dart';
import 'package:orderly/service/tableService/table_service.dart';

class HomeController extends GetxController {
  final TableService _tableService = TableService();

  final RxList<TableModel> tables = <TableModel>[].obs;
  final RxBool isTableLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadTables();
  }

  Future<void> loadTables() async {
    try {
      isTableLoading.value = true;
      final tableList = await _tableService.getTables();
      print("tableList==========================: ${tableList}");
      tables.assignAll(tableList);
    } catch (e) {
      print("tableList==========================: ${e}");
      tables.clear();
      rethrow;
    } finally {
      isTableLoading.value = false;
    }
  }
}
