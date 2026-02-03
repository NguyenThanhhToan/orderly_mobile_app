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
      backgroundColor: Colors.grey[100],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: controller.formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// LOGO / ICON
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .primaryColor
                            .withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.restaurant,
                        size: 40,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      'Đăng nhập',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      'Vui lòng đăng nhập để tiếp tục',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),

                    const SizedBox(height: 24),

                    /// USERNAME
                    TextFormField(
                      controller: controller.usernameController,
                      decoration: InputDecoration(
                        labelText: 'Tên đăng nhập',
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: controller.validateUsername,
                    ),

                    const SizedBox(height: 16),

                    /// PASSWORD
                    Obx(
                      () => TextFormField(
                        controller: controller.passwordController,
                        obscureText: controller.isPasswordHidden.value,
                        decoration: InputDecoration(
                          labelText: 'Mật khẩu',
                          prefixIcon: const Icon(Icons.lock),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.isPasswordHidden.value
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: controller.togglePasswordVisibility,
                          ),
                        ),
                        validator: controller.validatePassword,
                      ),
                    ),

                    const SizedBox(height: 24),

                    /// BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: Obx(
                        () => AppButton(
                          text: 'ĐĂNG NHẬP',
                          loading: controller.loading.value,
                          onPressed: controller.loading.value
                              ? null
                              : controller.login,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
