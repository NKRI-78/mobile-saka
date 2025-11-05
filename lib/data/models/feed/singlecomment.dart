import 'package:saka/data/models/feed/feedlike.dart';
import 'package:saka/data/models/feed/feedmedia.dart';

class SingleComment {
  SingleComment({
    this.code,
    this.message,
    this.body,
  });

  int? code;
  String? message;
  SingleCommentBody? body;

  factory SingleComment.fromJson(Map<String, dynamic> json) => SingleComment(
    code: json["code"],
    message: json["message"],
    body: SingleCommentBody.fromJson(json["body"]),
  );
}

class SingleCommentBody {
  SingleCommentBody({
    this.id,
    this.user,
    this.targetId,
    this.targetType,
    this.content,
    this.created,
    this.numOfReplies,
    this.numOfLikes,
    this.liked,
    this.classId,
    this.type
  });

  String? id;
  User? user;
  String? targetId;
  String? targetType;
  SingleCommentContent? content;
  String? created;
  int? numOfReplies;
  int? numOfLikes;
  List<FeedLiked>? liked;
  String? classId;
  String? type;

  factory SingleCommentBody.fromJson(Map<String, dynamic> json) => SingleCommentBody(
    id: json["id"],
    user: User.fromJson(json["user"]),
    targetId: json["targetId"],
    targetType: json["targetType"],
    content: SingleCommentContent.fromJson(json["content"]),
    created: json["created"],
    numOfReplies: json["numOfReplies"],
    numOfLikes: json["numOfLikes"],
    liked: json["liked"] == null ? [] : List<FeedLiked>.from(json["liked"].map((x) => FeedLiked.fromJson(x))),
    classId: json["classId"],
    type: json["type"]
  );
}

class SingleCommentContent {
  SingleCommentContent({
    this.charset,
    this.text,
    this.classId,
    this.url
  });

  String? charset;
  String? text;
  String? classId;
  String? url;

  factory SingleCommentContent.fromJson(Map<String, dynamic> json) => SingleCommentContent(
    charset: json["charset"],
    text: json["text"],
    classId: json["classId"],
    url: json["url"],
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

