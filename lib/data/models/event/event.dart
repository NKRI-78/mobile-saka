class EventModel {
  int status;
  bool error;
  String message;
  List<EventData> data;

  EventModel({
    required this.status,
    required this.error,
    required this.message,
    required this.data,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) => EventModel(
    status: json["status"],
    error: json["error"],
    message: json["message"],
    data: List<EventData>.from(json["data"].map((x) => EventData.fromJson(x))),
  );
}

class EventData {
  int eventId;
  String description;
  DateTime startDate;
  DateTime endDate;
  int status;
  String location;
  String start;
  String end;
  String summary;
  String path;
  int shareNews;
  String createdBy;
  DateTime created;
  DateTime updated;
  List<Join> joins;
  bool join;

  EventData({
    required this.eventId,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.location,
    required this.start,
    required this.end,
    required this.summary,
    required this.path,
    required this.shareNews,
    required this.createdBy,
    required this.created,
    required this.updated,
    required this.joins,
    required this.join,
  });

   factory EventData.fromJson(Map<String, dynamic> json) => EventData(
    eventId: json["event_id"],
    description: json["description"],
    startDate: DateTime.parse(json["start_date"]),
    endDate: DateTime.parse(json["end_date"]),
    status: json["status"],
    location: json["location"],
    start: json["start"],
    end: json["end"],
    summary: json["summary"],
    path: json["path"],
    shareNews: json["share_news"],
    createdBy: json["created_by"],
    created: DateTime.parse(json["created"]),
    updated: DateTime.parse(json["updated"]),
    joins: List<Join>.from(json["joins"].map((x) => Join.fromJson(x))),
    join: json["join"],
  );
}

class Join {
  int id;
  String userId;
  String fullname;
  String profilePic;
  String eventName;
  String phoneNumber;
  String emailAddress;
  int present;
  DateTime created;
  DateTime updated;

  Join({
    required this.id,
    required this.userId,
    required this.fullname,
    required this.profilePic,
    required this.eventName,
    required this.phoneNumber,
    required this.emailAddress,
    required this.present,
    required this.created,
    required this.updated,
  });

  factory Join.fromJson(Map<String, dynamic> json) => Join(
    id: json["id"],
    userId: json["user_id"],
    fullname: json["fullname"],
    profilePic: json["profile_pic"],
    eventName: json["event_name"],
    phoneNumber: json["phone_number"],
    emailAddress: json["email_address"],
    present: json["present"],
    created: DateTime.parse(json["created"]),
    updated: DateTime.parse(json["updated"]),
  );
}
