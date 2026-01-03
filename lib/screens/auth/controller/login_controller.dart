import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../home_screen.dart';

class LoginController extends GetxController {
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

  void login() {
    if (!formKey.currentState!.validate()) return;

    loading.value = true;

    Future.delayed(const Duration(seconds: 1), () {
      loading.value = false;
      Get.offAll(() => const HomeScreen());
    });
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}

