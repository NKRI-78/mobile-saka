import 'package:saka/data/models/feed/feedlike.dart';
import 'package:saka/data/models/feed/feedmedia.dart';

class Reply {
  Reply({
    this.code,
    this.message,
    this.nextCursor,
    this.count,
    this.hasNext,
    this.first,
    this.body,
  });

  int? code;
  String? message;
  String? nextCursor;
  int? count;
  bool? hasNext;
  bool? first;
  List<ReplyBody>? body;

  factory Reply.fromJson(Map<String, dynamic> json) => Reply(
    code: json["code"],
    message: json["message"],
    nextCursor: json["nextCursor"],
    count: json["count"],
    hasNext: json["hasNext"],
    first: json["first"],
    body: List<ReplyBody>.from(json["body"].map((x) => ReplyBody.fromJson(x))),
  );
}

class ReplyBody {
  ReplyBody({
    this.id,
    this.user,
    this.targetId,
    this.content,
    this.numOfLikes,
    this.liked,
    this.created,
    this.classId,
    this.type
  });

  String? id;
  ReplyUser? user;
  String? targetId;
  Content? content;
  int? numOfLikes;
  List<FeedLiked>? liked;
  String? created;
  String? classId;
  String? type;

  factory ReplyBody.fromJson(Map<String, dynamic> json) => ReplyBody(
    id: json["id"],
    user: ReplyUser.fromJson(json["user"]),
    targetId: json["targetId"],
    content: Content.fromJson(json["content"]),
    numOfLikes: json["numOfLikes"],
    liked: List<FeedLiked>.from(json["liked"].map((x) => FeedLiked.fromJson(x))),
    created: json["created"],
    classId: json["classId"],
    type: json["type"]
  );    
}

class Content {
  Content({
    this.charset,
    this.text,
    this.classId,
  });

  String? charset;
  String? text;
  String? classId;

  factory Content.fromJson(Map<String, dynamic> json) => Content(
    charset: json["charset"],
    text: json["text"],
    classId: json["classId"],
  );
}

class ReplyUser {
  ReplyUser({
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

  factory ReplyUser.fromJson(Map<String, dynamic> json) => ReplyUser(
    id: json["id"],
    timezone: json["timezone"],
    nickname: json["nickname"],
    profilePic: FeedMedia.fromJson(json["profilePic"]),
    level: json["level"],
    classId: json["classId"],
  );
}

