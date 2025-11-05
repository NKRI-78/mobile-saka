import 'package:saka/data/models/feed/feedlike.dart';
import 'package:saka/data/models/feed/feedmedia.dart';

class SingleReply {
  SingleReply({
    this.code,
    this.message,
    this.body,
  });

  int? code;
  String? message;
  SingleReplyBody? body;

  factory SingleReply.fromJson(Map<String, dynamic> json) => SingleReply(
    code: json["code"],
    message: json["message"],
    body: SingleReplyBody.fromJson(json["body"]),
  );
}

class SingleReplyBody {
  SingleReplyBody({
    this.id,
    this.user,
    this.targetId,
    this.content,
    this.numOfLikes,
    this.respondDate,
    this.liked,
    this.created,
    this.type,
    this.classId,
  });

  String? id;
  SingleReplyUser? user;
  String? targetId;
  SingleReplyContent? content;
  int? numOfLikes;
  String? respondDate;
  List<FeedLiked>? liked;
  String? created;
  String? type;
  String? classId;

  factory SingleReplyBody.fromJson(Map<String, dynamic> json) => SingleReplyBody(
    id: json["id"],
    user: SingleReplyUser.fromJson(json["user"]),
    targetId: json["targetId"],
    content: SingleReplyContent.fromJson(json["content"]),
    numOfLikes: json["numOfLikes"],
    respondDate: json["respondDate"],
    liked: List<FeedLiked>.from(json["liked"].map((x) => FeedLiked.fromJson(x))),
    created: json["created"],
    type: json["type"],
    classId: json["classId"],
  );
}

class SingleReplyContent {
  SingleReplyContent({
    this.charset,
    this.text,
    this.classId,
  });

  String? charset;
  String? text;
  String? classId;

  factory SingleReplyContent.fromJson(Map<String, dynamic> json) => SingleReplyContent(
    charset: json["charset"],
    text: json["text"],
    classId: json["classId"],
  );
}

class SingleReplyUser {
  SingleReplyUser({
    this.id,
    this.timezone,
    this.nickname,
    this.profilePic,
    this.level,
    this.created,
    this.classId,
  });

  String? id;
  String? timezone;
  String? nickname;
  FeedMedia? profilePic;
  String? level;
  String? created;
  String? classId;

  factory SingleReplyUser.fromJson(Map<String, dynamic> json) => SingleReplyUser(
    id: json["id"],
    timezone: json["timezone"],
    nickname: json["nickname"],
    profilePic: FeedMedia.fromJson(json["profilePic"]),
    level: json["level"],
    created: json["created"],
    classId: json["classId"],
  );
}


