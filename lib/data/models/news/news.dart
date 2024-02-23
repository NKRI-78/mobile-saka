class NewsModel {
  NewsModel({
    this.data,
    this.code,
    this.message,
  });

  List<NewsData>? data;
  int? code;
  String? message;

  factory NewsModel.fromJson(Map<String, dynamic> json) => NewsModel(
    data: json["body"] == null ? [] : List<NewsData>.from(json["body"].map((x) => NewsData.fromJson(x))),
    code: json["code"],
    message: json["message"],
  );
}

class NewsData {
  NewsData({
    this.articleId,
    this.content,
    this.highlight,
    this.title,
    this.type,
    this.picture,
    this.status,
    this.isEvent,
    this.createdBy,
    this.created,
    this.updated,
    this.media,
  });

  int? articleId;
  String? content;
  int? highlight;
  String? title;
  String? type;
  int? picture;
  bool? status;
  bool? isEvent;
  String? createdBy;
  DateTime? created;
  DateTime? updated;
  List<NewsMedia>? media;

  factory NewsData.fromJson(Map<String, dynamic> json) => NewsData(
    articleId: json["article_id"],
    content: json["content"],
    highlight: json["highlight"],
    title: json["title"],
    type: json["type"],
    picture: json["picture"],
    status: json["status"],
    isEvent: json["is_event"],
    createdBy: json["created_by"],
    created: DateTime.parse(json["created"]),
    updated: DateTime.parse(json["updated"]),
    media: List<NewsMedia>.from(json["Media"].map((x) => NewsMedia.fromJson(x))),
  );
}

class NewsMedia {
  NewsMedia({
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
  String? status;
  String? contentType;
  int? fileLength;
  String? originalName;
  String? path;
  String? createdBy;
  DateTime? created;
  DateTime? updated;

  factory NewsMedia.fromJson(Map<String, dynamic> json) => NewsMedia(
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
