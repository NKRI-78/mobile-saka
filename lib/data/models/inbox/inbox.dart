class InboxModel {
  InboxModel({
    this.data,
    this.code,
    this.message,
  });

  List<InboxData>? data;
  int? code;
  String? message;

  factory InboxModel.fromJson(Map<String, dynamic> json) => InboxModel(
    data: List<InboxData>.from(json["body"].map((x) => InboxData.fromJson(x))),
    code: json["code"],
    message: json["message"],
  );
}

class InboxData {
  InboxData({
    this.inboxId,
    this.recepientId,
    this.senderId,
    this.subject,
    this.body,
    this.type,
    this.field1,
    this.field2,
    this.field3,
    this.field4,
    this.field5,
    this.field6,
    this.field7,
    this.read,
    this.created,
    this.updated,
  });

  String? inboxId;
  String? recepientId;
  String? senderId;
  String? subject;
  String? body;
  String? type;
  String? field1;
  String? field2;
  String? field3;
  String? field4;
  String? field5;
  String? field6;
  String? field7;
  bool? read;
  DateTime? created;
  DateTime? updated;

  factory InboxData.fromJson(Map<String, dynamic> json) => InboxData(
    inboxId: json["inboxId"],
    recepientId: json["recepientId"],
    senderId: json["senderId"],
    subject: json["subject"],
    body: json["body"],
    type: json["type"],
    field1: json["field1"],
    field2: json["field2"],
    field3: json["field3"],
    field4: json["field4"],
    field5: json["field5"],
    field6: json["field6"],
    field7: json["field7"],
    read: json["read"],
    created: DateTime.parse(json["created"]),
    updated: DateTime.parse(json["updated"]),
  );
}
