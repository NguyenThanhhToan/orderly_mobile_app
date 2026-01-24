import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orderly/state/auth_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trang chủ'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Center(
        child: Obx(() {
          final user = auth.user.value;

          if (user == null) {
            return const CircularProgressIndicator();
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.home,
                size: 80,
                color: Colors.blue,
              ),
              const SizedBox(height: 20),
              Text(
                'Xin chào ${user.fullName}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Đây là màn hình chính của ứng dụng',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          );
        }),
      ),
    );
  }
}
