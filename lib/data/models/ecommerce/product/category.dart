class ProductCategoryModel {
  int status;
  bool error;
  String message;
  List<ProductCategoryData> data;

  ProductCategoryModel({
    required this.status,
    required this.error,
    required this.message,
    required this.data,
  });

  factory ProductCategoryModel.fromJson(Map<String, dynamic> json) => ProductCategoryModel(
    status: json["status"],
    error: json["error"],
    message: json["message"],
    data: List<ProductCategoryData>.from(json["data"].map((x) => ProductCategoryData.fromJson(x))),
  );
}

class ProductCategoryData {
  String id;
  String name;

  ProductCategoryData({
    required this.id,
    required this.name,
  });

  factory ProductCategoryData.fromJson(Map<String, dynamic> json) => ProductCategoryData(
    id: json["id"],
    name: json["name"],
  );
}
