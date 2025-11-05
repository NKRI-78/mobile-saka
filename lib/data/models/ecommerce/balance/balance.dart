class BalanceModel {
  int status;
  bool error;
  String message;
  BalanceData data;

  BalanceModel({
    required this.status,
    required this.error,
    required this.message,
    required this.data,
  });

  factory BalanceModel.fromJson(Map<String, dynamic> json) => BalanceModel(
    status: json["status"],
    error: json["error"],
    message: json["message"],
    data: BalanceData.fromJson(json["data"]),
  );
}

class BalanceData {
  int balance;

  BalanceData({
    required this.balance,
  });

  factory BalanceData.fromJson(Map<String, dynamic> json) => BalanceData(
    balance: json["balance"],
  );
}