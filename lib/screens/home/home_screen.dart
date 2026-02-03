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
      backgroundColor: Colors.grey.shade100,

      // ===== APP BAR =====
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Obx(() {
          final user = auth.user.value;
          return Text(
            user?.fullName ?? 'Nhân viên',
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          );
        }),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: () {
              auth.logout();
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
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
          child: Column(
            children: [
              // ===== HEADER CARD =====
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.table_bar, size: 36, color: Colors.blue),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Xin chào, ${user.fullName}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Chọn bàn để bắt đầu phục vụ',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // ===== GRID TABLE =====
              Expanded(
                child: RefreshIndicator(
                  onRefresh: home.reloadTables,
                  child: home.tables.isEmpty
                      ? ListView(
                          physics:
                              const AlwaysScrollableScrollPhysics(),
                          children: const [
                            SizedBox(height: 200),
                            Center(
                              child: Text(
                                'Không có bàn nào',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
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
                            childAspectRatio: 1,
                          ),
                          itemBuilder: (context, index) {
                            final table = home.tables[index];
                            return TableCard(table: table);
                          },
                        ),
                ),
              ),

              const SizedBox(height: 8),

              // ===== PAGINATION BAR =====
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Obx(() {
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
              ),
            ],
          ),
        );
      }),
    );
  }
}
