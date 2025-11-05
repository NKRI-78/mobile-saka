import 'package:saka/data/models/feed/feedcharset.dart';
import 'package:saka/data/models/feed/feedlevel.dart';
import 'package:saka/data/models/feed/feedlike.dart';
import 'package:saka/data/models/feed/feedmedia.dart';
import 'package:saka/data/models/feed/feedposttype.dart';
import 'package:saka/data/models/feed/feedtimezone.dart';
import 'package:saka/data/models/feed/feedvisibletype.dart';

class GroupsModel {
  GroupsModel({
    this.code,
    this.message,
    this.nextCursor,
    this.body,
    this.count,
    this.first,
    this.hasNext,
  });

  int? code;
  String? message;
  String? nextCursor;
  int? count;
  bool? first;
  bool? hasNext;
  List<GroupsBody>? body;

  factory GroupsModel.fromJson(Map<String, dynamic> json) => GroupsModel(
    code: json["code"],
    message: json["message"],
    nextCursor: json["nextCursor"],
    count: json["count"],
    first: json["first"],
    hasNext: json["hasNext"],
    body: json["body"] == null ? [] : List<GroupsBody>.from(json["body"].map((x) => GroupsBody.fromJson(x))),
  );
}

class GroupsBody {
  GroupsBody({
    this.id,
    this.user,
    this.postType,
    this.content,
    this.numOfComments,
    this.numOfLikes,
    this.classId,
    this.visibilityType,
    this.created,
    this.updated,
    this.liked,
    this.commented,
  });

  String? id;
  GroupsUser? user;  
  PostType? postType;
  GroupsContent? content;
  int? numOfComments;
  int? numOfLikes;
  String? classId;
  VisibilityType? visibilityType;
  String? created;
  String? updated;
  List<FeedLiked>? liked;
  List<Commented>? commented;

  factory GroupsBody.fromJson(Map<String, dynamic> json) => GroupsBody(
    id: json["id"],
    user: GroupsUser.fromJson(json["user"]),
    postType: postTypeValues.map[json["postType"]],
    content: GroupsContent.fromJson(json["content"]),
    numOfComments: json["numOfComments"],
    numOfLikes: json["numOfLikes"],
    classId: json["classId"],
    visibilityType: visibilityTypeValues.map[json["visibilityType"]],
    created: json["created"],
    updated: json["updated"],
    liked: json["liked"] == null ? [] : List<FeedLiked>.from(json["liked"].map((x) => FeedLiked.fromJson(x))),
    commented: json["commented"] == null ? [] : List<Commented>.from(json["commented"].map((x) => Commented.fromJson(x))),
  );
}

class Commented {
  Commented({
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
  CommentedContent? content;
  String? created;
  int? numOfReplies;
  int? numOfLikes;

  factory Commented.fromJson(Map<String, dynamic> json) => Commented(
    userId: json["userId"],
    targetId: json["targetId"],
    targetType: json["targetType"],
    content: CommentedContent.fromJson(json["content"]),
    created: json["created"],
    numOfReplies: json["numOfReplies"],
    numOfLikes: json["numOfLikes"],
  );
}

class CommentedContent {
  CommentedContent({
    this.charset,
    this.text,
  });

  Charset? charset;
  String? text;

  factory CommentedContent.fromJson(Map<String, dynamic> json) => CommentedContent(
    charset: charsetValues.map[json["charset"]],
    text: json["text"],
  );
}

class GroupsContent {
  GroupsContent({
    this.text,
    this.url,
    this.charset,
    this.caption,
    this.medias,
  });

  String? text;
  String? url;
  Charset? charset;
  String? caption;
  List<FeedMedia>? medias;

  factory GroupsContent.fromJson(Map<String, dynamic> json) => GroupsContent(
    text: json["text"],
    url: json["url"],
    charset: charsetValues.map[json["charset"]],
    caption: json["caption"],
    medias: json["medias"] == null ? [] : List<FeedMedia>.from(json["medias"].map((x) => FeedMedia.fromJson(x))),
  );
}

class GroupsUser {
  GroupsUser({
    this.userId,
    this.timezone,
    this.nickname,
    this.profilePic,
    this.level
  });

  String? userId;
  Timezone? timezone;
  String? nickname;
  FeedMedia? profilePic;
  Level? level;

  factory GroupsUser.fromJson(Map<String, dynamic> json) => GroupsUser(
    userId: json["id"],
    timezone: timezoneValues.map[json["timezone"]],
    nickname: json["nickname"],
    profilePic: FeedMedia.fromJson(json["profilePic"]),
    level: levelValues.map[json["level"]],
  );
}