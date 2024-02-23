class ListPricePraBayarModel {
  ListPricePraBayarModel({
    this.code,
    this.message,
    this.count,
    this.first,
    this.body,
    this.error,
  });

  int? code;
  String? message;
  int? count;
  bool? first;
  List<ListPricePraBayarData>? body;
  dynamic error;

  factory ListPricePraBayarModel.fromJson(Map<String, dynamic> json) => ListPricePraBayarModel(
    code: json["code"],
    message: json["message"],
    count: json["count"],
    first: json["first"],
    body: List<ListPricePraBayarData>.from(json["body"].map((x) => ListPricePraBayarData.fromJson(x))),
    error: json["error"],
  );
}

class ListPricePraBayarData {
  ListPricePraBayarData({
    this.productId,
    this.name,
    this.description,
    this.price,
    this.type,
    this.group,
    this.category,
    this.totalAdminFee,
    this.classId,
  });

  String? productId;
  String? name;
  String? description;
  dynamic price;
  String? type;
  String? group;
  String? category;
  dynamic totalAdminFee;
  String? classId;

  factory ListPricePraBayarData.fromJson(Map<String, dynamic> json) => ListPricePraBayarData(
    productId: json["productId"],
    name: json["name"],
    description: json["description"],
    price: json["price"] ?? "",
    type: json["type"],
    group: json["group"],
    category: json["category"],
    totalAdminFee: json["totalAdminFee"] ?? "",
    classId: json["classId"],
  );
}
