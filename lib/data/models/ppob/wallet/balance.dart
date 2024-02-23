class BalanceModel {
  BalanceModel({
    this.code,
    this.message,
    this.body,
    this.error,
  });

  int? code;
  String? message;
  BalanceBody? body;
  double? error;

  factory BalanceModel.fromJson(Map<String, dynamic> json) => BalanceModel(
    code: json["code"],
    message: json["message"],
    body: BalanceBody.fromJson(json["body"]),
    error: json["error"],
  );
}

class BalanceBody {
  BalanceBody({
    this.id,
    this.accountId,
    this.balance,
    this.currency,
  });

  String? id;
  String? accountId;
  double? balance;
  String? currency;

  factory BalanceBody.fromJson(Map<String, dynamic> json) => BalanceBody(
    id: json["id"],
    accountId: json["accountId"],
    balance: json["balance"],
    currency: json["currency"],
  );
}
