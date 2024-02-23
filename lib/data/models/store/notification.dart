class NotificationModel {
  NotificationModel({
    this.data,
    this.code,
    this.message,
  });

  List<NotificationData>? data;
  int? code;
  String? message;

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
    data: List<NotificationData>.from(json["body"].map((x) => NotificationData.fromJson(x))),
    code: json["code"],
    message: json["message"],
  );

}

class NotificationData {
  NotificationData({
    this.inboxId,
    this.recepientId,
    this.senderId,
    this.subject,
    this.body,
    this.information,
    this.type,
    this.status,
    this.read,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  String? inboxId;
  String? recepientId;
  String? senderId;
  String? subject;
  String? body;
  String? information;
  String? type;
  String? status;
  bool? read;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;

  factory NotificationData.fromJson(Map<String, dynamic> json) => NotificationData(
    inboxId: json["inboxId"],
    recepientId: json["recepientId"],
    senderId: json["senderId"],
    subject: json["subject"],
    body: json["body"],
    information: json["information"],
    type: json["type"],
    status: json["status"],
    read: json["read"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    deletedAt: json["deletedAt"],
  );
}


class EnumValues<T> {
  Map<String, T>? map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap ??= map!.map((k, v) => MapEntry(v, k));
    return reverseMap!;
  }
}
