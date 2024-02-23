class InquiryTopUpModel {
  InquiryTopUpModel({
    this.code,
    this.message,
    this.body,
    this.error,
  });

  int? code;
  String? message;
  InquiryTopUpData? body;
  dynamic error;

  factory InquiryTopUpModel.fromJson(Map<String, dynamic> json) => InquiryTopUpModel(
    code: json["code"],
    message: json["message"],
    body: InquiryTopUpData.fromJson(json["body"]),
    error: json["error"],
  );
}

class InquiryTopUpData {
  InquiryTopUpData({
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
  dynamic transactionRef;
  InquiryTopUpUserData? data;
  String? classId;

  factory InquiryTopUpData.fromJson(Map<String, dynamic> json) => InquiryTopUpData(
    inquiryStatus: json["inquiryStatus"],
    productPrice: json["productPrice"] ?? "",
    productId:  json["productId"],
    productCode: json["productCode"],
    productName: json["productName"],
    accountNumber1: json["accountNumber1"],
    accountNumber2: json["accountNumber2"],
    transactionId: json["transactionId"],
    transactionRef: json["transactionRef"],
    data: InquiryTopUpUserData.fromJson(json["data"]),
    classId: json["classId"],
  );
}

class InquiryTopUpUserData {
  InquiryTopUpUserData({
    this.balance,
    this.topupAmount,
    this.accountName,
    this.admin,
  });

  dynamic balance;
  dynamic topupAmount;
  String? accountName;
  dynamic admin;

  factory InquiryTopUpUserData.fromJson(Map<String, dynamic> json) => InquiryTopUpUserData(
    balance:  json["balance"] ?? "",
    topupAmount: json["topupAmount"] ?? "",
    accountName: json["accountName"],
    admin: json["admin"] ?? "",
  );
}
