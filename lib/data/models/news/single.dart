class SingleNewsModel {
  List<SingleNewsData> body;
  int code;
  String message;

  SingleNewsModel({
    required this.body,
    required this.code,
    required this.message,
  });

  factory SingleNewsModel.fromJson(Map<String, dynamic> json) => SingleNewsModel(
    body: List<SingleNewsData>.from(json["body"].map((x) => SingleNewsData.fromJson(x))),
    code: json["code"],
    message: json["message"],
  );
}

class SingleNewsData {
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
  List<Media>? media;

  SingleNewsData({
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

  factory SingleNewsData.fromJson(Map<String, dynamic> json) => SingleNewsData(
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
    media: List<Media>.from(json["Media"].map((x) => Media.fromJson(x))),
  );
}

class Media {
  int mediaId;
  int status;
  String contentType;
  int fileLength;
  String originalName;
  String path;
  String createdBy;
  DateTime created;
  DateTime updated;

  Media({
    required this.mediaId,
    required this.status,
    required this.contentType,
    required this.fileLength,
    required this.originalName,
    required this.path,
    required this.createdBy,
    required this.created,
    required this.updated,
  });

  factory Media.fromJson(Map<String, dynamic> json) => Media(
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
