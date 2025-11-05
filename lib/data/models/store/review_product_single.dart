class ReviewProductSingleModel {
  ReviewProductSingleModel({
    this.code,
    this.message,
    this.body,
    this.error,
  });

  int? code;
  String? message;
  ReviewProductSingle? body;
  dynamic error;

  factory ReviewProductSingleModel.fromJson(Map<String, dynamic> json) =>
    ReviewProductSingleModel(
      code: json["code"],
      message:  json["message"],
      body: ReviewProductSingle.fromJson(json["body"]),
      error: json["error"],
    );

}

class ReviewProductSingle {
  ReviewProductSingle({
    this.id,
    this.userId,
    this.review,
    this.photos,
    this.star,
    this.classId,
  });

  String? id;
  String? userId;
  String? review;
  List<ReviewPhoto>? photos;
  double? star;
  String? classId;

  factory ReviewProductSingle.fromJson(Map<String, dynamic> json) =>
    ReviewProductSingle(
      id: json["id"],
      userId: json["userId"],
      review: json["review"],
      photos: json["photos"] == null ? [] : List<ReviewPhoto>.from(json["photos"].map((x) => ReviewPhoto.fromJson(x))),
      star: json["star"],
      classId: json["classId"],
    );
}

class ReviewPhoto {
  ReviewPhoto({
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

  factory ReviewPhoto.fromJson(Map<String, dynamic> json) => ReviewPhoto(
    originalName: json["originalName"],
    fileLength: json["fileLength"],
    path: json["path"],
    contentType: json["contentType"],
    classId: json["classId"],
  );
}
