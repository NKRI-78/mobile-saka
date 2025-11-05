class HistoryBalanceModel {
  HistoryBalanceModel({
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
  List<HistoryBalanceData>? body;
  dynamic error;

  factory HistoryBalanceModel.fromJson(Map<String, dynamic> json) => HistoryBalanceModel(
    code: json["code"],
    message: json["message"],
    count: json["count"],
    first: json["first"],
    body: List<HistoryBalanceData>.from(json["body"].map((x) => HistoryBalanceData.fromJson(x))),
    error: json["error"],
  );
}

class HistoryBalanceData {
  HistoryBalanceData({
    this.id,
    this.created,
    this.refId,
    this.type,
    this.preBalance,
    this.postBalance,
    this.amount,
    this.currency,
    this.description,
    this.appId,
    this.merchant,
  });

  String? id;
  String? created;
  String? refId;
  String? type;
  dynamic preBalance;
  dynamic postBalance;
  dynamic amount;
  String? currency;
  String? description;
  String? appId;
  String? merchant;

  factory HistoryBalanceData.fromJson(Map<String, dynamic> json) => HistoryBalanceData(
    id: json["id"],
    created: json["created"],
    refId: json["refId"],
    type: json["type"],
    preBalance: json["preBalance"] ?? "",
    postBalance: json["postBalance"] ?? "",
    amount: json["amount"] ?? "",
    currency: json["currency"],
    description: json["description"],
    appId: json["appId"],
    merchant: json["merchant"],
  );
}