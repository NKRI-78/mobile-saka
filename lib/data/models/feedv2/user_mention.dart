class UserMentionModel {
  int status;
  bool error;
  String message;
  List<UserMention> data;

  UserMentionModel({
    required this.status,
    required this.error,
    required this.message,
    required this.data,
  });

  factory UserMentionModel.fromJson(Map<String, dynamic> json) => UserMentionModel(
    status: json["status"],
    error: json["error"],
    message: json["message"],
    data: List<UserMention>.from(json["data"].map((x) => UserMention.fromJson(x))),
  );
}

class UserMention {
  String id;
  String? photo;
  String username;
  String display;

  UserMention({
    required this.id,
    required this.photo,
    required this.username,
    required this.display,
  });

  factory UserMention.fromJson(Map<String, dynamic> json) => UserMention(
    id: json["id"],
    photo: json["photo"],
    username: json["username"],
    display: json["display"],
  );
}