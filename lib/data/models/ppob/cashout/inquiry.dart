class InquiryDisbursementModel {
  InquiryDisbursementModel({
    this.code,
    this.message,
    this.body,
    this.error,
  });

  int? code;
  String? message;
  InquiryDisbursementBody? body;
  dynamic error;

  factory InquiryDisbursementModel.fromJson(Map<String, dynamic> json) => InquiryDisbursementModel(
    code: json["code"],
    message: json["message"],
    body: InquiryDisbursementBody.fromJson(json["body"]),
    error: json["error"],
  );
}

class InquiryDisbursementBody {
  InquiryDisbursementBody({
    this.amount,
    this.balance,
    this.classId,
    this.token,
    this.totalAdminFee,
  });

  dynamic amount;
  dynamic balance;
  String? classId;
  String? token;
  dynamic totalAdminFee;

  factory InquiryDisbursementBody.fromJson(Map<String, dynamic> json) => InquiryDisbursementBody(
    amount: json["amount"] ?? "",
    balance: json["balance"] ?? "",
    classId: json["classId"],
    token: json["token"],
    totalAdminFee: json["totalAdminFee"] ?? "",
  );
}
