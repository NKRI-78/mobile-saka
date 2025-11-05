class TransactionStoreUnpaidModel {
  TransactionStoreUnpaidModel({
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
  List<TransactionUnpaidList>? body;
  dynamic error;

  factory TransactionStoreUnpaidModel.fromJson(Map<String, dynamic> json) =>
    TransactionStoreUnpaidModel(
      code: json["code"],
      message: json["message"],
      count: json["count"],
      first: json["first"],
      body: json["body"] == null ? [] : List<TransactionUnpaidList>.from(json["body"].map((x) => TransactionUnpaidList.fromJson(x))),
      error: json["error"],
    );
}

class TransactionUnpaidList {
  TransactionUnpaidList({
    this.id,
    this.refId,
    this.transactionStatus,
    this.paymentChannel,
    this.paymentRef,
    this.stores,
    this.shippingAddress,
    this.serviceCharge,
    this.totalProductPrice,
    this.totalDeliveryCost,
    this.totalPrice,
    this.billed,
    this.billCreated,
    this.classId,
  });

  String? id;
  String? refId;
  String? transactionStatus;
  PaymentChannel? paymentChannel;
  PaymentRef? paymentRef;
  List<TransactionUnpaidStoreElement>? stores;
  TransactionUnpaidShippingAddress? shippingAddress;
  double? serviceCharge;
  double? totalProductPrice;
  double? totalDeliveryCost;
  double? totalPrice;
  bool? billed;
  String? billCreated;
  String? classId;

  factory TransactionUnpaidList.fromJson(Map<String, dynamic> json) =>
    TransactionUnpaidList(
      id: json["id"],
      refId: json["refId"],
      transactionStatus: json["transactionStatus"],
      paymentChannel: PaymentChannel.fromJson(json["paymentChannel"]),
      paymentRef: json["paymentRef"] == null ? null : PaymentRef.fromJson(json["paymentRef"]),
      stores: json["stores"] == null ? [] : List<TransactionUnpaidStoreElement>.from(json["stores"].map((x) => TransactionUnpaidStoreElement.fromJson(x))),
      shippingAddress: json["shippingAddress"] == null ? null : TransactionUnpaidShippingAddress.fromJson(json["shippingAddress"]),
      serviceCharge: json["serviceCharge"],
      totalPrice: json["totalPrice"],
      totalProductPrice: json["totalProductPrice"],
      totalDeliveryCost: json["totalDeliveryCost"],
      billed: json["billed"],
      billCreated: json["billCreated"],
      classId: json["classId"],
    );
}

class PaymentChannel {
  PaymentChannel({
    this.channel,
    this.category,
    this.name,
    this.guide,
    this.paymentFee,
    this.logo,
  });

  String? channel;
  String? category;
  String? name;
  String? guide;
  double? paymentFee;
  String? logo;

  factory PaymentChannel.fromJson(Map<String, dynamic> json) => PaymentChannel(
    channel: json["channel"],
    category: json["category"],
    name: json["name"],
    guide: json["guide"],
    paymentFee: json["paymentFee"],
    logo: json["logo"],
  );
}

class PaymentRef {
  PaymentRef({
    this.paymentChannel,
    this.paymentCode,
    this.paymentRefId,
    this.paymentGuide,
    this.paymentAdminFee,
    this.paymentStatus,
    this.refNo,
    this.currency,
    this.billingUid,
    this.amount,
  });

  String? paymentChannel;
  String? paymentCode;
  String? paymentRefId;
  String? paymentGuide;
  String? paymentAdminFee;
  String? paymentStatus;
  String? refNo;
  String? currency;
  String? billingUid;
  double? amount;

  factory PaymentRef.fromJson(Map<String, dynamic> json) => PaymentRef(
    paymentChannel: json["paymentChannel"],
    paymentCode: json["paymentCode"],
    paymentRefId: json["paymentRefId"],
    paymentGuide: json["paymentGuide"],
    paymentAdminFee: json["paymentAdminFee"],
    paymentStatus: json["paymentStatus"],
    refNo: json["refNo"],
    currency: json["currency"],
    billingUid: json["billingUid"],
    amount: json["amount"],
  );
}

class TransactionUnpaidShippingAddress {
  TransactionUnpaidShippingAddress({
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

  factory TransactionUnpaidShippingAddress.fromJson(Map<String, dynamic> json) =>
    TransactionUnpaidShippingAddress(
      phoneNumber: json["phoneNumber"],
      address: json["address"],
      province: json["province"],
      city: json["city"],
      subdistrict: json["subdistrict"],
      postalCode: json["postalCode"],
      location: json["location"] == null ? [] : List<double>.from(json["location"].map((x) => x.toDouble())),
    );
}

class TransactionUnpaidStoreElement {
  TransactionUnpaidStoreElement({
    this.storeId,
    this.invoiceNo,
    this.store,
    this.deliveryCost,
    this.items,
    this.classId,
  });

  String? storeId;
  String?invoiceNo;
  TransactionUnpaidStoreStore? store;
  TransactionUnpaidDeliveryCost? deliveryCost;
  List<TransactionUnpaidItem>? items;
  String? classId;

  factory TransactionUnpaidStoreElement.fromJson(Map<String, dynamic> json) => TransactionUnpaidStoreElement(
    storeId: json["storeId"],
    invoiceNo: json["invoiceNo"],
    store: TransactionUnpaidStoreStore.fromJson(json["store"]),
    deliveryCost: json["deliveryCost"] == null 
    ? TransactionUnpaidDeliveryCost()
    : TransactionUnpaidDeliveryCost.fromJson(json["deliveryCost"]),
    items: json["items"] == null ? [] : List<TransactionUnpaidItem>.from(json["items"].map((x) => TransactionUnpaidItem.fromJson(x))),
    classId: json["classId"],
  );
}

class TransactionUnpaidDeliveryCost {
  TransactionUnpaidDeliveryCost({
    this.courierId,
    this.courierName,
    this.serviceName,
    this.serviceDesc,
    this.price,
    this.estimateDays,
    this.classId,
  });

  String? courierId;
  String? courierName;
  String? serviceName;
  String? serviceDesc;
  double? price;
  String? estimateDays;
  String? classId;

  factory TransactionUnpaidDeliveryCost.fromJson(Map<String, dynamic> json) =>
    TransactionUnpaidDeliveryCost(
      courierId: json["courierId"],
      courierName: json["courierName"],
      serviceName: json["serviceName"],
      serviceDesc: json["serviceDesc"],
      price: json["price"],
      estimateDays: json["estimateDays"],
      classId: json["classId"],
    );
}

class TransactionUnpaidItem {
  TransactionUnpaidItem({
    this.productId,
    this.product,
    this.storeId,
    this.quantity,
    this.price,
    this.note,
    this.classId,
  });

  String? productId;
  TransactionUnpaidProduct? product;
  String? storeId;
  int? quantity;
  double? price;
  String? note;
  String? classId;

  factory TransactionUnpaidItem.fromJson(Map<String, dynamic> json) =>
    TransactionUnpaidItem(
      productId: json["productId"],
      product: json["product"] == null 
      ? TransactionUnpaidProduct() 
      : TransactionUnpaidProduct.fromJson(json["product"]),
      storeId: json["storeId"],
      quantity: json["quantity"],
      price: json["price"],
      note: json["note"],
      classId: json["classId"],
    );
}

class TransactionUnpaidProduct {
  TransactionUnpaidProduct({
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
  List<TransactionUnpaidPicture>? pictures;
  int? weight;
  TransactionUnpaidProductDiscount? discount;
  int? stock;
  TransactionUnpaidStats? stats;
  String? classId;

  factory TransactionUnpaidProduct.fromJson(Map<String, dynamic> json) =>
    TransactionUnpaidProduct(
      id: json["id"],
      name: json["name"],
      price: json["price"],
      pictures: json["pictures"] == null ? [] : List<TransactionUnpaidPicture>.from(json["pictures"].map((x) => TransactionUnpaidPicture.fromJson(x))),
      weight: json["weight"],
      discount: json["discount"] == null 
      ? TransactionUnpaidProductDiscount() 
      : TransactionUnpaidProductDiscount.fromJson(json["discount"]),
      stock: json["stock"],
      stats: TransactionUnpaidStats.fromJson(json["stats"]),
      classId: json["classId"],
    );

}

class TransactionUnpaidProductDiscount {
  TransactionUnpaidProductDiscount({
    this.discount,
    this.startDate,
    this.endDate,
    this.active,
  });

  double? discount;
  String? startDate;
  String? endDate;
  bool? active;

  factory TransactionUnpaidProductDiscount.fromJson(Map<String, dynamic> json) =>
    TransactionUnpaidProductDiscount(
      discount: json["discount"],
      startDate: json["startDate"],
      endDate: json["endDate"],
      active: json["active"],
    );
}

class TransactionUnpaidPicture {
  TransactionUnpaidPicture({
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

  factory TransactionUnpaidPicture.fromJson(Map<String, dynamic> json) =>
    TransactionUnpaidPicture(
      originalName: json["originalName"],
      fileLength: json["fileLength"],
      path: json["path"],
      contentType: json["contentType"],
      classId: json["classId"],
    );
}

class TransactionUnpaidStats {
  TransactionUnpaidStats({
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
  List<TransactionUnpaidRating>? ratings;
  String? classId;

  factory TransactionUnpaidStats.fromJson(Map<String, dynamic> json) =>
    TransactionUnpaidStats(
      ratingMax: json["ratingMax"],
      ratingAvg: json["ratingAvg"],
      numOfReview: json["numOfReview"],
      numOfSold: json["numOfSold"],
      ratings: json["ratings"] == null ? []: List<TransactionUnpaidRating>.from(json["ratings"].map((x) => TransactionUnpaidRating.fromJson(x))),
      classId: json["classId"],
    );
}

class TransactionUnpaidRating {
  TransactionUnpaidRating({
    this.star,
    this.count,
  });

  dynamic star;
  dynamic count;

  factory TransactionUnpaidRating.fromJson(Map<String, dynamic> json) =>
    TransactionUnpaidRating(
      star: json["star"],
      count: json["count"],
    );
}

class TransactionUnpaidStoreStore {
  TransactionUnpaidStoreStore({
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
  TransactionUnpaidPicture? picture;
  int? status;
  String? province;
  String? city;
  String? postalCode;
  String? address;
  List<double>? location;
  List<TransactionUnpaidSupportedCourier>? supportedCouriers;
  String? classId;

  factory TransactionUnpaidStoreStore.fromJson(Map<String, dynamic> json) =>
    TransactionUnpaidStoreStore(
      id: json["id"],
      owner: json["owner"],
      name: json["name"],
      description: json["description"],
      open: json["open"],
      picture: TransactionUnpaidPicture.fromJson(json["picture"]),
      status: json["status"],
      province: json["province"],
      city: json["city"],
      postalCode: json["postalCode"],
      address: json["address"],
      location: json["location"] == null ? [] : List<double>.from(json["location"].map((x) => x.toDouble())),
      supportedCouriers: json["supportedCouriers"] == null ? [] : List<TransactionUnpaidSupportedCourier>.from(json["supportedCouriers"].map((x) => TransactionUnpaidSupportedCourier.fromJson(x))),
      classId: json["classId"],
    );
}

class TransactionUnpaidSupportedCourier {
  TransactionUnpaidSupportedCourier({
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

  factory TransactionUnpaidSupportedCourier.fromJson( Map<String, dynamic> json) => TransactionUnpaidSupportedCourier(
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
