import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  final Future<String?> Function() getToken;

  AuthInterceptor({required this.getToken});

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final publicPaths = [
      '/auth/login',
      '/auth/register',
    ];

    final isPublic = publicPaths.any((path) {
      final requestPath = options.path;
      return requestPath.endsWith(path) || 
             requestPath.contains(path) ||
             options.uri.path.endsWith(path);
    });

    if (!isPublic) {
      final token = await getToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }

    super.onRequest(options, handler);
  }
}