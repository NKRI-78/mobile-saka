import 'package:saka/data/models/feed/feedmedia.dart';

class GroupsMetaData {
  GroupsMetaData({
    this.code,
    this.message,
    this.nextCursor,
    this.body,
    this.count,
    this.hasNext,
    this.first
  });

  int? code;
  String? message;
  String? nextCursor;
  List<GroupsMetaDataListBody>? body;
  int? count;
  bool? hasNext;
  bool? first;

  factory GroupsMetaData.fromJson(Map<String, dynamic> json) => GroupsMetaData(
    code: json["code"],
    message: json["message"],
    nextCursor: json["nextCursor"],
    count: json["count"],
    hasNext: json["hasNext"],
    first: json["first"],
    body: List<GroupsMetaDataListBody>.from(json["body"].map((x) => GroupsMetaDataListBody.fromJson(x))),
  );
}

class GroupsMetaDataListBody {
  GroupsMetaDataListBody({
    this.id,
    this.type,
    this.name,
    this.description,
    this.background,
    this.classId,
    this.profilePic,
    this.created,
  });

  String? id;
  String? type;
  String? name;
  String? description;
  FeedMedia? background;
  FeedMedia? profilePic;
  String? classId;
  String? created;

  factory GroupsMetaDataListBody.fromJson(Map<String, dynamic> json) => GroupsMetaDataListBody(
    id: json["id"],
    type: json["type"],
    name: json["name"],
    description: json["description"],
    background: FeedMedia.fromJson(json["background"]),
    profilePic: FeedMedia.fromJson(json["profilePic"]),
    classId: json["classId"],
    created: json["created"],
  );
}