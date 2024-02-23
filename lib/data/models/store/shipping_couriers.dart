class ShippingCouriersModel {
  ShippingCouriersModel({
    this.code,
    this.message,
    this.body,
    this.error,
  });

  int? code;
  String? message;
  ShippingCouriersList? body;
  dynamic error;

  factory ShippingCouriersModel.fromJson(Map<String, dynamic> json) => ShippingCouriersModel(
    code: json["code"],
    message: json["message"],
    body: json["body"] == null ? ShippingCouriersList() :  ShippingCouriersList.fromJson(json["body"]),
    error: json["error"],
  );
}

class ShippingCouriersList {
  ShippingCouriersList({
    this.id,
    this.cartId,
    this.origin,
    this.destination,
    this.weight,
    this.categories,
  });

  String? id;
  String? cartId;
  String? origin;
  String? destination;
  int? weight;
  List<Category>? categories;

  factory ShippingCouriersList.fromJson(Map<String, dynamic> json) => ShippingCouriersList(
    id: json["id"],
    cartId: json["cartId"],
    origin: json["origin"],
    destination: json["destination"],
    weight: json["weight"],
    categories: json["categories"] == null ? [] : List<Category>.from(json["categories"].map((x) => Category.fromJson(x))),
  );
}

class Category {
  Category({
    this.type,
    this.label,
    this.rates,
  });

  String? type;
  String? label;
  List<Rate>? rates;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    type: json["type"],
    label: json["label"],
    rates: json["rates"] == null ? [] : List<Rate>.from(json["rates"].map((x) => Rate.fromJson(x))),
  );
}

class Rate {
  Rate({
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

  factory Rate.fromJson(Map<String, dynamic> json) => Rate(
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
