import 'package:orderly/config/api_provider.dart';
import 'package:orderly/data/model/order_model.dart';
import 'package:orderly/data/type/api_responses.dart';

class OrderService {
  final api = ApiProvider.apiClient;

  Future<OrderModel> getActiveOrderByTable(String tableId) async {
    final response = await api.get(
      '/orders/tables/$tableId/active',
    );

    final apiResponse = ApiResponse<OrderModel>.fromJson(
      response.data,
      (json) => OrderModel.fromJson(json),
    );

    if (!apiResponse.succeed || apiResponse.data == null) {
      throw Exception(apiResponse.message ?? 'Get active order failed');
    }

    return apiResponse.data!;
  }

  Future<OrderModel> openOrderByTable(String tableId) async {
    final response = await api.post(
      '/orders/tables/$tableId/open',
    );

    final apiResponse = ApiResponse<OrderModel>.fromJson(
      response.data,
      (json) => OrderModel.fromJson(json),
    );

    if (!apiResponse.succeed || apiResponse.data == null) {
      throw Exception(apiResponse.message ?? 'Get active order failed');
    }

    return apiResponse.data!;
  }


  Future<OrderModel> addProductToOrder(String orderId, String productId, int quantity, String notes) async {
    final response = await api.post(
      '/orders/$orderId/items',
      body: {
        'productId': productId,
        'quantity': quantity,
        'notes': notes,
      },
    );

    final apiResponse = ApiResponse<OrderModel>.fromJson(
      response.data,
      (json) => OrderModel.fromJson(json),
    );

    if (!apiResponse.succeed || apiResponse.data == null) {
      throw Exception(apiResponse.message ?? 'Add product to order failed');
    }
    return apiResponse.data!;
  }  

  Future<OrderModel> removeProductFromOrder(String orderId, String orderItemId) async {
    final response = await api.delete(
      '/orders/$orderId/items/$orderItemId',
    );

    final apiResponse = ApiResponse<OrderModel>.fromJson(
      response.data,
      (json) => OrderModel.fromJson(json),
    );

    if (!apiResponse.succeed || apiResponse.data == null) {
      throw Exception(apiResponse.message ?? 'Delete product from order failed');
    }
    return apiResponse.data!;
  }  

  Future<OrderModel> confirmOrder(String orderId) async {
    final response = await api.post(
      '/orders/$orderId/confirm',
    );

    final apiResponse = ApiResponse<OrderModel>.fromJson(
      response.data,
      (json) => OrderModel.fromJson(json),
    );

    if (!apiResponse.succeed || apiResponse.data == null) {
      throw Exception(apiResponse.message ?? 'Confirm order failed');
    }

    return apiResponse.data!;
  }

  Future<OrderModel> cancelOrder(String orderId) async {
    final response = await api.post(
      '/orders/$orderId/cancel',
    );

    final apiResponse = ApiResponse<OrderModel>.fromJson(
      response.data,
      (json) => OrderModel.fromJson(json),
    );

    if (!apiResponse.succeed || apiResponse.data == null) {
      throw Exception(apiResponse.message ?? 'Confirm order failed');
    }

    return apiResponse.data!;
  }

  Future<OrderModel> payOrder(String orderId) async {
    final response = await api.post(
      '/orders/$orderId/pay',
    );

    final apiResponse = ApiResponse<OrderModel>.fromJson(
      response.data,
      (json) => OrderModel.fromJson(json),
    );

    if (!apiResponse.succeed || apiResponse.data == null) {
      throw Exception(apiResponse.message ?? 'Pay order failed');
    }

    return apiResponse.data!;
  }
}
