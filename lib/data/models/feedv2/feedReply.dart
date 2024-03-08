class FeedReplyModel {
    int status;
    bool error;
    String message;
    FeedReplyData data;

    FeedReplyModel({
        required this.status,
        required this.error,
        required this.message,
        required this.data,
    });

    factory FeedReplyModel.fromJson(Map<String, dynamic> json) => FeedReplyModel(
        status: json["status"],
        error: json["error"],
        message: json["message"],
        data: FeedReplyData.fromJson(json["data"]),
    );
}

class FeedReplyData {
    PageDetail? pageDetail;
    Comment? comment;

    FeedReplyData({
        this.pageDetail,
        this.comment,
    });

    factory FeedReplyData.fromJson(Map<String, dynamic> json) => FeedReplyData(
        pageDetail: PageDetail.fromJson(json["page_detail"]),
        comment: Comment.fromJson(json["comment"]),
    );
}

class Comment {
    String? id;
    String? caption;
    String? createdAt;
    User? user;
    CommentReply? reply;

    Comment({
        this.id,
        this.caption,
        this.createdAt,
        this.user,
        this.reply,
    });

    factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json["id"],
        caption: json["caption"],
        createdAt: json["created_at"],
        user: User.fromJson(json["user"]),
        reply: CommentReply.fromJson(json["reply"]),
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
    User user;

    ReplyElement({
        required this.id,
        required this.reply,
        required this.createdAt,
        required this.user,
    });

    factory ReplyElement.fromJson(Map<String, dynamic> json) => ReplyElement(
        id: json["id"],
        reply: json["reply"],
        createdAt: json["created_at"],
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