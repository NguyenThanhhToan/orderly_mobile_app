import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orderly/data/model/table.dart';
import 'package:orderly/router/app_route.dart';

class TableCard extends StatelessWidget {
  final TableModel table;

  const TableCard({
    super.key,
    required this.table,
  });

  bool get isAvailable => table.status == 'AVAILABLE';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        try {
          await Get.toNamed(
            AppRoutes.tableDetail,
            arguments: table,
          );
        } catch (e) {
          print('Navigation error: $e');
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: isAvailable ? Colors.white : Colors.orange.shade400,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade400),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(1, 2),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.table_restaurant,
              size: 30,
              color: isAvailable ? Colors.black : Colors.white,
            ),
            const SizedBox(height: 6),
            Text(
              table.tableCode ?? '--',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isAvailable ? Colors.black : Colors.white,
              ),
            ),
            if (table.capacity != null)
              Text(
                '${table.capacity} chỗ',
                style: TextStyle(
                  fontSize: 12,
                  color: isAvailable ? Colors.black54 : Colors.white70,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
