class ProductModel {
  final String productId;
  final String name;
  final String categoryId;
  final int price;
  final String? imageUrl;

  ProductModel({
    required this.productId,
    required this.name,
    required this.categoryId,
    required this.price,
    this.imageUrl,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      productId: json['productId'],
      name: json['name'],
      categoryId: json['categoryId'],
      price: json['price'],
      imageUrl: json['imageUrl'],
    );
  }
}
