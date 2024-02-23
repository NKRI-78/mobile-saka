import './feedmedia.dart';

class AllMember {
  AllMember({
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
  List<AllMemberBody>? body;

  factory AllMember.fromJson(Map<String, dynamic> json) => AllMember(
    code: json["code"],
    message: json["message"],
    count: json["count"],
    hasNext: json["hasNext"],
    first: json["first"],
    body: List<AllMemberBody>.from(json["body"].map((x) => AllMemberBody.fromJson(x))),
  );
}

class AllMemberBody {
  AllMemberBody({
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

  factory AllMemberBody.fromJson(Map<String, dynamic> json) => AllMemberBody(
    id: json["id"],
    timezone: json["timezone"],
    nickname: json["nickname"],
    profilePic: FeedMedia.fromJson(json["profilePic"]),
    level: json["level"],
    classId: json["classId"],
  );
}
