class BankDisbursementModel {
  BankDisbursementModel({
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
  List<BankDisbursementBody>? body;
  dynamic error;

  factory BankDisbursementModel.fromJson(Map<String, dynamic> json) => BankDisbursementModel(
    code: json["code"],
    message: json["message"],
    count: json["count"],
    first: json["first"],
    body: List<BankDisbursementBody>.from(json["body"].map((x) => BankDisbursementBody.fromJson(x))),
    error: json["error"],
  );
}

class BankDisbursementBody {
  BankDisbursementBody({
    this.code,
    this.name,
  });

  dynamic code;
  String? name;

  factory BankDisbursementBody.fromJson(Map<String, dynamic> json) => BankDisbursementBody(
    code: json["code"],
    name: json["name"],
  );
}
