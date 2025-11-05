import 'package:saka/data/models/feed/feedcharset.dart';
import 'package:saka/data/models/feed/feedlevel.dart';
import 'package:saka/data/models/feed/feedlike.dart';
import 'package:saka/data/models/feed/feedmedia.dart';
import 'package:saka/data/models/feed/feedposttype.dart';
import 'package:saka/data/models/feed/feedtimezone.dart';

class PostModel {
  PostModel({
    this.code,
    this.message,
    this.body,
  });

  int? code;
  String? message;
  PostBody? body;

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
    code: json["code"],
    message: json["message"],
    body: PostBody.fromJson(json["body"]),
  );
}

class PostBody {
  PostBody({
    this.id,
    this.user,
    this.postType,
    this.content,
    this.numOfComments,
    this.numOfLikes,
    this.respondDate,
    this.visibilityType,
    this.created,
    this.liked,
    this.commented,
    this.classId,
  });

  String? id;
  PostUser? user;
  PostType? postType;
  PostContent? content;
  int? numOfComments;
  int? numOfLikes;
  String? respondDate;
  String? visibilityType;
  String? created;
  List<FeedLiked>? liked;
  List<PostCommented>? commented;
  String? classId;

  factory PostBody.fromJson(Map<String, dynamic> json) => PostBody(
    id: json["id"],
    user: PostUser.fromJson(json["user"]),
    postType: postTypeValues.map[json["postType"]],
    content: PostContent.fromJson(json["content"]),
    numOfComments: json["numOfComments"],
    numOfLikes: json["numOfLikes"],
    respondDate: json["respondDate"],
    visibilityType: json["visibilityType"],
    created: json["created"],
    liked: json["liked"] == null ? [] : List<FeedLiked>.from(json["liked"].map((x) => FeedLiked.fromJson(x))),
    commented: json["liked"] == null ? [] : List<PostCommented>.from(json["commented"].map((x) => PostCommented.fromJson(x))),
    classId: json["classId"],
  );
}

class PostContent {
  PostContent({
    this.text,
    this.url,
    this.charset,
    this.caption,
    this.medias,
  });

  Charset? charset;
  String? text;
  String? url;
  String? caption;
  List<FeedMedia>? medias;

  factory PostContent.fromJson(Map<String, dynamic> json) => PostContent(
    text: json["text"],
    url:  json["url"],
    charset: charsetValues.map[json["charset"]],
    caption: json["caption"],
    medias: json["medias"] == null ? [] : List<FeedMedia>.from(json["medias"].map((x) => FeedMedia.fromJson(x))),
  );
}
 
class PostCommented {
  PostCommented({
    this.userId,
    this.targetId,
    this.targetType,
    this.content,
    this.created,
    this.numOfReplies,
    this.numOfLikes,
  });

  String? userId;
  String? targetId;
  String? targetType;
  PostCommentedContent? content;
  String? created;
  int? numOfReplies;
  int? numOfLikes;

  factory PostCommented.fromJson(Map<String, dynamic> json) => PostCommented(
    userId: json["userId"],
    targetId: json["targetId"],
    targetType: json["targetType"],
    content: PostCommentedContent.fromJson(json["content"]),
    created: json["created"],
    numOfReplies: json["numOfReplies"],
    numOfLikes: json["numOfLikes"],
  );
}

class PostCommentedContent {
  PostCommentedContent({
    this.charset,
    this.text,
  });

  Charset? charset;
  String? text;

  factory PostCommentedContent.fromJson(Map<String, dynamic> json) => PostCommentedContent(
    charset: charsetValues.map[json["charset"]],
    text: json["text"],
  );
}

class PostUser {
  PostUser({
    this.id,
    this.timezone,
    this.nickname,
    this.profilePic,
    this.level,
    this.classId,
  });

  String? id;
  Timezone? timezone;
  String? nickname;
  FeedMedia? profilePic;
  Level? level;
  String? classId;

  factory PostUser.fromJson(Map<String, dynamic> json) => PostUser(
    id: json["id"],
    timezone: timezoneValues.map[json["timezone"]],
    nickname: json["nickname"],
    profilePic: FeedMedia.fromJson(json["profilePic"]),
    level: levelValues.map[json["level"]],
    classId: json["classId"],
  );
}





