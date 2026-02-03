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
          title: const Text(
            'Menu',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          elevation: 0,
          bottom: const TabBar(
            indicatorSize: TabBarIndicatorSize.label,
            indicatorWeight: 3,
            indicatorColor: Colors.orange,
            labelColor: Colors.orange,
            unselectedLabelColor: Colors.grey,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
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
