class CheckoutListModel {
  int status;
  bool error;
  String message;
  CheckoutListData data;

  CheckoutListModel({
    required this.status,
    required this.error,
    required this.message,
    required this.data,
  });

  factory CheckoutListModel.fromJson(Map<String, dynamic> json) => CheckoutListModel(
    status: json["status"],
    error: json["error"],
    message: json["message"],
    data: CheckoutListData.fromJson(json["data"]),
  );
}

class CheckoutListData {
  bool? nextToPayment;
  List<CheckoutProductDetail>? productDetails;
  int? totalItem;
  int? totalPrice;
  int? totalCostValue;
  int? totalWeight;
  List<CheckoutStore>? stores;

  CheckoutListData({
    this.nextToPayment,
    this.productDetails,
    this.totalItem,
    this.totalPrice,
    this.totalCostValue,
    this.totalWeight,
    this.stores,
  });

  factory CheckoutListData.fromJson(Map<String, dynamic> json) => CheckoutListData(
    nextToPayment: json["next_to_payment"],
    productDetails: List<CheckoutProductDetail>.from(json["product_details"].map((x) => CheckoutProductDetail.fromJson(x))),
    totalItem: json["total_item"],
    totalPrice: json["total_price"],
    totalCostValue: json["total_cost_value"],
    totalWeight: json["total_weight"],
    stores: List<CheckoutStore>.from(json["stores"].map((x) => CheckoutStore.fromJson(x))),
  );
}

class CheckoutProductDetail {
  String name;
  int price;
  int qty;

  CheckoutProductDetail({
    required this.name,
    required this.price,
    required this.qty,
  });

  factory CheckoutProductDetail.fromJson(Map<String, dynamic> json) => CheckoutProductDetail(
    name: json["name"],
    price: json["price"],
    qty: json["qty"],
  );
}

class CheckoutStore {
  String id;
  String name;
  String address;
  Courier courier;
  List<CheckoutProduct> products;

  CheckoutStore({
    required this.id,
    required this.name,
    required this.address,
    required this.courier,
    required this.products,
  });

  factory CheckoutStore.fromJson(Map<String, dynamic> json) => CheckoutStore(
    id: json["id"],
    name: json["name"],
    address: json["address"],
    courier: Courier.fromJson(json["courier"]),
    products: List<CheckoutProduct>.from(json["products"].map((x) => CheckoutProduct.fromJson(x))),
  );
}

class Courier {
  String code;
  String name;
  String description;
  String service;
  Cost cost;

  Courier({
    required this.code,
    required this.name,
    required this.description,
    required this.service,
    required this.cost,
  });

  factory Courier.fromJson(Map<String, dynamic> json) => Courier(
    code: json["code"],
    name: json["name"],
    description: json["description"],
    service: json["service"],
    cost: Cost.fromJson(json["cost"]),
  );
}

class Cost {
  int value;
  String etd;
  String note;

  Cost({
    required this.value,
    required this.etd,
    required this.note,
  });

  factory Cost.fromJson(Map<String, dynamic> json) => Cost(
    value: json["value"],
    etd: json["etd"],
    note: json["note"],
  );

}

class CheckoutProduct {
  String id;
  String name;
  String picture;
  int price;
  int qty;
  int weight;

  CheckoutProduct({
    required this.id,
    required this.name,
    required this.picture,
    required this.price,
    required this.qty,
    required this.weight,
  });

  factory CheckoutProduct.fromJson(Map<String, dynamic> json) => CheckoutProduct(
    id: json["id"],
    name: json["name"],
    picture: json["picture"],
    price: json["price"],
    qty: json["qty"],
    weight: json["weight"],
  );
}
