class InquiryRegisterModel {
  InquiryRegisterModel({
    this.code,
    this.message,
    this.body,
    this.error,
  });

  int? code;
  String? message;
  InquiryRegisterData? body;
  dynamic error;

  factory InquiryRegisterModel.fromJson(Map<String, dynamic> json) => InquiryRegisterModel(
    code: json["code"],
    message: json["message"],
    body: InquiryRegisterData.fromJson(json["body"]),
    error: json["error"],
  );

}

class InquiryRegisterData {
  InquiryRegisterData({
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
  InquiryRegisterUserData? data;
  String? classId;

  factory InquiryRegisterData.fromJson(Map<String, dynamic> json) => InquiryRegisterData(
    inquiryStatus: json["inquiryStatus"],
    productPrice: json["productPrice"],
    productId: json["productId"],
    productCode: json["productCode"],
    productName: json["productName"],
    accountNumber1: json["accountNumber1"],
    accountNumber2: json["accountNumber2"],
    transactionId: json["transactionId"],
    transactionRef: json["transactionRef"],
    data: InquiryRegisterUserData.fromJson(json["data"]),
    classId: json["classId"],
  );
}

class InquiryRegisterUserData {
  InquiryRegisterUserData({
    this.billAmount,
    this.bankFee,
    this.phoneNumber,
    this.accountName,
    this.admin,
  });

  dynamic billAmount;
  dynamic bankFee;
  String? phoneNumber;
  String? accountName;
  dynamic admin;

  factory InquiryRegisterUserData.fromJson(Map<String, dynamic> json) => InquiryRegisterUserData(
    billAmount: json["billAmount"],
    bankFee: json["bankFee"],
    phoneNumber: json["phoneNumber"],
    accountName: json["accountName"],
    admin: json["admin"],
  );
}

class PayInquiryRegisterModel {
  PayInquiryRegisterModel({
    this.code,
    this.message,
    this.body,
    this.error,
  });

  int? code;
  String? message;
  PayInquiryRegisterData? body;
  dynamic error;

  factory PayInquiryRegisterModel.fromJson(Map<String, dynamic> json) => PayInquiryRegisterModel(
    code: json["code"],
    message: json["message"],
    body: PayInquiryRegisterData.fromJson(json["body"]),
    error: json["error"],
  );
}

class PayInquiryRegisterData {
  PayInquiryRegisterData({
    this.purchaseStatus,
    this.paymentStatus,
    this.productPrice,
    this.productId,
    this.productCode,
    this.accountNumber1,
    this.accountNumber2,
    this.description,
    this.transactionId,
    this.transactionRef,
    this.paymentRef,
    this.data,
    this.classId,
  });

  String? purchaseStatus;
  String? paymentStatus;
  dynamic productPrice;
  String? productId;
  String? productCode;
  String? accountNumber1;
  String? accountNumber2;
  String? description;
  String? transactionId;
  String? transactionRef;
  String? paymentRef;
  PayInquiryRegisterUserData? data;
  String? classId;

  factory PayInquiryRegisterData.fromJson(Map<String, dynamic> json) => PayInquiryRegisterData(
    purchaseStatus: json["purchaseStatus"],
    paymentStatus: json["paymentStatus"],
    productPrice: json["productPrice"],
    productId: json["productId"],
    productCode: json["productCode"],
    accountNumber1: json["accountNumber1"],
    accountNumber2: json["accountNumber2"],
    description: json["description"],
    transactionId: json["transactionId"],
    transactionRef: json["transactionRef"],
    paymentRef: json["paymentRef"],
    data: PayInquiryRegisterUserData.fromJson(json["data"]),
    classId: json["classId"],
  );

}

class PayInquiryRegisterUserData {
  PayInquiryRegisterUserData({
    this.paymentGuide,
    this.paymentChannel,
    this.paymentRefId,
    this.paymentAdminFee,
    this.paymentCode,
  });

  String? paymentGuide;
  String? paymentChannel;
  String? paymentRefId;
  dynamic paymentAdminFee;
  String? paymentCode;

  factory PayInquiryRegisterUserData.fromJson(Map<String, dynamic> json) => PayInquiryRegisterUserData(
    paymentGuide: json["payment_guide"],
    paymentChannel: json["payment_channel"],
    paymentRefId: json["payment_ref_id"],
    paymentAdminFee: json["payment_admin_fee"],
    paymentCode: json["payment_code"],
  );
}
