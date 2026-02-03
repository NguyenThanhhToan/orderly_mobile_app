import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:orderly/router/app_page.dart';
import 'package:orderly/router/app_route.dart';
import 'package:orderly/state/auth_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');

  // Initialize token storage and auth controller
  final authController = Get.put(AuthController(), permanent: true);
  
  // Check if user is logged in
  final isLoggedIn = await authController.checkLoginStatus();

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Orderly App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      // Set initial route based on login status
      initialRoute: isLoggedIn ? AppRoutes.home : AppRoutes.login,
      getPages: AppPages.routes,
    );
  }
}