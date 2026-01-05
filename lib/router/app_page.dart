import 'package:get/get.dart';
import 'package:orderly/screens/auth/controller/login_controller.dart';
import 'package:orderly/screens/auth/login_screen.dart';
import 'package:orderly/screens/home_screen.dart';
import 'package:orderly/service/authService/auth_service.dart';
import 'app_route.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.login,
      page: () => LoginScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => LoginController(Get.find()));
        Get.lazyPut(() => AuthService());
      }),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
    ),
  ];
}