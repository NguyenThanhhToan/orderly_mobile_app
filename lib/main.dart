import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:orderly/router/app_page.dart';
import 'package:orderly/router/app_route.dart';

void main() {
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
      initialRoute: AppRoutes.login,
      getPages: AppPages.routes,
    );
  }
}