class EventModel {
  EventModel({
    this.data,
    this.code,
    this.message,
  });

  List<EventData>? data;
  int? code;
  String? message;

  factory EventModel.fromJson(Map<String, dynamic> json) => EventModel(
    data: json["body"] == null ? [] : List<EventData>.from(json["body"].map((x) => EventData.fromJson(x))),
    code: json["code"] == null ? null : json["code"],
    message: json["message"] == null ? null : json["message"],
  );
}

class EventData {
  EventData({
    this.eventId,
    this.description,
    this.eventDate,
    this.status,
    this.location,
    this.start,
    this.end,
    this.summary,
    this.path,
    this.userJoined,
  });

  int? eventId;
  String? description;
  DateTime? eventDate;
  bool? status;
  String? location;
  String? start;
  String? end;
  String? summary;
  String? path;
  bool? userJoined;

  factory EventData.fromJson(Map<String, dynamic> json) => EventData(
    eventId: json["event_id"] == null ? null : json["event_id"],
    description: json["description"] == null ? null : json["description"],
    eventDate: json["event_date"] == null ? null : DateTime.parse(json["event_date"]),
    status: json["status"] == null ? null : json["status"],
    location: json["location"] == null ? null : json["location"],
    start: json["start"] == null ? null : json["start"],
    end: json["end"] == null ? null : json["end"],
    summary: json["summary"] == null ? null : json["summary"],
    path: json["path"] == null ? null : json["path"],
    userJoined: json["user_joined"] == null ? null : json["user_joined"],
  );
}
