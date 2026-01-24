// lib/config/dio_config.dart
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:orderly/config/auth_interceptor.dart';
import 'package:orderly/config/token_storage.dart';
import 'package:orderly/config/logger_interceptor.dart';

class DioConfig {
  static Dio createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: dotenv.env['BASE_URL'] ?? '',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      AuthInterceptor(
        getToken: () => TokenStorage.getToken(),
      ),
    );

    dio.interceptors.add(
      LoggerInterceptor(),
    );

    return dio;
  }
}
