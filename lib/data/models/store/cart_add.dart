import 'package:flutter/material.dart';

class CartModel {
  CartModel({
    this.code,
    this.message,
    this.data,
    this.error,
  });

  int? code;
  String? message;
  CartData? data;
  dynamic error;

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
    code: json["code"],
    message: json["message"],
    data: CartData.fromJson(json["body"]),
    error: json["error"],
  );
}

class CartData {
  CartData({
    this.id,
    this.userId,
    this.numOfItems,
    this.stores,
    this.serviceCharge,
    this.shippingAddress,
    this.totalProductPrice,
    this.totalDeliveryCost,
    this.classId,
    this.isActive
  });

  String? id;
  String? userId;
  int? numOfItems;
  List<StoreElement>? stores;
  double? serviceCharge;
  ShippingAddress? shippingAddress;
  double? totalProductPrice;
  double? totalDeliveryCost;
  String? classId;
  bool? isActive;

  factory CartData.fromJson(Map<String, dynamic> json) => CartData(
    id: json["id"],
    userId: json["userId"],
    numOfItems: json["numOfItems"],
    stores: json["stores"] == null ? [] : List<StoreElement>.from(json["stores"].map((x) => StoreElement.fromJson(x))),
    serviceCharge: json["serviceCharge"],
    shippingAddress: json["shippingAddress"] == null 
    ? ShippingAddress() 
    : ShippingAddress.fromJson(json["shippingAddress"]),
    totalProductPrice: json["totalProductPrice"],
    totalDeliveryCost: json["totalDeliveryCost"],
    classId: json["classId"],
    isActive: true
  );
}

class ShippingAddress {
  ShippingAddress({
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

  factory ShippingAddress.fromJson(Map<String, dynamic> json) => ShippingAddress(
    id: json["id"],
    phoneNumber: json["phoneNumber"],
    address: json["address"],
    postalCode: json["postalCode"],
    province: json["province"],
    city: json["city"],
    subdistrict: json["subdistrict"],
    village: json["village"],
    defaultLocation: json["defaultLocation"],
    location: json["location"] == null ? [] : List<double>.from(json["location"].map((x) => x.toDouble())),
    name: json["name"],
    classId: json["classId"],
  );
}

class StoreElement {
  StoreElement({
    this.storeId,
    this.invoiceNo,
    this.store,
    this.shippingRate,
    this.items,
    this.classId,
    this.isActive,
    this.isLiveBuy
  });

  String? storeId;
  String? invoiceNo;
  StoreStore? store;
  ShippingRate? shippingRate;
  List<StoreElementItem>? items;
  String? classId;
  bool? isActive;
  bool? isLiveBuy;

  factory StoreElement.fromJson(Map<String, dynamic> json) => StoreElement(
    storeId: json["storeId"],
    invoiceNo: json["invoiceNo"],
    store: StoreStore.fromJson(json["store"]),
    shippingRate: json["shippingRate"] == null 
    ? ShippingRate(serviceType: "")
    : ShippingRate.fromJson(json["shippingRate"]),
    items: json["items"] == null ? [] : List<StoreElementItem>.from(json["items"].map((x) => StoreElementItem.fromJson(x))),
    classId: json["classId"],
    isActive: true,
    isLiveBuy: false
  );
}

class StoreElementItem {
  StoreElementItem({
    this.productId,
    this.product,
    this.storeId,
    this.quantity,
    this.price,
    this.note,
    this.classId,
    this.isActive,
    this.isLiveBuy,
    this.controller,
  });

  String? productId;
  CartProduct? product;
  String? storeId;
  int? quantity;
  double? price;
  String? note;
  String? classId;
  bool? isActive;
  bool? isLiveBuy;
  TextEditingController? controller;

  factory StoreElementItem.fromJson(Map<String, dynamic> json) => StoreElementItem(
    productId: json["productId"],
    product: CartProduct.fromJson(json["product"]),
    storeId: json["storeId"],
    quantity: json["quantity"],
    price: json["price"],
    note: json["note"],
    classId: json["classId"],
    isActive: true,
    isLiveBuy: false,
    controller: TextEditingController(text: json["quantity"].toString())
  );
}

class CartProduct {
  CartProduct({
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
  List<Picture>? pictures;
  int? weight;
  dynamic discount;
  int? stock;
  int? minOrder;
  Stats? stats;
  bool? harmful;
  bool? liquid;
  bool? flammable;
  bool? fragile;
  String? classId;

  factory CartProduct.fromJson(Map<String, dynamic> json) => CartProduct(
    id: json["id"],
    name: json["name"],
    price: json["price"],
    pictures: json["pictures"] == null ? [] : List<Picture>.from(json["pictures"].map((x) => Picture.fromJson(x))),
    weight: json["weight"],
    discount: json["discount"],
    stock: json["stock"],
    minOrder: json["minOrder"],
    stats: Stats.fromJson(json["stats"]),
    harmful: json["harmful"],
    liquid: json["liquid"],
    flammable: json["flammable"],
    fragile: json["fragile"],
    classId: json["classId"],
  );
}

class Picture {
  Picture({
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

  factory Picture.fromJson(Map<String, dynamic> json) => Picture(
    originalName: json["originalName"],
    fileLength: json["fileLength"],
    path: json["path"],
    contentType: json["contentType"],
    classId: json["classId"],
  );
}

class Stats {
  Stats({
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
  List<Rating>? ratings;
  String? classId;

  factory Stats.fromJson(Map<String, dynamic> json) => Stats(
    ratingMax: json["ratingMax"],
    ratingAvg: json["ratingAvg"],
    numOfReview: json["numOfReview"],
    numOfSold: json["numOfSold"],
    ratings: json["ratings"] == null ? [] : List<Rating>.from(json["ratings"].map((x) => Rating.fromJson(x))),
    classId: json["classId"]
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

class ShippingRate {
  ShippingRate({
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

  factory ShippingRate.fromJson(Map<String, dynamic> json) => ShippingRate(
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

class StoreStore {
  StoreStore({
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
  Picture? picture;
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

  factory StoreStore.fromJson(Map<String, dynamic> json) => StoreStore(
    id: json["id"],
    owner: json["owner"],
    name: json["name"],
    description: json["description"],
    open: json["open"],
    picture: Picture.fromJson(json["picture"]),
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
    location: json["location"] == null ? [] : List<double>.from(json["location"].map((x) => x.toDouble())),
    supportedCouriers: json["supportedCouriers"] == null ? [] : List<SupportedCourier>.from(json["supportedCouriers"].map((x) => SupportedCourier.fromJson(x))),
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
    image:  json["image"],
    checkPriceSupported: json["checkPriceSupported"],
    checkResiSupported: json["checkResiSupported"],
    classId:  json["classId"],
  );
}
