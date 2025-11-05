import 'package:saka/data/models/feed/feedmedia.dart';

class GroupsMember {
  GroupsMember({
    this.code,
    this.message,
    this.count,
    this.hasNext,
    this.first,
    this.body,
  });

    int? code;
    String? message;
    int? count;
    bool? hasNext;
    bool? first;
    List<GroupsMemberBody>? body;

  factory GroupsMember.fromJson(Map<String, dynamic> json) => GroupsMember(
    code: json["code"],
    message: json["message"],
    count: json["count"],
    hasNext: json["hasNext"],
    first: json["first"],
    body: List<GroupsMemberBody>.from(json["body"].map((x) => GroupsMemberBody.fromJson(x))),
  );
}

class GroupsMemberBody {
  GroupsMemberBody({
    this.id,
    this.groupId,
    this.user,
    this.role,
    this.owner,
    this.status,
    this.classId,
  });

  String? id;
  String? groupId;
  User? user;
  String? role;
  bool? owner;
  int? status;
  String? classId;

  factory GroupsMemberBody.fromJson(Map<String, dynamic> json) => GroupsMemberBody(
    id: json["id"],
    groupId: json["groupId"],
    user: User.fromJson(json["user"]),
    role: json["role"],
    owner: json["owner"],
    status: json["status"],
    classId: json["classId"],
  );

}

class User {
  User({
    this.id,
    this.timezone,
    this.nickname,
    this.profilePic,
    this.level,
    this.classId,
  });

  String? id;
  String? timezone;
  String? nickname;
  FeedMedia? profilePic;
  String? level;
  String? classId;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    timezone: json["timezone"],
    nickname: json["nickname"],
    profilePic: FeedMedia.fromJson(json["profilePic"]),
    level: json["level"],
    classId: json["classId"],
  );
}