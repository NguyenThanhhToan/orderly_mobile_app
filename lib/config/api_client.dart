// lib/config/api_client.dart
import 'package:dio/dio.dart';

class ApiClient {
  final Dio dio;

  ApiClient(this.dio);

  Future<Response> get(
    String url, {
    Map<String, dynamic>? query,
  }) async {
    try {
      return await dio.get(url, queryParameters: query);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> post(
    String url, {
    dynamic body,
  }) async {
    try {
      return await dio.post(url, data: body);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException e) {
    final statusCode = e.response?.statusCode;
    final message =
        e.response?.data?['message'] ?? e.message ?? 'Unknown error';

    return Exception('[$statusCode] $message');
  }
}
