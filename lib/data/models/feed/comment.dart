import 'package:saka/data/models/feed/feedlike.dart';
import 'package:saka/data/models/feed/feedmedia.dart';

class Comment {
  Comment({
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
  List<CommentBody>? body;

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    code: json["code"],
    message: json["message"],
    nextCursor: json["nextCursor"],
    count: json["count"],
    hasNext: json["hasNext"],
    first: json["first"],
    body: List<CommentBody>.from(json["body"].map((x) => CommentBody.fromJson(x))),
  );
}

class CommentBody {
  CommentBody({
    this.id,
    this.user,
    this.targetId,
    this.targetType,
    this.content,
    this.created,
    this.numOfReplies,
    this.numOfLikes,
    this.classId,
    this.liked,
    this.type
  });

  String? id;
  CommentUser? user;
  String? targetId;
  String? targetType;
  CommentContent? content;
  String? created;
  int? numOfReplies;
  int? numOfLikes;
  String? classId;
  List<FeedLiked>? liked;
  String? type;

  factory CommentBody.fromJson(Map<String, dynamic> json) => CommentBody(
    id: json["id"],
    user: CommentUser.fromJson(json["user"]),
    targetId: json["targetId"],
    targetType: json["targetType"],
    content: CommentContent.fromJson(json["content"]),
    created: json["created"],
    numOfReplies: json["numOfReplies"],
    numOfLikes: json["numOfLikes"],
    classId: json["classId"],
    liked: List<FeedLiked>.from(json["liked"].map((x) => FeedLiked.fromJson(x))),
    type: json["type"]
  );
}

class CommentContent {
  CommentContent({
    this.charset,
    this.text,
    this.url
  });

  String? charset;
  String? text;
  String? url;

  factory CommentContent.fromJson(Map<String, dynamic> json) => CommentContent(
    charset: json["charset"],
    text: json["text"],
    url: json["url"]
  );
}

class CommentUser {
  CommentUser({
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

  factory CommentUser.fromJson(Map<String, dynamic> json) => CommentUser(
    id: json["id"],
    timezone: json["timezone"],
    nickname: json["nickname"],
    profilePic: FeedMedia.fromJson(json["profilePic"]),
    level: json["level"],
    classId: json["classId"],
  );
}