class SubmitDisbursementModel {
  SubmitDisbursementModel({
    this.code,
    this.message,
    this.body,
    this.error,
  });

  int? code;
  String? message;
  SubmitDisbursementBody? body;
  dynamic error;

  factory SubmitDisbursementModel.fromJson(Map<String, dynamic> json) => SubmitDisbursementModel(
    code: json["code"],
    message: json["message"],
    body: SubmitDisbursementBody.fromJson(json["body"]),
    error: json["error"],
  );
}

class SubmitDisbursementBody {
  SubmitDisbursementBody({
    this.amount,
    this.classId,
    this.disburseStatus,
    this.trxid,
  });

  dynamic amount;
  String? classId;
  String? disburseStatus;
  String? trxid;

  factory SubmitDisbursementBody.fromJson(Map<String, dynamic> json) => SubmitDisbursementBody(
    amount: json["amount"] ?? "",
    classId: json["classId"],
    disburseStatus: json["disburseStatus"],
    trxid: json["trxid"],
  );
}
