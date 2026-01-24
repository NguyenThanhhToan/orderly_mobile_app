import 'order_item_model.dart';

class OrderModel {
  final String orderId; // NOT NULL
  final String? tableId;
  final String? status;
  final int? currentBatchNo;
  final int? totalAmount;
  final int? totalQuantity;
  final DateTime? createdAt;
  final DateTime? confirmedAt;
  final DateTime? cancelledAt;
  final String? orderItemId;
  final List<OrderItemModel>? items;
  final int? totalItems;

  OrderModel({
    required this.orderId,
    this.tableId,
    this.status,
    this.currentBatchNo,
    this.totalAmount,
    this.totalQuantity,
    this.createdAt,
    this.confirmedAt,
    this.cancelledAt,
    this.orderItemId,
    this.items,
    this.totalItems,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderId: json['orderId'] ?? '',
      tableId: json['tableId'],
      status: json['status'],
      currentBatchNo: json['currentBatchNo'],
      totalAmount: json['totalAmount'],
      totalQuantity: json['totalQuantity'],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      confirmedAt: json['confirmedAt'] != null
          ? DateTime.tryParse(json['confirmedAt'])
          : null,
      cancelledAt: json['cancelledAt'] != null
          ? DateTime.tryParse(json['cancelledAt'])
          : null,
      orderItemId: json['orderItemId'],
      items: (json['items'] as List?)
          ?.map((e) => OrderItemModel.fromJson(e))
          .toList(),
      totalItems: json['totalItems'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'tableId': tableId,
      'status': status,
      'currentBatchNo': currentBatchNo,
      'totalAmount': totalAmount,
      'totalQuantity': totalQuantity,
      'createdAt': createdAt?.toIso8601String(),
      'confirmedAt': confirmedAt?.toIso8601String(),
      'cancelledAt': cancelledAt?.toIso8601String(),
      'orderItemId': orderItemId,
      'items': items?.map((e) => e.toJson()).toList(),
      'totalItems': totalItems,
    };
  }
}
