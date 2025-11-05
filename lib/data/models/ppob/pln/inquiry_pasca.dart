class InquiryPLNPascabayarModel {
  InquiryPLNPascabayarModel({
    this.code,
    this.message,
    this.body,
    this.error,
  });

  int? code;
  String? message;
  InquiryPLNPascaBayarData? body;
  dynamic error;

  factory InquiryPLNPascabayarModel.fromJson(Map<String, dynamic> json) => InquiryPLNPascabayarModel(
    code: json["code"],
    message: json["message"],
    body: InquiryPLNPascaBayarData.fromJson(json["body"]),
    error: json["error"],
  );
}

class InquiryPLNPascaBayarData {
  InquiryPLNPascaBayarData({
    this.inquiryStatus,
    this.productPrice,
    this.productId,
    this.productCode,
    this.productName,
    this.accountNumber1,
    this.accountNumber2,
    this.transactionId,
    this.transactionRef,
    this.data,
    this.classId,
  });

  String? inquiryStatus;
  dynamic productPrice;
  String? productId;
  String? productCode;
  String? productName;
  String? accountNumber1;
  String? accountNumber2;
  String? transactionId;
  String? transactionRef;
  InquiryPLNPascaBayarUserData? data;
  String? classId;

  factory InquiryPLNPascaBayarData.fromJson(Map<String, dynamic> json) => InquiryPLNPascaBayarData(
    inquiryStatus: json["inquiryStatus"],
    productPrice: json["productPrice"] ?? "",
    productId: json["productId"],
    productCode: json["productCode"],
    productName: json["productName"],
    accountNumber1: json["accountNumber1"],
    accountNumber2: json["accountNumber2"],
    transactionId: json["transactionId"],
    transactionRef: json["transactionRef"],
    data: InquiryPLNPascaBayarUserData.fromJson(json["data"]),
    classId: json["classId"],
  );
}

class InquiryPLNPascaBayarUserData {
  InquiryPLNPascaBayarUserData({
    this.amount,
    this.accountName,
    this.admin,
  });

  dynamic amount;
  String? accountName;
  dynamic admin;

  factory InquiryPLNPascaBayarUserData.fromJson(Map<String, dynamic> json) => InquiryPLNPascaBayarUserData(
    amount: json["amount"] ?? "",
    accountName: json["accountName"],
    admin: json["admin"] ?? "",
  );
}
