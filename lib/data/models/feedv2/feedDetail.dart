import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FeedDetailModel {
  int status;
  bool error;
  String message;
  FeedDetailData data;

  FeedDetailModel({
    required this.status,
    required this.error,
    required this.message,
    required this.data,
  });

  factory FeedDetailModel.fromJson(Map<String, dynamic> json) => FeedDetailModel(
    status: json["status"],
    error: json["error"],
    message: json["message"],
    data: FeedDetailData.fromJson(json["data"]),
  );
}

class FeedDetailData {
  PageDetail? pageDetail;
  Forum? forum;

  FeedDetailData({
    this.pageDetail,
    this.forum,
  });

  factory FeedDetailData.fromJson(Map<String, dynamic> json) => FeedDetailData(
    pageDetail: PageDetail.fromJson(json["page_detail"]),
    forum: Forum.fromJson(json["forum"]),
  );
}

class Forum {
  String? id;
  List<Media>? media;
  String? link;
  String? caption;
  String? type;
  String? createdAt;
  User? user;
  ForumComment? comment;
  ForumLike? like;

  Forum({
    this.id,
    this.media,
    this.link,
    this.caption,
    this.type,
    this.createdAt,
    this.user,
    this.comment,
    this.like,
  });

  factory Forum.fromJson(Map<String, dynamic> json) => Forum(
    id: json["id"],
    media: List<Media>.from(json["media"].map((x) => Media.fromJson(x))),
    link: json["link"],
    caption: json["caption"],
    type: json["type"],
    createdAt: json["created_at"],
    user: User.fromJson(json["user"]),
    comment: ForumComment.fromJson(json["comment"]),
    like: ForumLike.fromJson(json["like"]),
  );
}

class ForumComment {
  int total;
  List<CommentElement> comments;

  ForumComment({
    required this.total,
    required this.comments,
  });

  factory ForumComment.fromJson(Map<String, dynamic> json) => ForumComment(
    total: json["total"],
    comments: List<CommentElement>.from(json["comments"].map((x) => CommentElement.fromJson(x))),
  );
}

class CommentElement {
  String id;
  String comment;
  String createdAt;
  User user;
  CommentReply reply;
  CommentLike like;
  GlobalKey key;

  CommentElement({
    required this.id,
    required this.comment,
    required this.createdAt,
    required this.user,
    required this.reply,
    required this.like,
    required this.key
  });

  factory CommentElement.fromJson(Map<String, dynamic> json) => CommentElement(
    id: json["id"],
    comment: json["comment"],
    createdAt: json["created_at"],
    user: User.fromJson(json["user"]),
    reply: CommentReply.fromJson(json["reply"]),
    like: CommentLike.fromJson(json["like"]),
    key: GlobalKey()
  );
}

class ForumLike {
  int total;
  List<UserLikes> likes;

  ForumLike({
    required this.total,
    required this.likes,
  });

  factory ForumLike.fromJson(Map<String, dynamic> json) => ForumLike(
    total: json["total"],
    likes: List<UserLikes>.from(json["likes"].map((x) => UserLikes.fromJson(x))),
  );
}

class CommentLike {
  int total;
  List<UserLikes> likes;

  CommentLike({
    required this.total,
    required this.likes,
  });

  factory CommentLike.fromJson(Map<String, dynamic> json) => CommentLike(
    total: json["total"],
    likes: List<UserLikes>.from(json["likes"].map((x) => UserLikes.fromJson(x))),
  );
}

class ReplyLike {
  int total;
  List<UserLikes> likes;

  ReplyLike({
    required this.total,
    required this.likes,
  });

  factory ReplyLike.fromJson(Map<String, dynamic> json) => ReplyLike(
    total: json["total"],
    likes: List<UserLikes>.from(json["likes"].map((x) => UserLikes.fromJson(x))),
  );
}

class UserLikes {
  String? id;
  UserLike? user;

  UserLikes({
    this.id,
    this.user,
  });

  factory UserLikes.fromJson(Map<String, dynamic> json) => UserLikes(
    id: json["id"],
    user: UserLike.fromJson(json["user"]),
  );
}

class User {
  String id;
  String avatar;
  String username;
  String mention;

  User({
    required this.id,
    required this.avatar,
    required this.username,
    required this.mention
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    avatar: json["avatar"],
    username: json["username"],
    mention: json["mention"]
  );
}

class UserLike {
  String id;
  String avatar;
  String username;

  UserLike({
    required this.id,
    required this.avatar,
    required this.username,
  });

  factory UserLike.fromJson(Map<String, dynamic> json) => UserLike(
    id: json["id"],
    avatar: json["avatar"],
    username: json["username"],
  );
}

class UserReply {
  String id;
  String avatar;
  String username;
  String mention;

  UserReply({
    required this.id,
    required this.avatar,
    required this.username,
    required this.mention
  });

  factory UserReply.fromJson(Map<String, dynamic> json) => UserReply(
    id: json["id"],
    avatar: json["avatar"],
    username: json["username"],
    mention: json["mention"]
  );
}

class CommentReply {
  int total;
  List<ReplyElement> replies;

  CommentReply({
    required this.total,
    required this.replies,
  });

  factory CommentReply.fromJson(Map<String, dynamic> json) => CommentReply(
    total: json["total"],
    replies: List<ReplyElement>.from(json["replies"].map((x) => ReplyElement.fromJson(x))),
  );
}

class ReplyElement {
  String id;
  String reply;
  String createdAt;
  UserReply user;
  ReplyLike like;
  GlobalKey key;

  ReplyElement({
    required this.id,
    required this.reply,
    required this.createdAt,
    required this.user,
    required this.like,
    required this.key
  });

  factory ReplyElement.fromJson(Map<String, dynamic> json) => ReplyElement(
    id: json["id"],
    reply: json["reply"],
    createdAt: json["created_at"],
    user: UserReply.fromJson(json["user"]),
    like: ReplyLike.fromJson(json["like"]),
    key: GlobalKey()
  );
}

class Media {
  String path;
  String size;

  Media({
    required this.path,
    required this.size,
  });

  factory Media.fromJson(Map<String, dynamic> json) => Media(
    path: json["path"],
    size: json["size"],
  );
}

class PageDetail {
  bool hasMore;
  int total;
  int perPage;
  int nextPage;
  int prevPage;
  int currentPage;
  String nextUrl;
  String prevUrl;

  PageDetail({
    required this.hasMore,
    required this.total,
    required this.perPage,
    required this.nextPage,
    required this.prevPage,
    required this.currentPage,
    required this.nextUrl,
    required this.prevUrl,
  });

  factory PageDetail.fromJson(Map<String, dynamic> json) => PageDetail(
    hasMore: json["has_more"],
    total: json["total"],
    perPage: json["per_page"],
    nextPage: json["next_page"],
    prevPage: json["prev_page"],
    currentPage: json["current_page"],
    nextUrl: json["next_url"],
    prevUrl: json["prev_url"],
  );
}
