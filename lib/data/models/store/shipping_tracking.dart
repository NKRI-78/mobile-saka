class ShippingTrackingModel {
  ShippingTrackingModel({
    this.code,
    this.message,
    this.data,
    this.error,
  });

  int? code;
  String? message;
  ShippingTrackingData? data;
  dynamic error;

  factory ShippingTrackingModel.fromJson(Map<String, dynamic> json) => ShippingTrackingModel(
    code: json["code"],
    message: json["message"],
    data: ShippingTrackingData.fromJson(json["body"]),
    error: json["error"],
  );
}

class ShippingTrackingData {
  ShippingTrackingData({
    this.id,
    this.status,
    this.created,
    this.updated,
    this.orderId,
    this.userId,
    this.storeId,
    this.orderStatusInfos,
    this.wayBillDelivery,
    this.completed,
    this.classId,
  });

  String? id;
  int? status;
  String? created;
  String? updated;
  String? orderId;
  String? userId;
  String? storeId;
  List<OrderStatusInfo>? orderStatusInfos;
  WayBillDelivery? wayBillDelivery;
  bool? completed;
  String? classId;

  factory ShippingTrackingData.fromJson(Map<String, dynamic> json) => ShippingTrackingData(
    id: json["id"],
    status: json["status"],
    created: json["created"],
    updated: json["updated"],
    orderId: json["orderId"],
    userId: json["userId"],
    storeId: json["storeId"],
    orderStatusInfos: json["orderStatusInfos"] == null ? [] : List<OrderStatusInfo>.from(json["orderStatusInfos"].map((x) => OrderStatusInfo.fromJson(x))),
    wayBillDelivery: json["wayBillDelivery"] == null
    ? WayBillDelivery()
    : WayBillDelivery.fromJson(json["wayBillDelivery"]),
    completed: json["completed"],
    classId: json["classId"],
  );
}

class OrderStatusInfo {
  OrderStatusInfo({
    this.date,
    this.progress,
    this.handledBy,
  });

  String? date;
  String? progress;
  String? handledBy;

  factory OrderStatusInfo.fromJson(Map<String, dynamic> json) => OrderStatusInfo(
    date: json["date"],
    progress: json["progress"],
    handledBy: json["handledBy"],
  );
}

class WayBillDelivery {
  WayBillDelivery({
    this.waybill,
    this.delivered,
    this.waybillDate,
    this.shipperName,
    this.receiverName,
    this.receivedDate,
    this.courierId,
    this.courierName,
    this.serviceCode,
    this.destination,
    this.origin,
    this.status,
    this.manifests,
  });

  String? waybill;
  bool? delivered;
  DateTime? waybillDate;
  String? shipperName;
  String? receiverName;
  dynamic receivedDate;
  String? courierId;
  String? courierName;
  String? serviceCode;
  String? destination;
  String? origin;
  String? status;
  List<Manifest>? manifests;

  factory WayBillDelivery.fromJson(Map<String, dynamic> json) => WayBillDelivery(
    waybill: json["waybill"],
    delivered: json["delivered"],
    waybillDate: DateTime.parse(json["waybillDate"]),
    shipperName: json["shipperName"],
    receiverName: json["receiverName"],
    receivedDate: json["receivedDate"],
    courierId: json["courierId"],
    courierName:  json["courierName"],
    serviceCode: json["serviceCode"],
    destination: json["destination"],
    origin: json["origin"],
    status: json["status"],
    manifests: json["manifests"] == null ? [] : List<Manifest>.from(json["manifests"].map((x) => Manifest.fromJson(x))),
  );
}

class Manifest {
  Manifest({
    this.description,
    this.date,
  });

  String? description;
  DateTime? date;

  factory Manifest.fromJson(Map<String, dynamic> json) => Manifest(
    description: json["description"],
    date: DateTime.parse(json["date"]),
  );
}
