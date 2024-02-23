import 'package:saka/data/models/store/category_product.dart';
import 'package:saka/data/models/store/seller_store.dart';

class ProductStoreModel {
  ProductStoreModel({
    this.code,
    this.message,
    this.count,
    this.first,
    this.body,
    this.error
  });

  int? code;
  String? message;
  int? count;
  bool? first;
  List<ProductStoreList>? body;
  dynamic error;

  factory ProductStoreModel.fromJson(Map<String, dynamic> json) =>
  ProductStoreModel(
    code: json["code"],
    message: json["message"],
    count: json["count"],
    first: json["first"],
    body: json["body"] == null ? [] : List<ProductStoreList>.from(json["body"].map((x) => ProductStoreList.fromJson(x))),
    error: json["error"]
  );
}

class ProductStoreList {
  ProductStoreList({
    this.id,
    this.name,
    this.images,
    this.category,
    this.price,
    this.adminCharge,
    this.pictures,
    this.owner,
    this.store,
    this.weight,
    this.description,
    this.stock,
    this.condition,
    this.minOrder,
    this.status,
    this.stats,
    this.discount,
    this.favored,
    this.classId,
  });

  String? id;
  String? name;
  String? images;
  CategoryProductList? category;
  double? price;
  double? adminCharge;
  List<PictureProductStore>? pictures;
  String? owner;
  Store? store;
  int? weight;
  String? description;
  int? stock;
  String? condition;
  int? minOrder;
  int? status;
  Stats? stats;
  Discount? discount;
  bool? favored;
  String? classId;

  factory ProductStoreList.fromJson(Map<String, dynamic> json) =>
    ProductStoreList(
      id: json["id"],
      name: json["name"],
      category: CategoryProductList.fromJson(json["category"]),
      price: json["price"],
      adminCharge: json["adminCharge"],
      pictures: List<PictureProductStore>.from(
        json["pictures"].map((x) => PictureProductStore.fromJson(x))
      ),
      owner: json["owner"],
      store: Store.fromJson(json["store"]),
      weight: json["weight"],
      description: json["description"],
      stock: json["stock"],
      condition: json["condition"],
      minOrder: json["minOrder"],
      status: json["status"],
      stats: Stats.fromJson(json["stats"]),
      discount: json["discount"] == null 
      ? null
      : Discount.fromJson(json["discount"]),
      favored: json["favored"],
      classId: json["classId"],
    );
}

class CategoryProductStore {
  CategoryProductStore({
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
  List<dynamic>? childs;
  int? numOfProducts;
  String? classId;

  factory CategoryProductStore.fromJson(Map<String, dynamic> json) =>
  CategoryProductStore(
    id: json["id"],
    name: json["name"],
    picture: Picture.fromJson(json["picture"]),
    childs: List<dynamic>.from(json["childs"].map((x) => x)),
    numOfProducts: json["numOfProducts"],
    classId: json["classId"],
  );
}

class PictureProductStore {
  PictureProductStore({
    this.originalName,
    this.fileLength,
    this.path,
    this.contentType,
  });

  String? originalName;
  int? fileLength;
  String? path;
  String? contentType;

  factory PictureProductStore.fromJson(Map<String, dynamic> json) =>
    PictureProductStore(
      originalName: json["originalName"],
      fileLength: json["fileLength"],
      path: json["path"],
      contentType: json["contentType"],
    );
}

class Discount {
  Discount({
    this.discount,
    this.startDate,
    this.endDate,
    this.active,
  });

  double? discount;
  String? startDate;
  String? endDate;
  bool? active;

  factory Discount.fromJson(Map<String, dynamic> json) => Discount(
    discount: json["discount"],
    startDate: json["startDate"],
    endDate: json["endDate"],
    active: json["active"],
  );
}

class Stats {
  Stats({
    this.ratingMax,
    this.ratingAvg,
    this.numOfReview,
    this.numOfSold,
    this.ratings,
  });

  double? ratingMax;
  double? ratingAvg;
  int? numOfReview;
  int? numOfSold;
  List<Rating>? ratings;

  factory Stats.fromJson(Map<String, dynamic> json) => Stats(
    ratingMax: json["ratingMax"],
    ratingAvg: json["ratingAvg"].toDouble(),
    numOfReview: json["numOfReview"],
    numOfSold: json["numOfSold"],
    ratings: List<Rating>.from(json["ratings"].map((x) => Rating.fromJson(x))),
  );
}

class Rating {
  Rating({
    this.star,
    this.count,
  });

  dynamic star;
  dynamic count;

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
    star: json["star"],
    count: json["count"],
  );
}

class Store {
  Store({
    this.id,
    this.owner,
    this.name,
    this.description,
    this.open,
    this.picture,
    this.status,
    this.province,
    this.city,
    this.postalCode,
    this.address,
    this.location,
    this.supportedCouriers,
    this.classId,
  });

  String? id;
  String? owner;
  String? name;
  String? description;
  bool? open;
  Picture? picture;
  int? status;
  String? province;
  String? city;
  String? postalCode;
  String? address;
  List<double>? location;
  List<SupportedCourier>? supportedCouriers;
  String? classId;

  factory Store.fromJson(Map<String, dynamic> json) => Store(
    id: json["id"],
    owner: json["owner"],
    name: json["name"],
    description: json["description"],
    open: json["open"],
    picture: Picture.fromJson(json["picture"]),
    status: json["status"],
    province: json["province"],
    city: json["city"],
    postalCode: json["postalCode"],
    address: json["address"],
    location: List<double>.from(json["location"].map((x) => x.toDouble())),
    supportedCouriers: List<SupportedCourier>.from(json["supportedCouriers"].map((x) => SupportedCourier.fromJson(x))),
    classId: json["classId"],
  );
}

class SupportedCourierProduct {
  SupportedCourierProduct({
    this.id,
    this.name,
    this.image,
    this.checkPriceSupported,
    this.checkResiSupported,
    this.classId,
  });

  String? id;
  String? name;
  String? image;
  bool? checkPriceSupported;
  bool? checkResiSupported;
  String? classId;

  factory SupportedCourierProduct.fromJson(Map<String, dynamic> json) =>
    SupportedCourierProduct(
      id: json["id"],
      name: json["name"],
      image: json["image"],
      checkPriceSupported: json["checkPriceSupported"],
      checkResiSupported: json["checkResiSupported"],
      classId: json["classId"],
    );
}
