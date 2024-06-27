class BannerModel {
  BannerModel({
    this.data,
    this.code,
    this.message,
  });

  List<BannerData>? data;
  int? code;
  String? message;

  factory BannerModel.fromJson(Map<String, dynamic> json) => BannerModel(
    data: List<BannerData>.from(json["body"].map((x) => BannerData.fromJson(x))),
    code: json["code"],
    message: json["message"],
  );
}

class BannerData {
  BannerData({
    this.carouselId,
    this.name,
    this.placement,
    this.picture,
    this.status,
    this.createdBy,
    this.created,
    this.updated,
    this.media,
  });

  int? carouselId;
  String? name;
  int? placement;
  int? picture;
  bool? status;
  String? createdBy;
  DateTime? created;
  DateTime? updated;
  List<BannerMedia>? media;

  factory BannerData.fromJson(Map<String, dynamic> json) => BannerData(
    carouselId: json["carousel_id"],
    name: json["name"],
    placement: json["placement"],
    picture: json["picture"],
    status: json["status"],
    createdBy: json["created_by"],
    created: DateTime.parse(json["created"]),
    updated: DateTime.parse(json["updated"]),
    media: List<BannerMedia>.from(json["Media"].map((x) => BannerMedia.fromJson(x))),
  );
}

class BannerMedia {
  BannerMedia({
    this.mediaId,
    this.status,
    this.contentType,
    this.fileLength,
    this.originalName,
    this.path,
    this.createdBy,
    this.created,
    this.updated,
  });

  int? mediaId;
  int? status;
  String? contentType;
  int? fileLength;
  String? originalName;
  String? path;
  String? createdBy;
  DateTime? created;
  DateTime? updated;

  factory BannerMedia.fromJson(Map<String, dynamic> json) => BannerMedia(
    mediaId: json["media_id"],
    status: json["status"],
    contentType: json["content_type"],
    fileLength: json["file_length"],
    originalName: json["original_name"],
    path: json["path"],
    createdBy: json["created_by"],
    created: DateTime.parse(json["created"]),
    updated: DateTime.parse(json["updated"]),
  );
}
