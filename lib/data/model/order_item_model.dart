class OrderItemModel {
  final String orderItemId;
  final String? productId;
  final String? productName;
  final String? imageUrl;
  final int? quantity;
  final int? unitPrice;
  final int? totalPrice;
  final String? notes;

  OrderItemModel({
    required this.orderItemId,
    this.productId,
    this.productName,
    this.imageUrl,
    this.quantity,
    this.unitPrice,
    this.totalPrice,
    this.notes,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      orderItemId: json['orderItemId'] ?? '',
      productId: json['productId'],
      productName: json['productName'],
      imageUrl: json['imageUrl'],
      quantity: json['quantity'],
      unitPrice: json['unitPrice'],
      totalPrice: json['totalPrice'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderItemId': orderItemId,
      'productId': productId,
      'productName': productName,
      'imageUrl': imageUrl,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'totalPrice': totalPrice,
      'notes': notes,
    };
  }
}
