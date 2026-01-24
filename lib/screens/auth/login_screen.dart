import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orderly/state/auth_controller.dart';
import 'controller/login_controller.dart';
import 'package:orderly/widget/app_button.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final controller = Get.find<LoginController>();
  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đăng nhập'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: controller.formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: controller.usernameController,
                decoration: const InputDecoration(
                  labelText: 'Tên đăng nhập',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: controller.validateUsername,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: controller.passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Mật khẩu',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                validator: controller.validatePassword,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: Obx(
                  () => AppButton(
                    text: 'ĐĂNG NHẬP',
                    loading: controller.loading.value,
                    onPressed:
                        controller.loading.value ? null : controller.login,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
