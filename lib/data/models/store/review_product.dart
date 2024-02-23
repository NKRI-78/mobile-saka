class ReviewProductModel {
  ReviewProductModel({
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
  List<ReviewProductList>? body;
  dynamic error;

  factory ReviewProductModel.fromJson(Map<String, dynamic> json) =>
  ReviewProductModel(
    code: json["code"],
    message: json["message"],
    count: json["count"],
    first: json["first"],
    body: json["body"] == null ? [] : List<ReviewProductList>.from(json["body"].map((x) => ReviewProductList.fromJson(x))),
    error: json["error"],
  );
}

class ReviewProductList {
  ReviewProductList({
    this.id,
    this.name,
    this.pictures,
    this.date,
    this.review,
    this.classId,
  });

  String? id;
  String? name;
  List<ReviewProductPicture>? pictures;
  String? date;
  String? review;
  String? classId;

  factory ReviewProductList.fromJson(Map<String, dynamic> json) => ReviewProductList(
    id: json["id"],
    name: json["name"],
    pictures: json["pictures"] == null ? [] : List<ReviewProductPicture>.from(json["pictures"].map((x) => ReviewProductPicture.fromJson(x))),
    date: json["date"],
    review: json["review"],
    classId: json["classId"],
  );
}

class ReviewProductPicture {
  ReviewProductPicture({
    this.originalName,
    this.fileLength,
    this.path,
    this.contentType,
    this.classId,
  });

  String? originalName;
  int? fileLength;
  String? path;
  String? contentType;
  String? classId;

  factory ReviewProductPicture.fromJson(Map<String, dynamic> json) =>
    ReviewProductPicture(
      originalName: json["originalName"],
      fileLength: json["fileLength"],
      path: json["path"],
      contentType: json["contentType"],
      classId: json["classId"],
    );
}
