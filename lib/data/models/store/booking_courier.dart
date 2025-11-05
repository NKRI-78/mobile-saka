class BookingCourierModel {
  BookingCourierModel({
    this.code,
    this.message,
    this.body,
    this.error,
  });

  int? code;
  String? message;
  BookingCourierData? body;
  dynamic error;

  factory BookingCourierModel.fromJson(Map<String, dynamic> json) => BookingCourierModel(
    code: json["code"],
    message: json["message"],
    body: BookingCourierData.fromJson(json["body"]),
    error: json["error"],
  );
}

class BookingCourierData {
  BookingCourierData({
    this.deliveryCost,
    this.waybill,
    this.created,
  });

  DeliveryCost? deliveryCost;
  String? waybill;
  String? created;

  factory BookingCourierData.fromJson(Map<String, dynamic> json) => BookingCourierData(
    deliveryCost: json["deliveryCost"] == null ? null : DeliveryCost.fromJson(json["deliveryCost"]),
    waybill: json["waybill"],
    created: json["created"],
  );
}

class DeliveryCost {
  DeliveryCost({
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

  factory DeliveryCost.fromJson(Map<String, dynamic> json) => DeliveryCost(
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
