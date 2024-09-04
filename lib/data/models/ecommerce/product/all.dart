class ProductModel {
  int status;
  bool error;
  String message;
  ProductData data;

  ProductModel({
    required this.status,
    required this.error,
    required this.message,
    required this.data,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    status: json["status"],
    error: json["error"],
    message: json["message"],
    data: ProductData.fromJson(json["data"]),
  );
}

class ProductData {
  PageDetail pageDetail;
  List<Product> products;

  ProductData({
    required this.pageDetail,
    required this.products,
  });

  factory ProductData.fromJson(Map<String, dynamic> json) => ProductData(
    pageDetail: PageDetail.fromJson(json["page_detail"]),
    products: List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
  );
}

class PageDetail {
  bool hasMore;
  int total;
  int perPage;
  int nextPage;
  int prevPage;
  int currentPage;
  String nextUrl;
  String prevUrl;

  PageDetail({
    required this.hasMore,
    required this.total,
    required this.perPage,
    required this.nextPage,
    required this.prevPage,
    required this.currentPage,
    required this.nextUrl,
    required this.prevUrl,
  });

  factory PageDetail.fromJson(Map<String, dynamic> json) => PageDetail(
    hasMore: json["has_more"],
    total: json["total"],
    perPage: json["per_page"],
    nextPage: json["next_page"],
    prevPage: json["prev_page"],
    currentPage: json["current_page"],
    nextUrl: json["next_url"],
    prevUrl: json["prev_url"],
  );
}

class Product {
  String id;
  String title;
  List<Media> medias;
  int price;
  int stock;
  String caption;
  Store store;

  Product({
    required this.id,
    required this.title,
    required this.medias,
    required this.price,
    required this.stock,
    required this.caption,
    required this.store,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"],
    title: json["title"],
    medias: List<Media>.from(json["medias"].map((x) => Media.fromJson(x))),
    price: json["price"],
    stock: json["stock"],
    caption: json["caption"],
    store: Store.fromJson(json["store"]),
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

class Store {
  String id;
  String logo;
  String name;
  String caption;
  String address;
  String province;
  String city;

  Store({
    required this.id,
    required this.logo,
    required this.name,
    required this.caption,
    required this.address,
    required this.province,
    required this.city,
  });

  factory Store.fromJson(Map<String, dynamic> json) => Store(
    id: json["id"],
    logo: json["logo"],
    name: json["name"],
    caption: json["caption"],
    address: json["address"],
    province: json["province"],
    city: json["city"],
  );
}
