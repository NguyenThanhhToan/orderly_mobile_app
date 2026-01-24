import 'package:dio/dio.dart';

class LoggerInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final method = options.method.toUpperCase();
    final url = options.uri.toString();

    print('$method: $url');

    if (options.data != null) {
      print('DATA: ${options.data}');
    }

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('STATUS: ${response.statusCode}');

    if (response.data != null) {
      print('RESPONSE: ${response.data}');
    }

    print('------------------------------');

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final status = err.response?.statusCode;
    final path = err.requestOptions.uri.toString();
    final method = err.requestOptions.method.toUpperCase();
    final responseData = err.response?.data;

    print('❌ FAIL: $method $path');
    print('❌ STATUS: $status');
    print('❌ ERROR: ${err.message}');

    if (responseData != null) {
      print('❌ RESPONSE: $responseData');
    }

    print('------------------------------');

    super.onError(err, handler);
  }
}
