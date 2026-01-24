import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/menu_page_controller.dart';
import 'product_grid.dart';

class MenuTabView extends StatelessWidget {
  const MenuTabView({super.key});

  static const foodCategoryId = '11111111-1111-1111-1111-111111111111';
  static const drinkCategoryId = '22222222-2222-2222-2222-222222222222';

  @override
  Widget build(BuildContext context) {
    final menu = Get.find<MenuPageController>();

    return TabBarView(
      children: [
        ProductGrid(
          products: menu.byCategory(drinkCategoryId),
        ),
        ProductGrid(
          products: menu.byCategory(foodCategoryId),
        ),
      ],
    );
  }
}
