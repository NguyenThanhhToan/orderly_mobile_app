import 'package:get/get.dart';
import 'package:orderly/data/model/product_model.dart';
import 'package:orderly/service/productService/product_service.dart';

class MenuPageController extends GetxController {
  final ProductService _productService = Get.find();

  final isLoading = true.obs;
  final products = <ProductModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadProducts();
  }

  Future<void> loadProducts() async {
    try {
      isLoading.value = true;
      products.value = await _productService.getProducts();
    } finally {
      isLoading.value = false;
    }
  }

  List<ProductModel> byCategory(String categoryId) {
    return products
        .where((p) => p.categoryId == categoryId)
        .toList();
  }

  
}
