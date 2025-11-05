class DetailOrderModel {
  int status;
  bool error;
  String message;
  List<DetailOrderData> data;

  DetailOrderModel({
    required this.status,
    required this.error,
    required this.message,
    required this.data,
  });

  factory DetailOrderModel.fromJson(Map<String, dynamic> json) => DetailOrderModel(
    status: json["status"],
    error: json["error"],
    message: json["message"],
    data: List<DetailOrderData>.from(json["data"].map((x) => DetailOrderData.fromJson(x))),
  );
}

class DetailOrderData {
  String transactionId;
  String orderStatus;
  String paymentStatus;
  String waybill;
  dynamic expire;
  String invoice;
  int totalPrice;
  int totalCost;
  DateTime createdAt;
  bool isReviewed;
  DetailOrderStore store;
  List<Item> items;
  String courierId; 
  int courierPrice;
  String courierService;
  int courierWeight;
  String paymentAccess;
  String paymentCode;
  Buyer seller;
  Buyer buyer;

  DetailOrderData({
    required this.transactionId,
    required this.orderStatus,
    required this.paymentStatus,
    required this.waybill,
    required this.expire,
    required this.invoice,
    required this.totalPrice,
    required this.totalCost,
    required this.createdAt,
    required this.isReviewed,
    required this.store,
    required this.courierId,
    required this.courierPrice,
    required this.courierService,
    required this.courierWeight,
    required this.items,
    required this.paymentAccess,
    required this.paymentCode,
    required this.seller,
    required this.buyer,
  });

  factory DetailOrderData.fromJson(Map<String, dynamic> json) => DetailOrderData(
    transactionId: json["transaction_id"],
    orderStatus: json["order_status"],
    paymentStatus: json["payment_status"],
    waybill: json["waybill"],
    expire: json["expire"],
    invoice: json["invoice"],
    totalCost: json["total_cost"],
    totalPrice: json["total_price"],
    createdAt: DateTime.parse(json["created_at"]),
    isReviewed: json["is_reviewed"],
    store: DetailOrderStore.fromJson(json["store"]),
    courierId: json["courier_id"],
    courierPrice: json["courier_price"],
    courierService: json["courier_service"],
    courierWeight: json["courier_weight"],
    items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
    paymentAccess: json["payment_access"],
    paymentCode: json["payment_code"],
    seller: Buyer.fromJson(json["seller"]),
    buyer: Buyer.fromJson(json["buyer"]),
  );
}

class Buyer {
  String id;
  String emailAddress;
  String fullname;
  String phone;
  String address;

  Buyer({
    required this.id,
    required this.emailAddress,
    required this.fullname,
    required this.phone,
    required this.address
  });

  factory Buyer.fromJson(Map<String, dynamic> json) => Buyer(
    id: json["id"],
    emailAddress: json["email"],
    fullname: json["fullname"],
    phone: json["phone"],
    address: json["address"]
  );
}

class Item {
  DetailOrderProduct product;
  int qty;

  Item({
    required this.product,
    required this.qty,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    product: DetailOrderProduct.fromJson(json["product"]),
    qty: json["qty"],
  );
}

class DetailOrderProduct {
  String id;
  String title;
  List<Media> medias;
  int price;
  int stock;
  String caption;
  String note;
  ProductStore store;

  DetailOrderProduct({
    required this.id,
    required this.title,
    required this.medias,
    required this.price,
    required this.stock,
    required this.caption,
    required this.note,
    required this.store,
  });

  factory DetailOrderProduct.fromJson(Map<String, dynamic> json) => DetailOrderProduct(
    id: json["id"],
    title: json["title"],
    medias: List<Media>.from(json["medias"].map((x) => Media.fromJson(x))),
    price: json["price"],
    stock: json["stock"],
    caption: json["caption"],
    note: json["note"],
    store: ProductStore.fromJson(json["store"]),
  );
}

class Media {
  int id;
  String path;

  Media({
    required this.id,
    required this.path,
  });

  factory Media.fromJson(Map<String, dynamic> json) => Media(
    id: json["id"],
    path: json["path"],
  );
}

class ProductStore {
  String id;
  String logo;
  String name;
  String address;
  String province;
  String city;

  ProductStore({
    required this.id,
    required this.logo,
    required this.name,
    required this.address,
    required this.province,
    required this.city,
  });

  factory ProductStore.fromJson(Map<String, dynamic> json) => ProductStore(
    id: json["id"],
    logo: json["logo"],
    name: json["name"],
    address: json["address"],
    province: json["province"],
    city: json["city"],
  );
}

class DetailOrderStore {
  String id;
  String name;
  String logo;
  String description;
  String address;
  String province;
  String city;
  String district;
  String subdistrict;
  String postalCode;
  String phone;
  String email;
  bool isOpen;
  DateTime createdAt;

  DetailOrderStore({
    required this.id,
    required this.name,
    required this.logo,
    required this.description,
    required this.address,
    required this.province,
    required this.city,
    required this.district,
    required this.subdistrict,
    required this.postalCode,
    required this.phone,
    required this.email,
    required this.isOpen,
    required this.createdAt,
  });

  factory DetailOrderStore.fromJson(Map<String, dynamic> json) => DetailOrderStore(
    id: json["id"],
    name: json["name"],
    logo: json["logo"],
    description: json["description"],
    address: json["address"],
    province: json["province"],
    city: json["city"],
    district: json["district"],
    subdistrict: json["subdistrict"],
    postalCode: json["postal_code"],
    phone: json["phone"],
    email: json["email"],
    isOpen: json["is_open"],
    createdAt: DateTime.parse(json["created_at"]),
  );
}
