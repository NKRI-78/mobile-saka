class ReviewProductDetailModel {
  ReviewProductDetailModel({
    this.code,
    this.message,
    this.count,
    this.first,
    this.data,
    this.error,
  });

  int? code;
  String? message;
  int? count;
  bool? first;
  List<ReviewProductDetailData>? data;
  dynamic error;

  factory ReviewProductDetailModel.fromJson(Map<String, dynamic> json) => ReviewProductDetailModel(
    code: json["code"],
    message: json["message"],
    count: json["count"],
    first: json["first"],
    data: json["body"] == null ? [] : List<ReviewProductDetailData>.from(json["body"].map((x) => ReviewProductDetailData.fromJson(x))),
    error: json["error"],
  );
}

class ReviewProductDetailData {
  ReviewProductDetailData({
    this.id,
    this.userId,
    this.user,
    this.review,
    this.photos,
    this.star,
    this.created,
    this.classId,
  });

  String? id;
  String? userId;
  ReviewProductDetailUser? user;
  String? review;
  List<ReviewProductDetailPhoto>? photos;
  dynamic star;
  String? created;
  String? classId;

  factory ReviewProductDetailData.fromJson(Map<String, dynamic> json) => ReviewProductDetailData(
    id: json["id"],
    userId: json["userId"],
    user: ReviewProductDetailUser.fromJson(json["user"]),
    review: json["review"],
    photos: json["photos"] == null ? [] : List<ReviewProductDetailPhoto>.from(json["photos"].map((x) => ReviewProductDetailPhoto.fromJson(x))),
    star: json["star"],
    created: json["created"],
    classId: json["classId"],
  );
}

class ReviewProductDetailPhoto {
  ReviewProductDetailPhoto({
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

  factory ReviewProductDetailPhoto.fromJson(Map<String, dynamic> json) => ReviewProductDetailPhoto(
    originalName: json["originalName"],
    fileLength: json["fileLength"],
    path: json["path"],
    contentType: json["contentType"],
    classId: json["classId"],
  );
}

class ReviewProductDetailUser {
  ReviewProductDetailUser({
    this.uid,
    this.fullname,
    this.username,
    this.address,
    this.email,
    this.created,
    this.avatar,
    this.phone,
    this.emailActivated,
    this.phoneActivated,
    this.classId,
  });

  String? uid;
  String? fullname;
  String? username;
  dynamic address;
  String? email;
  String? created;
  String? avatar;
  String? phone;
  bool? emailActivated;
  bool? phoneActivated;
  String? classId;

  factory ReviewProductDetailUser.fromJson(Map<String, dynamic> json) => ReviewProductDetailUser(
    uid: json["uid"],
    fullname: json["fullname"],
    username: json["username"],
    address: json["address"],
    email: json["email"],
    created: json["created"],
    avatar: json["avatar"],
    phone: json["phone"],
    emailActivated: json["emailActivated"],
    phoneActivated: json["phoneActivated"],
    classId: json["classId"],
  );
}
