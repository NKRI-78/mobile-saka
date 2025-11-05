import 'package:saka/data/models/store/product_store.dart';

class TransactionPaidSingleModel {
  TransactionPaidSingleModel({
    this.code,
    this.message,
    this.body,
    this.error,
  });

  int? code;
  String? message;
  TransactionPaidSingle? body;
  dynamic error;

  factory TransactionPaidSingleModel.fromJson(Map<String, dynamic> json) =>
  TransactionPaidSingleModel(
    code: json["code"],
    message: json["message"],
    body: json["body"] == null ? TransactionPaidSingle() 
    : TransactionPaidSingle.fromJson(json["body"]),
    error: json["error"],
  );

}

class TransactionPaidSingle {
  TransactionPaidSingle({
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
  Store? store;
  String? orderStatus;
  TransactionPaidSingleDeliveryCost? deliveryCost;
  String? invoiceNo;
  List<TransactionPaidSingleProductElement>? products;
  TransactionPaidSingleDestShippingAddress? destShippingAddress;
  TransactionPaidSingleUser? user;
  String? created;
  String? doneDate;
  String? wayBill;
  String? classId;
  double? sellerProductPrice;
  double? totalProductPrice;

  factory TransactionPaidSingle.fromJson(Map<String, dynamic> json) =>
    TransactionPaidSingle(
      id: json["id"],
      refId: json["refId"],
      trxId: json["trxId"],
      storeId: json["storeId"],
      store: Store.fromJson(json["store"]),
      orderStatus: json["orderStatus"],
      deliveryCost: TransactionPaidSingleDeliveryCost.fromJson(json["deliveryCost"]),
      invoiceNo: json["invoiceNo"],
      products: json["products"] == null ? [] : List<TransactionPaidSingleProductElement>.from(json["products"].map((x) => TransactionPaidSingleProductElement.fromJson(x))),
      destShippingAddress: TransactionPaidSingleDestShippingAddress.fromJson(json["destShippingAddress"]),
      user: TransactionPaidSingleUser.fromJson(json["user"]),
      created: json["created"],
      doneDate: json["doneDate"],
      wayBill: json["wayBill"],
      classId: json["classId"],
      sellerProductPrice: json["sellerProductPrice"],
      totalProductPrice: json["totalProductPrice"],
    );

}

class TransactionPaidSingleDeliveryCost {
  TransactionPaidSingleDeliveryCost({
    this.courierId,
    this.courierName,
    this.serviceName,
    this.serviceDesc,
    this.price,
    this.sellerPrice,
    this.estimateDays,
    this.classId,
  });

  String? courierId;
  String? courierName;
  String? serviceName;
  String? serviceDesc;
  double? price;
  double? sellerPrice;
  String? estimateDays;
  String? classId;

  factory TransactionPaidSingleDeliveryCost.fromJson( Map<String, dynamic> json) =>
    TransactionPaidSingleDeliveryCost(
      courierId: json["courierId"],
      courierName: json["courierName"],
      serviceName: json["serviceName"],
      serviceDesc: json["serviceDesc"],
      price: json["price"],
      sellerPrice: json["sellerPrice"],
      estimateDays: json["estimateDays"],
      classId: json["classId"],
    );
}

class TransactionPaidSingleDestShippingAddress {
  TransactionPaidSingleDestShippingAddress({
    this.phoneNumber,
    this.address,
    this.province,
    this.city,
    this.subdistrict,
    this.postalCode,
    this.location,
  });

  String? phoneNumber;
  String? address;
  String? province;
  String? city;
  String? subdistrict;
  String? postalCode;
  List<double>? location;

  factory TransactionPaidSingleDestShippingAddress.fromJson( Map<String, dynamic> json) =>
  TransactionPaidSingleDestShippingAddress(
    phoneNumber: json["phoneNumber"],
    address: json["address"],
    province: json["province"],
    city: json["city"],
    subdistrict: json["subdistrict"],
    postalCode: json["postalCode"],
    location: json["location"] == null ? [] : List<double>.from(json["location"].map((x) => x.toDouble())),
  );
}

class TransactionPaidSingleProductElement {
  TransactionPaidSingleProductElement({
    this.productId,
    this.product,
    this.storeId,
    this.quantity,
    this.sellerPrice,
    this.price,
    this.note,
    this.classId,
  });

  String? productId;
  TransactionPaidSingleProductProduct? product;
  String? storeId;
  int? quantity;
  double? sellerPrice;
  double? price;
  String? note;
  String? classId;

  factory TransactionPaidSingleProductElement.fromJson(Map<String, dynamic> json) =>
    TransactionPaidSingleProductElement(
      productId: json["productId"],
      product: json["product"] == null 
      ? TransactionPaidSingleProductProduct(
          id: "-",
          classId: "-",
          discount: TransactionPaidSingleDiscount(active: false),
          minOrder: 1,
          name: "-",
          pictures: [],
          price: json["price"],
          sellerPrice: json["sellerPrice"],
          stats: TransactionPaidSingleStats(
            classId: "-",
            numOfReview: 0,
            numOfSold: 0,
            ratingAvg: 0.0,
            ratingMax: 0.0,
            ratings: []
          ),
          stock: 1,
          weight: 1
        )
      : TransactionPaidSingleProductProduct.fromJson(json["product"]),
      storeId: json["storeId"],
      quantity: json["quantity"],
      sellerPrice: json["sellerPrice"],
      price: json["price"],
      note: json["note"],
      classId: json["classId"],
    );
}

class TransactionPaidSingleProductProduct {
  TransactionPaidSingleProductProduct({
    this.id,
    this.name,
    this.sellerPrice,
    this.price,
    this.pictures,
    this.weight,
    this.discount,
    this.stock,
    this.minOrder,
    this.stats,
    this.classId,
  });

  String? id;
  String? name;
  double? sellerPrice;
  double?price;
  List<TransactionPaidSinglePicture>? pictures;
  int? weight;
  TransactionPaidSingleDiscount? discount;
  int? stock;
  int? minOrder;
  TransactionPaidSingleStats? stats;
  String? classId;

  factory TransactionPaidSingleProductProduct.fromJson(Map<String, dynamic> json) =>
    TransactionPaidSingleProductProduct(
      id: json["id"],
      name: json["name"],
      sellerPrice: json["sellerPrice"],
      price: json["price"],
      pictures: json["pictures"] == null ? [] : List<TransactionPaidSinglePicture>.from(json["pictures"].map((x) => TransactionPaidSinglePicture.fromJson(x))),
      weight: json["weight"],
      discount: json["discount"] == null 
      ? TransactionPaidSingleDiscount()
      : TransactionPaidSingleDiscount.fromJson(json["discount"]),
      stock: json["stock"],
      minOrder: json["minOrder"],
      stats: TransactionPaidSingleStats.fromJson(json["stats"]),
      classId: json["classId"],
    );
}

class TransactionPaidSingleDiscount {
  TransactionPaidSingleDiscount({
    this.discount,
    this.startDate,
    this.endDate,
    this.active,
  });

  double? discount;
  String? startDate;
  String? endDate;
  bool? active;

  factory TransactionPaidSingleDiscount.fromJson(Map<String, dynamic> json) =>
    TransactionPaidSingleDiscount(
      discount: json["discount"],
      startDate: json["startDate"],
      endDate: json["endDate"],
      active: json["active"],
    );
}

class TransactionPaidSinglePicture {
  TransactionPaidSinglePicture({
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

  factory TransactionPaidSinglePicture.fromJson(Map<String, dynamic> json) => TransactionPaidSinglePicture(
    originalName: json["originalName"],
    fileLength: json["fileLength"],
    path: json["path"],
    contentType: json["contentType"],
    classId: json["classId"],
  );
}

class TransactionPaidSingleStats {
  TransactionPaidSingleStats({
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
  List<TransactionPaidSingleRating>? ratings;
  String? classId;

  factory TransactionPaidSingleStats.fromJson(Map<String, dynamic> json) =>
    TransactionPaidSingleStats(
      ratingMax: json["ratingMax"],
      ratingAvg: json["ratingAvg"],
      numOfReview: json["numOfReview"],
      numOfSold: json["numOfSold"],
      ratings: json["ratings"] == null ? [] : List<TransactionPaidSingleRating>.from(json["ratings"].map((x) => TransactionPaidSingleRating.fromJson(x))),
      classId: json["classId"],
    );
}

class TransactionPaidSingleRating {
  TransactionPaidSingleRating({
    this.star,
    this.count,
  });

  dynamic star;
  dynamic count;

  factory TransactionPaidSingleRating.fromJson( Map<String, dynamic> json) =>
    TransactionPaidSingleRating(
      star: json["star"],
      count: json["count"],
    );
}

class TransactionPaidSingleStore {
  TransactionPaidSingleStore({
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
  TransactionPaidSinglePicture? picture;
  int? status;
  String? province;
  String? city;
  String? postalCode;
  String? address;
  List<double>? location;
  List<TransactionPaidSingleSupportedCourier>? supportedCouriers;
  String? classId;

  factory TransactionPaidSingleStore.fromJson(Map<String, dynamic> json) =>
    TransactionPaidSingleStore(
      id: json["id"],
      owner: json["owner"],
      name: json["name"],
      description: json["description"],
      open: json["open"],
      picture: TransactionPaidSinglePicture.fromJson(json["picture"]),
      status: json["status"],
      province: json["province"],
      city: json["city"],
      postalCode: json["postalCode"],
      address: json["address"],
      location: json["location"] == null ? [] : List<double>.from(json["location"].map((x) => x.toDouble())),
      supportedCouriers: json["supportedCouriers"] == null ? [] : List<TransactionPaidSingleSupportedCourier>.from(
json["supportedCouriers"].map((x) => TransactionPaidSingleSupportedCourier.fromJson(x))),
      classId: json["classId"],
    );
}

class TransactionPaidSingleSupportedCourier {
  TransactionPaidSingleSupportedCourier({
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

  factory TransactionPaidSingleSupportedCourier.fromJson(Map<String, dynamic> json) =>
    TransactionPaidSingleSupportedCourier(
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

class TransactionPaidSingleUser {
  TransactionPaidSingleUser({
    this.uid,
    this.fullname,
    this.username,
    this.address,
    this.email,
    this.created,
    this.avatar,
    this.classId,
  });

  String? uid;
  String? fullname;
  String? username;
  String? address;
  String? email;
  String? created;
  String? avatar;
  String? classId;

  factory TransactionPaidSingleUser.fromJson(Map<String, dynamic> json) =>
    TransactionPaidSingleUser(
      uid: json["uid"],
      fullname: json["fullname"],
      username: json["username"],
      address: json["address"],
      email: json["email"],
      created: json["created"],
      avatar: json["avatar"],
      classId: json["classId"],
    );
}
