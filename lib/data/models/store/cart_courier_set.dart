class CartCourierSetModel {
  CartCourierSetModel({
    this.code,
    this.message,
    this.data,
    this.error,
  });

  int? code;
  String? message;
  CartCourierSetData? data;
  dynamic error;

  factory CartCourierSetModel.fromJson(Map<String, dynamic> json) => CartCourierSetModel(
    code: json["code"],
    message: json["message"],
    data: CartCourierSetData.fromJson(json["body"]),
    error: json["error"],
  );
}

class CartCourierSetData {
  CartCourierSetData({
    this.id,
    this.userId,
    this.numOfItems,
    this.stores,
    this.serviceCharge,
    this.shippingAddress,
    this.totalProductPrice,
    this.totalDeliveryCost,
    this.classId,
  });

  String? id;
  String? userId;
  int? numOfItems;
  List<CartCourierStoreElement>? stores;
  int? serviceCharge;
  CartCourierShippingAddress? shippingAddress;
  int? totalProductPrice;
  int? totalDeliveryCost;
  String? classId;

  factory CartCourierSetData.fromJson(Map<String, dynamic> json) => CartCourierSetData(
    id: json["id"],
    userId: json["userId"],
    numOfItems: json["numOfItems"],
    stores: json["stores"] == null ? [] : List<CartCourierStoreElement>.from(json["stores"].map((x) => CartCourierStoreElement.fromJson(x))),
    serviceCharge: json["serviceCharge"],
    shippingAddress: CartCourierShippingAddress.fromJson(json["shippingAddress"]),
    totalProductPrice: json["totalProductPrice"],
    totalDeliveryCost: json["totalDeliveryCost"],
    classId: json["classId"],
  );
}

class CartCourierShippingAddress {
  CartCourierShippingAddress({
    this.id,
    this.phoneNumber,
    this.address,
    this.postalCode,
    this.province,
    this.city,
    this.subdistrict,
    this.village,
    this.defaultLocation,
    this.location,
    this.name,
    this.classId,
  });

  String? id;
  String? phoneNumber;
  String? address;
  String? postalCode;
  String? province;
  String? city;
  String? subdistrict;
  String? village;
  bool? defaultLocation;
  List<double>? location;
  String? name;
  String? classId;

  factory CartCourierShippingAddress.fromJson(Map<String, dynamic> json) => CartCourierShippingAddress(
    id: json["id"],
    phoneNumber: json["phoneNumber"],
    address: json["address"],
    postalCode: json["postalCode"],
    province: json["province"],
    city: json["city"],
    subdistrict: json["subdistrict"],
    village: json["village"],
    defaultLocation: json["defaultLocation"],
    location: List<double>.from(json["location"].map((x) => x.toDouble())),
    name: json["name"],
    classId: json["classId"],
  );
}

class CartCourierStoreElement {
  CartCourierStoreElement({
    this.storeId,
    this.invoiceNo,
    this.store,
    this.shippingRate,
    this.items,
    this.classId,
  });

  String? storeId;
  String? invoiceNo;
  CartCourierStoreStore? store;
  CartCourierShippingRate? shippingRate;
  List<CartCourierItem>? items;
  String? classId;

  factory CartCourierStoreElement.fromJson(Map<String, dynamic> json) => CartCourierStoreElement(
    storeId: json["storeId"],
    invoiceNo: json["invoiceNo"],
    store: CartCourierStoreStore.fromJson(json["store"]),
    shippingRate: CartCourierShippingRate.fromJson(json["shippingRate"]),
    items: json["items"] == null ? [] : List<CartCourierItem>.from(json["items"].map((x) => CartCourierItem.fromJson(x))),
    classId: json["classId"],
  );
}

class CartCourierItem {
  CartCourierItem({
    this.productId,
    this.product,
    this.storeId,
    this.quantity,
    this.price,
    this.sellerPrice,
    this.note,
    this.classId,
  });

  String? productId;
  CartCourierProduct? product;
  String? storeId;
  int? quantity;
  dynamic price;
  dynamic sellerPrice;
  String? note;
  String? classId;

  factory CartCourierItem.fromJson(Map<String, dynamic> json) => CartCourierItem(
    productId: json["productId"],
    product: CartCourierProduct.fromJson(json["product"]),
    storeId: json["storeId"],
    quantity: json["quantity"],
    price: json["price"],
    sellerPrice: json["sellerPrice"],
    note: json["note"],
    classId: json["classId"],
  );
}

class CartCourierProduct {
  CartCourierProduct({
    this.id,
    this.name,
    this.price,
    this.pictures,
    this.weight,
    this.discount,
    this.stock,
    this.minOrder,
    this.stats,
    this.harmful,
    this.liquid,
    this.flammable,
    this.fragile,
    this.classId,
  });

  String? id;
  String? name;
  double? price;
  List<CartCourierPicture>? pictures;
  int? weight;
  dynamic discount;
  int? stock;
  int? minOrder;
  CartCourierStats? stats;
  bool? harmful;
  bool? liquid;
  bool? flammable;
  bool? fragile;
  String? classId;

  factory CartCourierProduct.fromJson(Map<String, dynamic> json) => CartCourierProduct(
    id: json["id"],
    name: json["name"],
    price: json["price"],
    pictures: json["pictures"] == null ? [] : List<CartCourierPicture>.from(json["pictures"].map((x) => CartCourierPicture.fromJson(x))),
    weight: json["weight"],
    discount: json["discount"],
    stock: json["stock"],
    minOrder: json["minOrder"],
    stats: json["stats"] == null ? CartCourierStats() :  CartCourierStats.fromJson(json["stats"]),
    harmful: json["harmful"],
    liquid: json["liquid"],
    flammable: json["flammable"],
    fragile: json["fragile"],
    classId: json["classId"],
  );
}

class CartCourierPicture {
  CartCourierPicture({
    this.originalName,
    this.fileLength,
    this.path,
    this.contentType,
    this.classId,
  });

    String? originalName;
    int? fileLength;
    String? path;
    String? contentType;
    String? classId;

  factory CartCourierPicture.fromJson(Map<String, dynamic> json) => CartCourierPicture(
    originalName: json["originalName"],
    fileLength: json["fileLength"],
    path: json["path"],
    contentType: json["contentType"],
    classId: json["classId"],
  );
}

class CartCourierStats {
  CartCourierStats({
    this.ratingMax,
    this.ratingAvg,
    this.numOfReview,
    this.numOfSold,
    this.ratings,
    this.classId,
  });

  dynamic ratingMax;
  dynamic ratingAvg;
  dynamic numOfReview;
  dynamic numOfSold;
  List<Rating>? ratings;
  String? classId;

  factory CartCourierStats.fromJson(Map<String, dynamic> json) => CartCourierStats(
    ratingMax: json["ratingMax"],
    ratingAvg: json["ratingAvg"],
    numOfReview: json["numOfReview"],
    numOfSold: json["numOfSold"],
    ratings: json["ratings"] == null ? [] : List<Rating>.from(json["ratings"].map((x) => Rating.fromJson(x))),
    classId: json["classId"],
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

class CartCourierShippingRate {
  CartCourierShippingRate({
    this.rateId,
    this.courierId,
    this.courierName,
    this.courierLogo,
    this.serviceName,
    this.serviceDesc,
    this.serviceType,
    this.serviceLevel,
    this.price,
    this.estimateDays,
  });

  String? rateId;
  String? courierId;
  String? courierName;
  String? courierLogo;
  String? serviceName;
  String? serviceDesc;
  String? serviceType;
  String? serviceLevel;
  double? price;
  String? estimateDays;

  factory CartCourierShippingRate.fromJson(Map<String, dynamic> json) => CartCourierShippingRate(
    rateId: json["rateId"],
    courierId: json["courierId"],
    courierName: json["courierName"],
    courierLogo: json["courierLogo"],
    serviceName: json["serviceName"],
    serviceDesc: json["serviceDesc"],
    serviceType: json["serviceType"],
    serviceLevel: json["serviceLevel"],
    price: json["price"],
    estimateDays: json["estimateDays"],
  );
}

class CartCourierStoreStore {
  CartCourierStoreStore({
    this.id,
    this.owner,
    this.name,
    this.description,
    this.open,
    this.picture,
    this.status,
    this.province,
    this.city,
    this.subdistrict,
    this.village,
    this.postalCode,
    this.address,
    this.email,
    this.phone,
    this.level,
    this.location,
    this.supportedCouriers,
    this.classId,
  });

  String? id;
  String? owner;
  String? name;
  String? description;
  bool? open;
  CartCourierPicture? picture;
  int? status;
  String? province;
  String? city;
  String? subdistrict;
  String? village;
  String? postalCode;
  String? address;
  String? email;
  String? phone;
  String? level;
  List<double>? location;
  List<SupportedCourier>? supportedCouriers;
  String? classId;

  factory CartCourierStoreStore.fromJson(Map<String, dynamic> json) => CartCourierStoreStore(
    id: json["id"],
    owner: json["owner"],
    name: json["name"],
    description: json["description"],
    open: json["open"],
    picture: CartCourierPicture.fromJson(json["picture"]),
    status: json["status"],
    province: json["province"],
    city: json["city"],
    subdistrict: json["subdistrict"],
    village: json["village"],
    postalCode: json["postalCode"],
    address: json["address"],
    email: json["email"],
    phone: json["phone"],
    level: json["level"],
    location: List<double>.from(json["location"].map((x) => x.toDouble())),
    supportedCouriers: List<SupportedCourier>.from(json["supportedCouriers"].map((x) => SupportedCourier.fromJson(x))),
    classId: json["classId"],
  );
}

class SupportedCourier {
  SupportedCourier({
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

  factory SupportedCourier.fromJson(Map<String, dynamic> json) => SupportedCourier(
    id: json["id"],
    name: json["name"],
    image: json["image"],
    checkPriceSupported: json["checkPriceSupported"],
    checkResiSupported: json["checkResiSupported"],
    classId: json["classId"],
  );
}
