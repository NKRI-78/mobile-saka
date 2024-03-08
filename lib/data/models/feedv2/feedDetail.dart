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
    FeedLikes? like;

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
        like: FeedLikes.fromJson(json["like"]),
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
    FeedLikes like;

    CommentElement({
        required this.id,
        required this.comment,
        required this.createdAt,
        required this.user,
        required this.reply,
        required this.like,
    });

    factory CommentElement.fromJson(Map<String, dynamic> json) => CommentElement(
        id: json["id"],
        comment: json["comment"],
        createdAt: json["created_at"],
        user: User.fromJson(json["user"]),
        reply: CommentReply.fromJson(json["reply"]),
        like: FeedLikes.fromJson(json["like"]),
    );
}

class FeedLikes {
    int total;
    List<UserLikes> likes;

    FeedLikes({
        required this.total,
        required this.likes,
    });

    factory FeedLikes.fromJson(Map<String, dynamic> json) => FeedLikes(
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
    String id;
    String avatar;
    String username;

    User({
        required this.id,
        required this.avatar,
        required this.username,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        avatar: json["avatar"],
        username: json["username"],
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
    User user;

    ReplyElement({
        required this.id,
        required this.reply,
        required this.user,
    });

    factory ReplyElement.fromJson(Map<String, dynamic> json) => ReplyElement(
        id: json["id"],
        reply: json["reply"],
        user: User.fromJson(json["user"]),
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
