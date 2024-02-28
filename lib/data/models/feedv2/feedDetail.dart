class FeedDetailModel {
    int status;
    bool error;
    String message;
    Data data;

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
        data: Data.fromJson(json["data"]),
    );
}

class Data {
    PageDetail pageDetail;
    ForumDetailData forum;

    Data({
        required this.pageDetail,
        required this.forum,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        pageDetail: PageDetail.fromJson(json["page_detail"]),
        forum: ForumDetailData.fromJson(json["forum"]),
    );
}

class ForumDetailData {
    String? id;
    List<Media>? media;
    String? caption;
    String? type;
    String? createdAt;
    User? user;
    ForumComment? comment;
    CommentLike? like;

    ForumDetailData({
        this.id,
        this.media,
        this.caption,
        this.type,
        this.createdAt,
        this.user,
        this.comment,
        this.like,
    });

    factory ForumDetailData.fromJson(Map<String, dynamic> json) => ForumDetailData(
        id: json["id"],
        media: List<Media>.from(json["media"].map((x) => Media.fromJson(x))),
        caption: json["caption"],
        type: json["type"],
        createdAt: json["created_at"],
        user: User.fromJson(json["user"]),
        comment: ForumComment.fromJson(json["comment"]),
        like: CommentLike.fromJson(json["like"]),
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
    User user;
    CommentReply reply;
    CommentLike like;

    CommentElement({
        required this.id,
        required this.comment,
        required this.user,
        required this.reply,
        required this.like,
    });

    factory CommentElement.fromJson(Map<String, dynamic> json) => CommentElement(
        id: json["id"],
        comment: json["comment"],
        user: User.fromJson(json["user"]),
        reply: CommentReply.fromJson(json["reply"]),
        like: CommentLike.fromJson(json["like"]),
    );
}

class CommentLike {
    int total;
    List<LikeElement> likes;

    CommentLike({
        required this.total,
        required this.likes,
    });

    factory CommentLike.fromJson(Map<String, dynamic> json) => CommentLike(
        total: json["total"],
        likes: List<LikeElement>.from(json["likes"].map((x) => LikeElement.fromJson(x))),
    );
}

class LikeElement {
    String id;
    User user;

    LikeElement({
        required this.id,
        required this.user,
    });

    factory LikeElement.fromJson(Map<String, dynamic> json) => LikeElement(
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
