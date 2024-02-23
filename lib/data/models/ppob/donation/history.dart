class BalanceHistoryDonationModel {
  BalanceHistoryDonationModel({
    this.code,
    this.message,
    this.count,
    this.first,
    this.body,
    this.error,
  });

  int? code;
  String? message;
  int? count;
  bool? first;
  List<BalanceHistoryDonationData>? body;
  dynamic error;

  factory BalanceHistoryDonationModel.fromJson(Map<String, dynamic> json) => BalanceHistoryDonationModel(
    code: json["code"],
    message: json["message"],
    count: json["count"],
    first: json["first"],
    body: List<BalanceHistoryDonationData>.from(json["body"].map((x) => BalanceHistoryDonationData.fromJson(x))),
    error: json["error"],
  );
}

class BalanceHistoryDonationData {
  BalanceHistoryDonationData({
    this.id,
    this.userId,
    this.phoneNumber,
    this.name,
    this.amount,
    this.transactionId,
    this.classId,
  });

  int? id;
  String? userId;
  String? phoneNumber;
  String? name;
  dynamic amount;
  String? transactionId;
  String? classId;

  factory BalanceHistoryDonationData.fromJson(Map<String, dynamic> json) => BalanceHistoryDonationData(
    id: json["id"],
    userId:  json["userId"],
    phoneNumber: json["phoneNumber"],
    name:  json["name"],
    amount: json["amount"],
    transactionId: json["transactionId"],
    classId: json["classId"],
  );
}
