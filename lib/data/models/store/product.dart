class ProductModel {
  ProductModel({
    this.status,
    this.message,
    this.data,
  });

  int? status;
  String? message;
  List<Product>? data;

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? [] : List<Product>.from(json["data"].map((x) => Product.fromJson(x))),
  );

}

class Product {
  Product({
    this.id,
    this.productName,
    this.productDescription,
    this.productCondition,
    this.latitude,
    this.longitude,
    this.location,
    this.productImage,
    this.productPrice,
    this.isActive,
    this.isSold,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  String? id;
  String? productName;
  String? productDescription;
  bool? productCondition;
  String? latitude;
  String? longitude;
  String? location;
  String? productImage;
  int? productPrice;
  bool? isActive;
  bool? isSold;
  String? userId;
  DateTime? createdAt;
  DateTime? updatedAt;
  User? user;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"],
    productName: json["product_name"],
    productDescription: json["product_description"],
    productCondition: json["product_condition"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    location: json["location"],
    productImage: json["product_image"],
    productPrice: json["product_price"],
    isActive: json["is_active"],
    isSold: json["is_sold"],
    userId: json["user_id"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    user: User.fromJson(json["user"]),
  );
}

class User {
  User({
    this.uid,
    this.fullName,
    this.username,
    this.nra,
    this.ynci,
    this.alamat,
    this.noKtp,
    this.noSim,
    this.closestName,
    this.closestNo,
    this.golDarah,
    this.shortBio,
    this.avatarUrl,
    this.email,
    this.authKey,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.links,
  });

  String? uid;
  String? fullName;
  String? username;
  String? nra;
  String? ynci;
  String? alamat;
  String? noKtp;
  String? noSim;
  String? closestName;
  String? closestNo;
  String? golDarah;
  String? shortBio;
  String? avatarUrl;
  String? email;
  String? authKey;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  Links? links;

  factory User.fromJson(Map<String, dynamic> json) => User(
    uid: json["uid"],
    fullName: json["full_name"],
    username: json["username"],
    nra: json["nra"],
    ynci: json["ynci"],
    alamat: json["alamat"],
    noKtp: json["no_ktp"],
    noSim:  json["no_sim"],
    closestName: json["closest_name"],
    closestNo: json["closest_no"],
    golDarah: json["gol_darah"],
    shortBio:  json["short_bio"],
    avatarUrl: json["avatar_url"],
    email:  json["email"],
    authKey: json["auth_key"],
    status: json["status"],
    createdAt:  DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    links: Links.fromJson(json["links"]),
  );
}

class Links {
  Links({
    this.self,
  });

  String? self;

  factory Links.fromJson(Map<String, dynamic> json) => Links(
    self:  json["self"],
  );
}
