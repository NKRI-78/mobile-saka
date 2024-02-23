import 'package:saka/data/models/feed/feedmedia.dart';

class SingleGroup {
  SingleGroup({
    this.code,
    this.message,
    this.body,
  });

  int? code;
  String? message;
  SingleGroupsBody? body;

  factory SingleGroup.fromJson(Map<String, dynamic> json) => SingleGroup(
    code: json["code"],
    message: json["message"],
    body: SingleGroupsBody.fromJson(json["body"]),
  );
}

class SingleGroupsBody {
  SingleGroupsBody({
    this.id,
    this.type,
    this.name,
    this.description,
    this.background,
    this.profilePic,
    this.created,
    this.classId,
  });

    String? id;
    String? type;
    String? name;
    String? description;
    FeedMedia? background;
    FeedMedia? profilePic;
    String? created;
    String? classId;

  factory SingleGroupsBody.fromJson(Map<String, dynamic> json) => SingleGroupsBody(
    id: json["id"],
    type: json["type"],
    name: json["name"],
    description: json["description"],
    background: json["background"] == null ? null : FeedMedia.fromJson(json["background"]),
    profilePic: json["profilePic"] == null ? null : FeedMedia.fromJson(json["profilePic"]),
    created: json["created"],
    classId: json["classId"],
  );
}