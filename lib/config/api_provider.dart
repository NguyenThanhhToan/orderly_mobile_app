// lib/config/api_provider.dart
import 'package:orderly/config/api_client.dart';
import 'package:orderly/config/dio_config.dart';

class ApiProvider {
  static final ApiClient apiClient =
      ApiClient(DioConfig.createDio());
}
