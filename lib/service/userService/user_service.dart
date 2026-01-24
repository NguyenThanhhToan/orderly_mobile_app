import 'package:orderly/config/api_provider.dart';
import 'package:orderly/data/model/user.dart';
import 'package:orderly/data/type/api_responses.dart';

class UserService{
  final api = ApiProvider.apiClient;

  Future<UserModel> getUserProfile() async {
    final response = await api.get(
      '/users/me',
    );

    final apiResponse = ApiResponse<UserModel>.fromJson(
      response.data,
      (json) => UserModel.fromJson(json),
    );

    if (!apiResponse.succeed || apiResponse.data == null) {
      throw Exception(apiResponse.message ?? 'Get user failed');
    }

    return apiResponse.data!;
  }
}
