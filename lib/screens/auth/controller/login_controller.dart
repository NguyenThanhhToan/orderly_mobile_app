import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orderly/service/authService/auth_service.dart';
import '../../home_screen.dart';

class LoginController extends GetxController {
  final AuthService authService;

  LoginController(this.authService);

  final formKey = GlobalKey<FormState>();

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  final loading = false.obs;

  String? validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập tên đăng nhập';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập mật khẩu';
    }
    if (value.length < 6) {
      return 'Mật khẩu tối thiểu 6 ký tự';
    }
    return null;
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    loading.value = true;

    try {
      await authService.login(
        email: usernameController.text.trim(),
        password: passwordController.text.trim(),
      );

      Get.offAll(() => const HomeScreen());
    } catch (e) {
      Get.snackbar(
        'Đăng nhập thất bại',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.black,
      );
    } finally {
      loading.value = false;
    }
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
