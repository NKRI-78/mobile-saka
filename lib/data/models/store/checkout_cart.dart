
class CheckoutCartStoreModel {
  CheckoutCartStoreModel({
    this.code,
    this.message,
    this.body,
    this.error,
  });

  int? code;
  String? message;
  ResultCheckoutCart? body;
  dynamic error;

  factory CheckoutCartStoreModel.fromJson(Map<String, dynamic> json) =>
    CheckoutCartStoreModel(
      code: json["code"],
      message: json["message"],
      body: json["body"] == null ? null : ResultCheckoutCart.fromJson(json["body"]),
      error: json["error"],
    );
}

class ResultCheckoutCart {
  ResultCheckoutCart({
    this.paymentChannel,
    this.paymentCode,
    this.paymentRefId,
    this.paymentGuide,
    this.paymentAdminFee,
    this.paymentStatus,
    this.refNo,
    this.currency,
    this.billingUid,
    this.amount,
  });

  String? paymentChannel;
  String? paymentCode;
  String? paymentRefId;
  String? paymentGuide;
  String? paymentAdminFee;
  String? paymentStatus;
  String? refNo;
  String? currency;
  String? billingUid;
  double? amount;

  factory ResultCheckoutCart.fromJson(Map<String, dynamic> json) =>
  ResultCheckoutCart(
    paymentChannel: json["paymentChannel"],
    paymentCode: json["paymentCode"],
    paymentRefId: json["paymentRefId"],
    paymentGuide: json["paymentGuide"],
    paymentAdminFee: json["paymentAdminFee"],
    paymentStatus: json["paymentStatus"],
    refNo: json["refNo"],
    currency: json["currency"],
    billingUid: json["billingUid"],
    amount: json["amount"],
  );
}
