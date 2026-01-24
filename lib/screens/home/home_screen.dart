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
    print( "home.tables: =========${home.tables}");

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

        if (home.isTableLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (home.tables.isEmpty) {
          return const Center(child: Text('Không có bàn nào'));
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

              Expanded(
                child: GridView.builder(
                  itemCount: home.tables.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (context, index) {
                    final table = home.tables[index];

                    return TableCard(
                      table: table,
                      onTap: () {
                        print('Clicked table: ${table.tableCode}');
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
