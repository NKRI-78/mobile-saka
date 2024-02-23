import 'package:saka/data/models/store/cart_add.dart';

class CategoryProductModel {
  CategoryProductModel({
    this.code,
    this.message,
    this.count,
    this.first,
    this.body,
  });

  int? code;
  String? message;
  int? count;
  bool? first;
  List<CategoryProductList>? body;

  factory CategoryProductModel.fromJson(Map<String, dynamic> json) =>
    CategoryProductModel(
      code: json["code"],
      message: json["message"],
      count: json["count"],
      first: json["first"],
      body: json["body"] == null ? [] : List<CategoryProductList>.from(json["body"].map((x) => CategoryProductList.fromJson(x))),
    );
}

class CategoryProductList {
  CategoryProductList({
    this.id,
    this.name,
    this.picture,
    this.childs,
    this.numOfProducts,
    this.classId,
  });

  String? id;
  String? name;
  Picture? picture;
  List<CategoryProductList>? childs;
  int? numOfProducts;
  String? classId;

  factory CategoryProductList.fromJson(Map<String, dynamic> json) => CategoryProductList(
    id: json["id"],
    name: json["name"],
    picture: Picture.fromJson(json["picture"]),
    childs: json["childs"] == null ? [] : List<CategoryProductList>.from(json["childs"].map((x) => CategoryProductList.fromJson(x))),
    numOfProducts: json["numOfProducts"],
    classId: json["classId"],
  );
}

class PictureCategory {
  PictureCategory({
    this.originalName,
    this.fileLength,
    this.path,
    this.contentType,
  });

  String? originalName;
  int? fileLength;
  String? path;
  String? contentType;

  factory PictureCategory.fromJson(Map<String, dynamic> json) =>
    PictureCategory(
      originalName: json["originalName"],
      fileLength: json["fileLength"],
      path: json["path"],
      contentType: json["contentType"],
    );

}
