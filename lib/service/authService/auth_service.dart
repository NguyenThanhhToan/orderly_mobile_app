import 'package:orderly/config/api_provider.dart';
import 'package:orderly/config/token_storage.dart';
import 'package:orderly/data/type/api_responses.dart';
import 'package:orderly/data/type/login_responses.dart';

class AuthService{
  final api = ApiProvider.apiClient;

  Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {
    final response = await api.post(
      '/auth/login',
      body: {
        'email': email,
        'password': password,
      },
    );

    final apiResponse = ApiResponse<LoginResponse>.fromJson(
      response.data,
      (json) => LoginResponse.fromJson(json),
    );

    if (!apiResponse.succeed || apiResponse.data == null) {
      throw Exception(apiResponse.message ?? 'Login failed');
    }

    await TokenStorage.saveToken(apiResponse.data!.token);
    return apiResponse.data!;
  }

  Future<void> logout() async {
    await TokenStorage.clear();
  }
}
