class BankPaymentStore {
  BankPaymentStore({
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
  List<BankPaymentStoreData>? body;
  dynamic error;

  factory BankPaymentStore.fromJson(Map<String, dynamic> json) => BankPaymentStore(
    code: json["code"],
    message: json["message"],
    count: json["count"],
    first: json["first"],
    body: json["body"] == null ? [] : List<BankPaymentStoreData>.from(json["body"].map((x) => BankPaymentStoreData.fromJson(x))),
    error: json["error"],
  );
}

class BankPaymentStoreData {
  BankPaymentStoreData({
    this.channel,
    this.name,
    this.guide,
    this.paymentFee,
    this.logo,
  });

  String? channel;
  String? name;
  String? guide;
  double? paymentFee;
  String? logo;

  factory BankPaymentStoreData.fromJson(Map<String, dynamic> json) => BankPaymentStoreData(
    channel: json["channel"],
    name: json["name"],
    guide: json["guide"],
    paymentFee: json["paymentFee"],
    logo: json["logo"],
  );
}
