class InboxCountModel {
  InboxCountModel({
    this.data,
    this.code,
    this.message,
  });

  InboxCountData? data;
  int? code;
  String? message;

  factory InboxCountModel.fromJson(Map<String, dynamic> json) => InboxCountModel(
    data: InboxCountData.fromJson(json["body"]),
    code: json["code"],
    message: json["message"],
  );
}

class InboxCountData {
  InboxCountData({
    required this.count,
  });

  int count;

  factory InboxCountData.fromJson(Map<String, dynamic> json) => InboxCountData(
    count: json["count"],
  );
}
