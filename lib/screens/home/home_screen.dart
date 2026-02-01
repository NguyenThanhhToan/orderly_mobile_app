import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orderly/screens/home/controller/home_controller.dart';
import 'package:orderly/state/auth_controller.dart';
import 'package:orderly/screens/home/widget/table_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    final home = Get.find<HomeController>();

    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          final user = auth.user.value;
          return Text(user?.fullName ?? 'Nhân viên');
        }),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Get.offAllNamed('/login');
            },
          ),
        ],
      ),
      body: Obx(() {
        final user = auth.user.value;

        if (user == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (home.isTableLoading.value && home.tables.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Xin chào ${user.fullName}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              /// GRID + PULL TO REFRESH
              Expanded(
                child: RefreshIndicator(
                  onRefresh: home.reloadTables,
                  child: home.tables.isEmpty
                      ? ListView(
                          physics:
                              const AlwaysScrollableScrollPhysics(),
                          children: const [
                            SizedBox(height: 200),
                            Center(child: Text('Không có bàn nào')),
                          ],
                        )
                      : GridView.builder(
                          physics:
                              const AlwaysScrollableScrollPhysics(),
                          itemCount: home.tables.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemBuilder: (context, index) {
                            final table = home.tables[index];
                            return TableCard(table: table);
                          },
                        ),
                ),
              ),

              const SizedBox(height: 8),

              /// PAGINATION BAR
              Obx(() {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: home.currentPage.value > 0
                          ? home.previousPage
                          : null,
                    ),
                    Text(
                      'Trang ${home.currentPage.value + 1}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: home.hasMore.value
                          ? home.nextPage
                          : null,
                    ),
                  ],
                );
              }),
            ],
          ),
        );
      }),
    );
  }
}