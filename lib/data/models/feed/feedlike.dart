class FeedLiked {
  FeedLiked({
    this.targetId,
    this.targetType,
    this.type,
  });

  String? targetId;
  String? targetType;
  String? type;

  factory FeedLiked.fromJson(Map<String, dynamic> json) => FeedLiked(
    targetId: json["targetId"],
    targetType: json["targetType"],
    type: json["type"],
  );
    
}