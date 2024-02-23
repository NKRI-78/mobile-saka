import 'package:saka/data/models/feed/feedmedia.dart';
import 'package:saka/data/models/feed/feednumvalues.dart';
import 'package:saka/data/models/feed/feedtimezone.dart';

class FeedNotification {
  FeedNotification({
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
  List<NotificationBody>? body;

  factory FeedNotification.fromJson(Map<String, dynamic> json) => FeedNotification(
    code: json["code"],
    message: json["message"],
    nextCursor: json["nextCursor"],
    count: json["count"],
    hasNext: json["hasNext"],
    first: json["first"],
    body: List<NotificationBody>.from(json["body"].map((x) => NotificationBody.fromJson(x))),
  );
}

class NotificationBody {
  NotificationBody({
    this.id,
    this.refUser,
    this.userId,
    this.message,
    this.activity,
    this.targetId,
    this.targetType,
    this.image,
    this.classId,
    this.created
  });

  String? id;
  NotificationRefUser? refUser;
  UserId? userId;
  String? message;
  Activity? activity;
  String? targetId;
  TargetType? targetType;
  NotificationImage? image;
  BodyClassId? classId;
  String? created;

  factory NotificationBody.fromJson(Map<String, dynamic> json) => NotificationBody(
    id: json["id"],
    refUser: NotificationRefUser.fromJson(json["refUser"]),
    userId: userIdValues.map[json["userId"]],
    message: json["message"],
    activity: activityValues.map[json["activity"]],
    targetId: json["targetId"],
    targetType: targetTypeValues.map[json["targetType"]],
    image: NotificationImage.fromJson(json["image"]),
    classId: bodyClassIdValues.map[json["classId"]],
    created: json["created"]
  );
}

enum Activity { comment, like, reply }

final activityValues = EnumValues({
  "COMMENT": Activity.comment,
  "LIKE": Activity.like,
  "REPLY": Activity.reply
});

enum BodyClassId { onNotification }

final bodyClassIdValues = EnumValues({
  "onotification": BodyClassId.onNotification
});

class NotificationImage {
  NotificationImage({
    this.originalName,
    this.fileLength,
    this.path,
    this.contentType,
    this.kind,
  });

  OriginalName? originalName;
  int? fileLength;
  Path? path;
  ContentType? contentType;
  Kind? kind;

  factory NotificationImage.fromJson(Map<String, dynamic> json) => NotificationImage(
    originalName: originalNameValues.map[json["originalName"]],
    fileLength: json["fileLength"],
    path: pathValues.map[json["path"]],
    contentType: contentTypeValues.map[json["contentType"]],
    kind: kindValues.map[json["kind"]],
  );
}

enum ContentType { imagePng }

final contentTypeValues = EnumValues({
  "image/png": ContentType.imagePng
});

enum Kind { image }

final kindValues = EnumValues({
  "IMAGE": Kind.image
});

enum OriginalName { profilePic }

final originalNameValues = EnumValues({
  "profile-pic.png": OriginalName.profilePic
});

enum Path { communitySampleProfilePicPng }

final pathValues = EnumValues({
  "/community/sample/profile-pic.png": Path.communitySampleProfilePicPng
});

class NotificationRefUser {
  NotificationRefUser({
    this.id,
    this.timezone,
    this.nickname,
    this.profilePic,
    this.level,
    this.classId,
  });

  UserId? id;
  Timezone? timezone;
  Nickname? nickname;
  FeedMedia? profilePic;
  Level? level;
  RefUserClassId? classId;

  factory NotificationRefUser.fromJson(Map<String, dynamic> json) => NotificationRefUser(
    id: userIdValues.map[json["id"]],
    timezone: timezoneValues.map[json["timezone"]],
    nickname: nicknameValues.map[json["nickname"]],
    profilePic: FeedMedia.fromJson(json["profilePic"]),
    level: levelValues.map[json["level"]],
    classId: refUserClassIdValues.map[json["classId"]],
  );
}

enum RefUserClassId { oUser }

final refUserClassIdValues = EnumValues({
  "ouser": RefUserClassId.oUser
});

enum UserId { user001, user002 }

final userIdValues = EnumValues({
  "user001": UserId.user001,
  "user002": UserId.user002
});

enum Level { topLeader, leader }

final levelValues = EnumValues({
  "LEADER": Level.leader,
  "TOP_LEADER": Level.topLeader
});

enum Nickname { user1, user2 }

final nicknameValues = EnumValues({
  "User 1": Nickname.user1,
  "User 2": Nickname.user2
});

enum TargetType { post, comment, reply }

final targetTypeValues = EnumValues({
  "COMMENT": TargetType.comment,
  "POST": TargetType.post,
  "REPLY": TargetType.reply
});