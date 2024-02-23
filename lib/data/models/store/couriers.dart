class CouriersModel {
  CouriersModel({
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
  List<CouriersModelList>? body;
  dynamic error;

  factory CouriersModel.fromJson(Map<String, dynamic> json) => CouriersModel(
    code: json["code"],
    message: json["message"],
    count: json["count"],
    first: json["first"],
    body: json["body"] == null ? [] : List<CouriersModelList>.from(json["body"].map((x) => CouriersModelList.fromJson(x))),
    error: json["error"],
  );
}

class CouriersModelList {
  CouriersModelList({
    this.id,
    this.name,
    this.image,
    this.checkPriceSupported,
    this.checkResiSupported,
    this.classId,
  });

  String? id;
  String? name;
  String? image;
  bool? checkPriceSupported;
  bool? checkResiSupported;
  String? classId;

  factory CouriersModelList.fromJson(Map<String, dynamic> json) =>
    CouriersModelList(
      id: json["id"],
      name: json["name"],
      image: json["image"],
      checkPriceSupported: json["checkPriceSupported"],
      checkResiSupported:json["checkResiSupported"],
      classId: json["classId"],
    );
}
