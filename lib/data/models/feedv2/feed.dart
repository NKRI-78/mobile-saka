class FeedModel {
  int? status;
  bool? error;
  String? message;
  FeedData? data;

  FeedModel({
    this.status,
    this.error,
    this.message,
    this.data,
  });

  factory FeedModel.fromJson(Map<String, dynamic> json) => FeedModel(
    status: json["status"],
    error: json["error"],
    message: json["message"],
    data: FeedData.fromJson(json["data"]),
  );
}

class FeedData {
  PageDetail? pageDetail;
  List<Forum>? forums;

  FeedData({
    this.pageDetail,
    this.forums,
  });

  factory FeedData.fromJson(Map<String, dynamic> json) => FeedData(
    pageDetail: PageDetail.fromJson(json["page_detail"]),
    forums: List<Forum>.from(json["forums"].map((x) => Forum.fromJson(x))),
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
  ForumLikes? like;

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
    like: ForumLikes.fromJson(json["like"]),
  );
}

class ForumComment {
  int? total;
  List<CommentElement>? comments;

  ForumComment({
    this.total,
    this.comments,
  });

  factory ForumComment.fromJson(Map<String, dynamic> json) => ForumComment(
    total: json["total"],
    comments: List<CommentElement>.from(json["comments"].map((x) => CommentElement.fromJson(x))),
  );
}

class CommentElement {
  String? id;
  String? comment;
  String? createdAt;
  User? user;
  CommentReply? reply;
  ForumLikes? like;

  CommentElement({
    this.id,
    this.comment,
    this.createdAt,
    this.user,
    this.reply,
    this.like,
  });

  factory CommentElement.fromJson(Map<String, dynamic> json) => CommentElement(
    id: json["id"],
    comment: json["comment"],
    createdAt: json["created_at"],
    user: User.fromJson(json["user"]),
    reply: CommentReply.fromJson(json["reply"]),
    like: ForumLikes.fromJson(json["like"]),
  );
}

class ForumLikes {
  int total;
  List<UserLikes> likes;

  ForumLikes({
    required this.total,
    required this.likes,
  });

  factory ForumLikes.fromJson(Map<String, dynamic> json) => ForumLikes(
    total: json["total"],
    likes: List<UserLikes>.from(json["likes"].map((x) => UserLikes.fromJson(x))),
  );
}

class UserLikes {
  String? id;
  User? user;

  UserLikes({
    this.id,
    this.user,
  });

  factory UserLikes.fromJson(Map<String, dynamic> json) => UserLikes(
    id: json["id"],
    user: User.fromJson(json["user"]),
  );
}

class User {
  String? id;
  String? avatar;
  String? username;

  User({
    this.id,
    this.avatar,
    this.username,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    avatar: json["avatar"],
    username: json["username"],
  );
}

class CommentReply {
  int? total;
  List<ReplyElement>? replies;

  CommentReply({
    this.total,
    this.replies,
  });

  factory CommentReply.fromJson(Map<String, dynamic> json) => CommentReply(
    total: json["total"],
    replies: List<ReplyElement>.from(json["replies"].map((x) => ReplyElement.fromJson(x))),
  );
}

class ReplyElement {
  String? id;
  String? reply;
  User? user;
  ForumLikes? like;
  
  ReplyElement({
    this.id,
    this.reply,
    this.user,
    this.like
  });

  factory ReplyElement.fromJson(Map<String, dynamic> json) => ReplyElement(
    id: json["id"],
    reply: json["reply"],
    user: User.fromJson(json["user"]),
    like: ForumLikes.fromJson(json["like"]),
  );
}

class Media {
  String? path;
  String? size;

  Media({
    this.path,
    this.size,
  });

  factory Media.fromJson(Map<String, dynamic> json) => Media(
    path: json["path"],
    size: json["size"],
  );
}

class PageDetail {
  bool? hasMore;
  int? total;
  int? perPage;
  int? nextPage;
  int? prevPage;
  int? currentPage;
  String? nextUrl;
  String? prevUrl;

  PageDetail({
    this.hasMore,
    this.total,
    this.perPage,
    this.nextPage,
    this.prevPage,
    this.currentPage,
    this.nextUrl,
    this.prevUrl,
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