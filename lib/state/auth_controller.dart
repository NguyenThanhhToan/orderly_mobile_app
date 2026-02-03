import 'package:get/get.dart';
import 'package:orderly/config/token_storage.dart';
import 'package:orderly/data/model/user.dart';
import 'package:orderly/router/app_route.dart';
import 'package:orderly/service/userService/user_service.dart';


class AuthController extends GetxController {
  final UserService _userService = UserService();

  final Rx<UserModel?> user = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;

  bool get isAuthenticated => user.value != null;

  Future<bool> checkLoginStatus() async {
    try {
      final token = await TokenStorage.getToken();
      if (token != null && token.isNotEmpty) {
        await loadUserProfile();
        return true;
      }
      return false;
    } catch (e) {
      print('Error checking login status: $e');
      return false;
    }
  }

  Future<void> loadUserProfile() async {
    try {
      isLoading.value = true;
      final userData = await _userService.getUserProfile();
      user.value = userData;
    } catch (e) {
      user.value = null;
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  void clear() {
    user.value = null;
  }

  Future<void> logout() async {
    await TokenStorage.clear();
    user.value = null;
    Get.offAllNamed(AppRoutes.login);
  }
}
