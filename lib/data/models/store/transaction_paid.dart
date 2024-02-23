class TransactionStorePaidModel {
  TransactionStorePaidModel({
    this.code,
    this.message,
    this.count,
    this.first,
    this.body,
    this.error,
  });

  int? code;
  String? message;
  int? count;
  bool? first;
  List<TransactionStorePaidList>? body;
  dynamic error;

  factory TransactionStorePaidModel.fromJson(Map<String, dynamic> json) =>
  TransactionStorePaidModel(
    code: json["code"],
    message: json["message"],
    count: json["count"],
    first: json["first"],
    body: json["body"] == null ? [] : List<TransactionStorePaidList>.from(json["body"].map((x) => TransactionStorePaidList.fromJson(x))),
    error: json["error"],
  );

}

class TransactionStorePaidList {
  TransactionStorePaidList({
    this.id,
    this.refId,
    this.trxId,
    this.storeId,
    this.store,
    this.orderStatus,
    this.deliveryCost,
    this.invoiceNo,
    this.products,
    this.destShippingAddress,
    this.user,
    this.created,
    this.doneDate,
    this.wayBill,
    this.classId,
    this.sellerProductPrice,
    this.totalProductPrice,
  });

  String? id;
  String? refId;
  String? trxId;
  String? storeId;
  TransactionStorePaidStore? store;
  String? orderStatus;
  TransactionStorePaidDeliveryCost? deliveryCost;
  String? invoiceNo;
  List<ProductElement>? products;
  DestShippingAddress? destShippingAddress;
  TransactionStorePaidUser? user;
  String? created;
  String? doneDate;
  String? wayBill;
  String? classId;
  double? sellerProductPrice;
  double? totalProductPrice;

  factory TransactionStorePaidList.fromJson(Map<String, dynamic> json) =>
    TransactionStorePaidList(
      id: json["id"],
      refId: json["refId"],
      trxId: json["trxId"],
      storeId: json["storeId"],
      store: TransactionStorePaidStore.fromJson(json["store"]),
      orderStatus: json["orderStatus"],
      deliveryCost: TransactionStorePaidDeliveryCost.fromJson(json["deliveryCost"]),
      invoiceNo: json["invoiceNo"],
      products: json["products"] == null ? [] : List<ProductElement>.from(json["products"].map((x) => ProductElement.fromJson(x))),
      destShippingAddress: DestShippingAddress.fromJson(json["destShippingAddress"]),
      user: TransactionStorePaidUser.fromJson(json["user"]),
      created: json["created"],
      doneDate: json["doneDate"],
      wayBill: json["wayBill"],
      classId: json["classId"],
      sellerProductPrice: json["sellerProductPrice"],
      totalProductPrice: json["totalProductPrice"],
    );
}

class TransactionStorePaidDeliveryCost {
  TransactionStorePaidDeliveryCost({
    this.rateId,
    this.courierId,
    this.courierName,
    this.serviceName,
    this.serviceDesc,
    this.serviceType,
    this.serviceLevel,
    this.price,
    this.sellerPrice,
    this.estimateDays,
    this.classId,
  });

  String? rateId;
  String? courierId;
  String? courierName;
  String? serviceName;
  String? serviceDesc;
  String? serviceType;
  String? serviceLevel;
  double? price;
  double? sellerPrice;
  String? estimateDays;
  String?classId;

  factory TransactionStorePaidDeliveryCost.fromJson( Map<String, dynamic> json) =>
  TransactionStorePaidDeliveryCost(
    rateId: json["rateId"],
    courierId: json["courierId"],
    courierName: json["courierName"],
    serviceName: json["serviceName"],
    serviceDesc: json["serviceDesc"],
    serviceType: json["serviceType"],
    serviceLevel: json["serviceLevel"],
    price:  json["price"],
    sellerPrice: json["sellerPrice"],
    estimateDays: json["estimateDays"],
    classId: json["classId"],
  );
}

class DestShippingAddress {
  DestShippingAddress({
    this.name,
    this.phoneNumber,
    this.address,
    this.province,
    this.city,
    this.subdistrict,
    this.postalCode,
    this.village,
    this.location,
  });

  String? name;
  String? phoneNumber;
  String? address;
  String? province;
  String? village;
  String? city;
  String? subdistrict;
  String? postalCode;
  List<double>? location;

  factory DestShippingAddress.fromJson(Map<String, dynamic> json) =>
    DestShippingAddress(
      phoneNumber: json["phoneNumber"],
      address: json["address"],
      province: json["province"],
      city: json["city"],
      subdistrict: json["subdistrict"],
      postalCode: json["postalCode"],
      location: json["location"] == null  ? [] : List<double>.from(json["location"].map((x) => x.toDouble())),
    );
}

class ProductElement {
  ProductElement({
    this.productId,
    this.product,
    this.storeId,
    this.quantity,
    this.price,
    this.note,
    this.classId,
  });

  String? productId;
  ProductProduct? product;
  String? storeId;
  int? quantity;
  double? price;
  String? note;
  String? classId;

  factory ProductElement.fromJson(Map<String, dynamic> json) => ProductElement(
    productId: json["productId"],
    product: json["product"] == null 
    ? ProductProduct(
        id: "-",
        classId: "-",
        discount: TransactionPaidProductDiscount(active: false),
        name: "-",
        pictures: [],
        price: json["price"],
        stats: TransactionStorePaidStats(
          classId: "",
          ratingAvg: 0.0,
          ratingMax: 0.0,
          ratings: [],
          numOfReview: 0,
          numOfSold: 0
        ),
        stock: 0,
        weight: 0
      )
    : ProductProduct.fromJson(json["product"]),
    storeId: json["storeId"],
    quantity: json["quantity"],
    price: json["price"],
    note:  json["note"],
    classId: json["classId"],
  );

}

class ProductProduct {
  ProductProduct({
    this.id,
    this.name,
    this.price,
    this.pictures,
    this.weight,
    this.discount,
    this.stock,
    this.stats,
    this.classId,
  });

  String? id;
  String? name;
  double? price;
  List<TransactionStorePaidPicture>? pictures;
  int? weight;
  TransactionPaidProductDiscount? discount;
  int? stock;
  TransactionStorePaidStats? stats;
  String? classId;

  factory ProductProduct.fromJson(Map<String, dynamic> json) => ProductProduct(
    id: json["id"],
    name: json["name"],
    price: json["price"],
    pictures: json["pictures"] == null ? [] : List<TransactionStorePaidPicture>.from(json["pictures"].map((x) => TransactionStorePaidPicture.fromJson(x))),
    weight: json["weight"],
    discount: json["discount"] == null 
    ? TransactionPaidProductDiscount()
    : TransactionPaidProductDiscount.fromJson(json["discount"]),
    stock: json["stock"],
    stats: TransactionStorePaidStats.fromJson(json["stats"]),
    classId: json["classId"],
  );
}

class TransactionPaidProductDiscount {
  TransactionPaidProductDiscount({
    this.discount,
    this.startDate,
    this.endDate,
    this.active,
  });

  double? discount;
  String? startDate;
  String? endDate;
  bool? active;

  factory TransactionPaidProductDiscount.fromJson(Map<String, dynamic> json) =>
    TransactionPaidProductDiscount(
      discount: json["discount"],
      startDate: json["startDate"],
      endDate: json["endDate"],
      active: json["active"],
    );
}

class TransactionStorePaidPicture {
  TransactionStorePaidPicture({
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

  factory TransactionStorePaidPicture.fromJson(Map<String, dynamic> json) =>
    TransactionStorePaidPicture(
      originalName: json["originalName"],
      fileLength: json["fileLength"],
      path: json["path"],
      contentType: json["contentType"],
      classId: json["classId"],
    );
}

class TransactionStorePaidStats {
  TransactionStorePaidStats({
    this.ratingMax,
    this.ratingAvg,
    this.numOfReview,
    this.numOfSold,
    this.ratings,
    this.classId,
  });

  double? ratingMax;
  double? ratingAvg;
  int? numOfReview;
  int? numOfSold;
  List<TransactionStorePaidRating>? ratings;
  String? classId;

  factory TransactionStorePaidStats.fromJson(Map<String, dynamic> json) =>
    TransactionStorePaidStats(
      ratingMax: json["ratingMax"],
      ratingAvg: json["ratingAvg"],
      numOfReview: json["numOfReview"],
      numOfSold: json["numOfSold"],
      ratings: json["ratings"] == null ? [] : List<TransactionStorePaidRating>.from(json["ratings"].map((x) => TransactionStorePaidRating.fromJson(x))),
      classId: json["classId"],
    );
}

class TransactionStorePaidRating {
  TransactionStorePaidRating({
    this.star,
    this.count,
  });

  dynamic star;
  dynamic count;

  factory TransactionStorePaidRating.fromJson(Map<String, dynamic> json) =>
    TransactionStorePaidRating(
      star: json["star"],
      count: json["count"],
    );
}

class TransactionStorePaidStore {
  TransactionStorePaidStore({
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
  TransactionStorePaidPicture? picture;
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
  List<TransactionStorePaidSupportedCourier>? supportedCouriers;
  String? classId;

  factory TransactionStorePaidStore.fromJson(Map<String, dynamic> json) =>
  TransactionStorePaidStore(
    id: json["id"],
    owner: json["owner"],
    name: json["name"],
    description: json["description"],
    open: json["open"],
    picture: TransactionStorePaidPicture.fromJson(json["picture"]),
    status: json["status"],
    province: json["province"],
    city: json["city"],
    subdistrict: json["subdsitrct"],
    village: json["village"],
    postalCode: json["postalCode"],
    address: json["address"],
    email: json["email"],
    phone: json["phone"],
    level: json["level"],
    location: json["location"] == null ? [] : List<double>.from(json["location"].map((x) => x.toDouble())),
    supportedCouriers: json["supportedCouriers"] == null ? [] : List<TransactionStorePaidSupportedCourier>.from(json["supportedCouriers"].map((x) => TransactionStorePaidSupportedCourier.fromJson(x))),
    classId: json["classId"],
  );
}

class TransactionStorePaidSupportedCourier {
  TransactionStorePaidSupportedCourier({
    this.id,
    this.status,
    this.created,
    this.updated,
    this.name,
    this.image,
    this.checkPriceSupported,
    this.checkResiSupported,
    this.classId,
  });

  String? id;
  int? status;
  String? created;
  String? updated;
  String? name;
  String? image;
  bool? checkPriceSupported;
  bool? checkResiSupported;
  String? classId;

  factory TransactionStorePaidSupportedCourier.fromJson(Map<String, dynamic> json) =>
    TransactionStorePaidSupportedCourier(
      id: json["id"],
      status: json["status"],
      created: json["created"],
      updated: json["updated"],
      name: json["name"],
      image: json["image"],
      checkPriceSupported: json["checkPriceSupported"],
      checkResiSupported: json["checkResiSupported"],
      classId: json["classId"],
    );
}

class TransactionStorePaidUser {
  TransactionStorePaidUser({
    this.uid,
    this.fullname,
    this.username,
    this.address,
    this.email,
    this.created,
    this.avatar,
    this.phone,
    this.classId,
  });

  String? uid;
  String? fullname;
  String? username;
  String? address;
  String? email;
  DateTime? created;
  String? phone;
  String? avatar;
  String? classId;

  factory TransactionStorePaidUser.fromJson(Map<String, dynamic> json) =>
    TransactionStorePaidUser(
      uid: json["uid"],
      fullname: json["fullname"],
      username: json["username"],
      address: json["address"],
      email: json["email"],
      created: json["created"] == null ? DateTime.now() : DateTime.parse(json["created"]),
      phone: json["phone"],
      avatar: json["avatar"] == null ? "" : json["avatar"],
      classId: json["classId"],
    );
}
