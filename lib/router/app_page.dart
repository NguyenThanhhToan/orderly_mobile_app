import 'package:get/get.dart';
import 'package:orderly/screens/auth/controller/login_controller.dart';
import 'package:orderly/screens/auth/login_screen.dart';
import 'package:orderly/screens/home/controller/home_controller.dart';
import 'package:orderly/screens/home/home_screen.dart';
import 'package:orderly/screens/tableDetail/table_detail_screen.dart';
import 'package:orderly/service/authService/auth_service.dart';
import 'package:orderly/state/auth_controller.dart';
import 'package:orderly/screens/tableDetail/controller/table_detail_controller.dart';
import 'app_route.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.login,
      page: () => LoginScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => LoginController(Get.find(), Get.find()));
        Get.lazyPut(() => AuthService());
      }),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => AuthController());
        Get.lazyPut(() => HomeController());
      }),
    ),
     GetPage(
      name: AppRoutes.tableDetail,
      page: () => const TableDetailScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => TableDetailController());
      }),
    ),
  ];
}