import 'package:saka/data/models/store/product_store.dart';
import 'package:saka/data/models/store/seller_store.dart';


class ProductSingleStoreModel {
  ProductSingleStoreModel({
    this.code,
    this.message,
    this.body,
  });

  int? code;
  String? message;
  ProductStoreSingle? body;

  factory ProductSingleStoreModel.fromJson(Map<String, dynamic> json) =>
    ProductSingleStoreModel(
      code: json["code"],
      message: json["message"],
      body: ProductStoreSingle.fromJson(json["body"]),
    );
}

class ProductStoreSingle {
  ProductStoreSingle({
    this.id,
    this.name,
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
    this.harmful,
    this.liquid, 
    this.flammable,
    this.fragile,
    this.classId,
  });

  String? id;
  String? name;
  CategoryProductStoreSingle? category;
  double? price;
  double? adminCharge;
  List<PictureProductStore>? pictures;
  String? owner;
  StoreProductStoreSingle? store;
  int? weight;
  String? description;
  int? stock;
  String? condition;
  int? minOrder;
  int? status;
  Stats? stats;
  DiscountSingleProduct? discount;
  bool? harmful;
  bool? liquid;
  bool? flammable;
  bool? fragile;
  String? classId;

  factory ProductStoreSingle.fromJson(Map<String, dynamic> json) =>
  ProductStoreSingle(
    id: json["id"],
    name: json["name"],
    category: CategoryProductStoreSingle.fromJson(json["category"]),
    price: json["price"],
    adminCharge: json["adminCharge"],
    pictures: json["pictures"] == null ? [] : List<PictureProductStore>.from(json["pictures"].map((x) => PictureProductStore.fromJson(x))),
    owner: json["owner"],
    store: StoreProductStoreSingle.fromJson(json["store"]),
    weight: json["weight"],
    description: json["description"],
    stock: json["stock"],
    condition: json["condition"],
    minOrder: json["minOrder"],
    status: json["status"],
    stats: Stats.fromJson(json["stats"]),
    discount: json["discount"] == null 
    ? DiscountSingleProduct(
        discount: 0.0,
        active: false
      ) 
    : DiscountSingleProduct.fromJson(json["discount"]),
    harmful: json["harmful"],
    flammable: json["flammable"],
    fragile: json["fragile"],
    liquid: json["liquid"],
    classId: json["classId"],
  );

}

class CategoryProductStoreSingle {
  CategoryProductStoreSingle({
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

  factory CategoryProductStoreSingle.fromJson(Map<String, dynamic> json) =>
  CategoryProductStoreSingle(
    id: json["id"],
    name: json["name"],
    picture: Picture.fromJson(json["picture"]),
    childs: json["childs"] == null ? [] : List<dynamic>.from(json["childs"].map((x) => x)),
    numOfProducts: json["numOfProducts"],
    classId: json["classId"],
  );
}

class PictureProductStoreSingle {
  PictureProductStoreSingle({
    this.originalName,
    this.fileLength,
    this.path,
    this.contentType,
  });

  String? originalName;
  int? fileLength;
  String? path;
  String? contentType;

  factory PictureProductStoreSingle.fromJson(Map<String, dynamic> json) =>
  PictureProductStoreSingle(
    originalName: json["originalName"],
    fileLength: json["fileLength"],
    path: json["path"],
    contentType: json["contentType"],
  );
}

class DiscountSingleProduct {
  DiscountSingleProduct({
    this.discount,
    this.startDate,
    this.endDate,
    this.active,
  });

  double? discount;
  String? startDate;
  String? endDate;
  bool? active;

  factory DiscountSingleProduct.fromJson(Map<String, dynamic> json) =>
  DiscountSingleProduct(
    discount: json["discount"],
    startDate: json["startDate"],
    endDate: json["endDate"],
    active: json["active"],
  );
}

class StatsProductStoreSingle {
  StatsProductStoreSingle({
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
  List<RatingProductStoreSingle>? ratings;

  factory StatsProductStoreSingle.fromJson(Map<String, dynamic> json) =>
    StatsProductStoreSingle(
      ratingMax: json["ratingMax"],
      ratingAvg: json["ratingAvg"].toDouble(),
      numOfReview: json["numOfReview"],
      numOfSold: json["numOfSold"],
      ratings: json["ratings"] == null ? [] : List<RatingProductStoreSingle>.from(json["ratings"].map((x) => RatingProductStoreSingle.fromJson(x))),
    );

}

class RatingProductStoreSingle {
  RatingProductStoreSingle({
    this.star,
    this.count,
  });

  dynamic star;
  dynamic count;

  factory RatingProductStoreSingle.fromJson(Map<String, dynamic> json) =>
    RatingProductStoreSingle(
      star: json["star"],
      count: json["count"],
    );
}

class StoreProductStoreSingle {
  StoreProductStoreSingle({
    this.id,
    this.owner,
    this.name,
    this.description,
    this.open,
    this.picture,
    this.status,
    this.province,
    this.email,
    this.phone,
    this.city,
    this.subdistrict,
    this.village,
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
  String? email;
  String? phone;
  String? city;
  String? subdistrict;
  String? village;
  String? postalCode;
  String? address;
  List<double>? location;
  List<SupportedCourierProductStoreSingle>? supportedCouriers;
  String? classId;

  factory StoreProductStoreSingle.fromJson(Map<String, dynamic> json) =>
  StoreProductStoreSingle(
    id: json["id"],
    owner: json["owner"],
    name: json["name"],
    description: json["description"],
    open: json["open"],
    picture: Picture.fromJson(json["picture"]),
    status: json["status"],
    subdistrict: json["subdistrict"],
    province: json["province"],
    email: json["email"],
    phone: json["phone"],
    village: json["village"],
    city: json["city"],
    postalCode: json["postalCode"],
    address: json["address"],
    location: json["location"] == null ? [] : List<double>.from(json["location"].map((x) => x.toDouble())),
    supportedCouriers: json["supportedCouriers"] == null ? [] : List<SupportedCourierProductStoreSingle>.from(json["supportedCouriers"].map((x) => SupportedCourierProductStoreSingle.fromJson(x))),
    classId: json["classId"],
  );
}

class SupportedCourierProductStoreSingle {
  SupportedCourierProductStoreSingle({
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

  factory SupportedCourierProductStoreSingle.fromJson(Map<String, dynamic> json) =>
    SupportedCourierProductStoreSingle(
      id: json["id"],
      name: json["name"],
      image: json["image"],
      checkPriceSupported: json["checkPriceSupported"],
      checkResiSupported: json["checkResiSupported"],
      classId: json["classId"],
    );
}
