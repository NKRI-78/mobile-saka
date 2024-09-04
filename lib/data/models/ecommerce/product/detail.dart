class ProductDetailModel {
  int status;
  bool error;
  String message;
  ProductDetailData data;

  ProductDetailModel({
    required this.status,
    required this.error,
    required this.message,
    required this.data,
  });

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) => ProductDetailModel(
    status: json["status"],
    error: json["error"],
    message: json["message"],
    data: ProductDetailData.fromJson(json["data"]),
  );
}

class ProductDetailData {
  ProductDetail product;

  ProductDetailData({
    required this.product,
  });

  factory ProductDetailData.fromJson(Map<String, dynamic> json) => ProductDetailData(
    product: ProductDetail.fromJson(json["product"]),
  );
}

class ProductDetail {
  String id;
  String title;
  List<ProductMedia> medias;
  int price;
  int stock;
  String caption;
  ProductStore store;

  ProductDetail({
    required this.id,
    required this.title,
    required this.medias,
    required this.price,
    required this.stock,
    required this.caption,
    required this.store,
  });

  factory ProductDetail.fromJson(Map<String, dynamic> json) => ProductDetail(
    id: json["id"],
    title: json["title"],
    medias: List<ProductMedia>.from(json["medias"].map((x) => ProductMedia.fromJson(x))),
    price: json["price"],
    stock: json["stock"],
    caption: json["caption"],
    store: ProductStore.fromJson(json["store"]),
  );
}

class ProductMedia {
  int id;
  String path;

  ProductMedia({
    required this.id,
    required this.path,
  });

  factory ProductMedia.fromJson(Map<String, dynamic> json) => ProductMedia(
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
