import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:orderly/router/app_page.dart';
import 'package:orderly/router/app_route.dart';
import 'package:orderly/state/auth_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Orderly App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),

      initialBinding: BindingsBuilder(() {
        Get.put<AuthController>(
          AuthController(),
          permanent: true,
        );
      }),

      initialRoute: AppRoutes.login,
      getPages: AppPages.routes,
    );
  }
}
