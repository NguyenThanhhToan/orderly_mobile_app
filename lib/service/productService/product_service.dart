import 'package:orderly/config/api_provider.dart';
import 'package:orderly/data/model/product_model.dart';

class ProductService {
  final api = ApiProvider.apiClient;

  Future<List<ProductModel>> getProducts() async {
    final response = await api.get('/products');

    final List items = response.data['data']['items'];

    return items
        .map((e) => ProductModel.fromJson(e))
        .toList();
  }
}
