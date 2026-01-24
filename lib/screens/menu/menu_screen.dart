import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller/menu_page_controller.dart';
import 'widget/menu_tab_view.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final menu = Get.find<MenuPageController>();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Đơn đẹp'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Nước uống'),
              Tab(text: 'Đồ ăn'),
            ],
          ),
        ),
        body: Obx(() {
          if (menu.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return const MenuTabView();
        }),
      ),
    );
  }
}
