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
  ProductDetail? product;

  ProductDetailData({
    this.product,
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
  int weight;
  String caption;
  dynamic rating;
  List<Review> reviews;
  Category category;
  ProductStore store;

  ProductDetail({
    required this.id,
    required this.title,
    required this.medias,
    required this.price,
    required this.stock,
    required this.weight,
    required this.rating,
    required this.caption,
    required this.reviews,
    required this.category,
    required this.store,
  });

  factory ProductDetail.fromJson(Map<String, dynamic> json) => ProductDetail(
    id: json["id"],
    title: json["title"],
    medias: List<ProductMedia>.from(json["medias"].map((x) => ProductMedia.fromJson(x))),
    price: json["price"],
    stock: json["stock"],
    weight: json["weight"],
    caption: json["caption"],
    rating: json["rating"],
    reviews: List<Review>.from(json["reviews"].map((x) => Review.fromJson(x))),
    category: Category.fromJson(json["category"]),
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

class Review {
  User user;
  String caption;
  List<ReviewMedia> medias;
  String rate;
  DateTime createdAt;

  Review({
    required this.user,
    required this.caption,
    required this.medias,
    required this.rate,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
    user: User.fromJson(json["user"]),
    caption: json["caption"],
    medias: List<ReviewMedia>.from(json["medias"].map((x) => ReviewMedia.fromJson(x))),
    rate: json["rate"],
    createdAt: DateTime.parse(json["created_at"]),
  );
}

class ReviewMedia {
  String path;

  ReviewMedia({
    required this.path,
  });

  factory ReviewMedia.fromJson(Map<String, dynamic> json) => ReviewMedia(
    path: json["path"],
  );
}

class User {
  String avatar;
  String fullname;

  User({
    required this.avatar,
    required this.fullname,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    avatar: json["avatar"],
    fullname: json["fullname"],
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

class Category {
  String id;
  String name;

  Category({
    required this.id,
    required this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"],
    name: json["name"]!,
  );
}