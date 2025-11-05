class PayTopUpModel {
  PayTopUpModel({
    this.code,
    this.message,
    this.body,
    this.error,
  });

  int? code;
  String? message;
  PayTopUpData? body;
  dynamic error;

  factory PayTopUpModel.fromJson(Map<String, dynamic> json) => PayTopUpModel(
    code: json["code"],
    message: json["message"],
    body: PayTopUpData.fromJson(json["body"]),
    error: json["error"],
  );
}

class PayTopUpData {
  PayTopUpData({
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
  dynamic transactionRef;
  String? paymentRef;
  PayTopUpDataBank? data;
  String? classId;

  factory PayTopUpData.fromJson(Map<String, dynamic> json) => PayTopUpData(
    purchaseStatus: json["purchaseStatus"],
    paymentStatus: json["paymentStatus"],
    productPrice: json["productPrice"] ?? "",
    productId: json["productId"],
    productCode: json["productCode"],
    accountNumber1: json["accountNumber1"],
    accountNumber2: json["accountNumber2"],
    description: json["description"],
    transactionId: json["transactionId"],
    transactionRef: json["transactionRef"],
    paymentRef: json["paymentRef"],
    data: PayTopUpDataBank.fromJson(json["data"]),
    classId: json["classId"],
  );
}

class PayTopUpDataBank {
  PayTopUpDataBank({
    this.paymentGuide,
    this.paymentGuide2Url,
    this.paymentChannel,
    this.paymentRefId,
    this.paymentGuideUrl,
    this.paymentAdminFee,
    this.paymentCode,
  });

  String? paymentGuide;
  String? paymentGuide2Url;
  String? paymentChannel;
  String? paymentRefId;
  String? paymentGuideUrl;
  String? paymentAdminFee;
  String? paymentCode;

  factory PayTopUpDataBank.fromJson(Map<String, dynamic> json) => PayTopUpDataBank(
    paymentGuide: json["payment_guide"],
    paymentGuide2Url: json["payment_guide2_url"],
    paymentChannel: json["payment_channel"],
    paymentRefId:  json["payment_ref_id"],
    paymentGuideUrl: json["payment_guide_url"],
    paymentAdminFee: json["payment_admin_fee"],
    paymentCode: json["payment_code"],
  );
}
