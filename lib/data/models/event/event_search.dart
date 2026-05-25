class EventSearchModel {
  EventSearchModel({
    this.data,
    this.code,
    this.message,
  });

  List<EventSearchData>? data;
  int? code;
  String? message;

  factory EventSearchModel.fromJson(Map<String, dynamic> json) => EventSearchModel(
    data: json["body"] == null ? [] : List<EventSearchData>.from(json["body"].map((x) => EventSearchData.fromJson(x))),
    code: json["code"],
    message: json["message"],
  );

}

class EventSearchData {
  EventSearchData({
    this.eventId,
    this.description,
    this.eventDate,
    this.status,
    this.location,
    this.start,
    this.end,
    this.summary,
    this.picture,
    this.createdBy,
    this.created,
    this.updated,
    this.media,
  });

  int? eventId;
  String? description;
  DateTime? eventDate;
  bool? status;
  String? location;
  String? start;
  String? end;
  String? summary;
  int? picture;
  String? createdBy;
  DateTime? created;
  DateTime? updated;
  List<EventSearchMedia>? media;

  factory EventSearchData.fromJson(Map<String, dynamic> json) => EventSearchData(
    eventId: json["event_id"],
    description: json["description"],
    eventDate: DateTime.parse(json["event_date"]),
    status: json["status"],
    location: json["location"],
    start: json["start"],
    end: json["end"],
    summary: json["summary"],
    picture: json["picture"],
    createdBy: json["created_by"],
    created: DateTime.parse(json["created"]),
    updated: DateTime.parse(json["updated"]),
    media: json["Media"] == null ? [] : List<EventSearchMedia>.from(json["Media"].map((x) => EventSearchMedia.fromJson(x))),
  );
}

class EventSearchMedia {
  EventSearchMedia({
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

  factory EventSearchMedia.fromJson(Map<String, dynamic> json) => EventSearchMedia(
    mediaId: json["media_id"],
    status: json["status"],
    contentType: json["content_type"],
    fileLength: json["file_length"],
    originalName: json["original_name"],
    path: json["path"],
    createdBy: json["created_by"],
    created: json["created"] == null ? null : DateTime.parse(json["created"]),
    updated: json["updated"] == null ? null : DateTime.parse(json["updated"]),
  );
}
