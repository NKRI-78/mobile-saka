class ListOrderModel {
  int status;
  bool error;
  String message;
  List<ListOrderData> data;

  ListOrderModel({
    required this.status,
    required this.error,
    required this.message,
    required this.data,
  });

  factory ListOrderModel.fromJson(Map<String, dynamic> json) => ListOrderModel(
    status: json["status"],
    error: json["error"],
    message: json["message"],
    data: List<ListOrderData>.from(json["data"].map((x) => ListOrderData.fromJson(x))),
  );
}

class ListOrderData {
  String transactionId;
  String orderStatus;
  String paymentStatus;
  String waybill;
  dynamic expire;
  String invoice;
  int totalPrice;
  OrderStore store;
  Seller seller;
  Buyer buyer;
  DateTime createdAt;

  ListOrderData({
    required this.transactionId,
    required this.orderStatus,
    required this.paymentStatus,
    required this.waybill,
    required this.expire,
    required this.invoice,
    required this.totalPrice,
    required this.store,
    required this.seller, 
    required this.buyer,
    required this.createdAt,
  });

  factory ListOrderData.fromJson(Map<String, dynamic> json) => ListOrderData(
    transactionId: json["transaction_id"],
    orderStatus: json["order_status"],
    paymentStatus: json["payment_status"],
    waybill: json["waybill"],
    expire: json["expire"],
    invoice: json["invoice"],
    totalPrice: json["total_price"],
    createdAt: DateTime.parse(json["created_at"]),
    store: OrderStore.fromJson(json["store"]),
    seller: Seller.fromJson(json["seller"]),
    buyer: Buyer.fromJson(json["buyer"]),
  );
}

class OrderStore {
  String logo;
  String name;

  OrderStore({
    required this.logo,
    required this.name,
  });

  factory OrderStore.fromJson(Map<String, dynamic> json) => OrderStore(
    logo: json["logo"],
    name: json["name"],
  );
}

class Buyer {
  String id;
  String email;
  String fullname;

  Buyer({
    required this.id,
    required this.email,
    required this.fullname,
  });

  factory Buyer.fromJson(Map<String, dynamic> json) => Buyer(
    id: json["id"],
    email: json["email"],
    fullname: json["fullname"],
  );
}

class Seller {
  String id;
  String email;
  String fullname;

  Seller({
    required this.id,
    required this.email,
    required this.fullname,
  });

  factory Seller.fromJson(Map<String, dynamic> json) => Seller(
    id: json["id"],
    email: json["email"],
    fullname: json["fullname"],
  );
}