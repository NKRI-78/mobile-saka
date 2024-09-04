import 'package:flutter/material.dart';

class CartModel {
  int status;
  bool error;
  String message;
  CartData data;

  CartModel({
    required this.status,
    required this.error,
    required this.message,
    required this.data,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
    status: json["status"],
    error: json["error"],
    message: json["message"],
    data: CartData.fromJson(json["data"]),
  );
}

class CartData {
  int? totalItem;
  int? totalPrice;
  List<StoreItem>? stores;

  CartData({
    this.totalItem,
    this.totalPrice,
    this.stores,
  });

  factory CartData.fromJson(Map<String, dynamic> json) => CartData(
    totalItem: json["total_item"],
    totalPrice: json["total_price"],
    stores: List<StoreItem>.from(json["stores"].map((x) => StoreItem.fromJson(x))),
  );
}

class Cart {
  TextEditingController totalCartC;
  TextEditingController noteC;
  String id;
  bool selected;
  int qty;
  bool isOutStock;
  String note;
  
  Cart({
    required this.totalCartC,
    required this.noteC,
    required this.id,
    required this.selected,
    required this.qty,
    required this.isOutStock,
    required this.note,
  });

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
    id: json["id"],
    selected: json["selected"],
    qty: json["qty"],
    isOutStock: json["is_out_stock"],
    note: json["note"],
    noteC: TextEditingController(text: json["note"].toString()),
    totalCartC: TextEditingController(text: json["qty"].toString()),
  );
}

class StoreItem {
  bool selected;
  StoreItemData store;
  List<StoreData> items;

  StoreItem({
    required this.selected,
    required this.store,
    required this.items,
  });

  factory StoreItem.fromJson(Map<String, dynamic> json) => StoreItem(
    selected: json["selected"],
    store: StoreItemData.fromJson(json["store"]),
    items: List<StoreData>.from(json["items"].map((x) => StoreData.fromJson(x))),
  );
}

class StoreData {
  Cart cart;
  String id;
  String name;
  String picture;
  int price;
  int weight;
  int stock;

  StoreData({
    required this.cart,
    required this.id,
    required this.name,
    required this.picture,
    required this.price,
    required this.weight,
    required this.stock,
  });

  factory StoreData.fromJson(Map<String, dynamic> json) => StoreData(
    cart: Cart.fromJson(json["cart"]),
    id: json["id"],
    name: json["name"],
    picture: json["picture"],
    price: json["price"],
    weight: json["weight"],
    stock: json["stock"],
  );
}

class StoreItemData {
  String id;
  String name;
  String logo;
  String description;
  String address;

  StoreItemData({
    required this.id,
    required this.name,
    required this.logo,
    required this.description,
    required this.address,
  });

  factory StoreItemData.fromJson(Map<String, dynamic> json) => StoreItemData(
    id: json["id"],
    name: json["name"],
    logo: json["logo"],
    description: json["description"],
    address: json["address"],
  );
}