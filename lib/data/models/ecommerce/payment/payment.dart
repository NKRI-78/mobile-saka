class PaymentChannelModel {
  int status;
  bool error;
  String message;
  PaymentChannelData data;

  PaymentChannelModel({
    required this.status,
    required this.error,
    required this.message,
    required this.data,
  });

  factory PaymentChannelModel.fromJson(Map<String, dynamic> json) => PaymentChannelModel(
    status: json["status"],
    error: json["error"],
    message: json["message"],
    data: PaymentChannelData.fromJson(json["data"]),
  );
}

class PaymentChannelData {
  String message;
  List<PaymentChannelItem> data;

  PaymentChannelData({
    required this.message,
    required this.data,
  });

  factory PaymentChannelData.fromJson(Map<String, dynamic> json) => PaymentChannelData(
    message: json["message"],
    data: List<PaymentChannelItem>.from(json["data"].map((x) => PaymentChannelItem.fromJson(x))),
  );
}

class PaymentChannelItem {
  int id;
  String paymentType;
  String name;
  String nameCode;
  dynamic logo;
  int fee;
  String platform;
  dynamic howToUseUrl;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;

  PaymentChannelItem({
    required this.id,
    required this.paymentType,
    required this.name,
    required this.nameCode,
    required this.logo,
    required this.fee,
    required this.platform,
    required this.howToUseUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory PaymentChannelItem.fromJson(Map<String, dynamic> json) => PaymentChannelItem(
    id: json["id"],
    paymentType: json["paymentType"],
    name: json["name"],
    nameCode: json["nameCode"],
    logo: json["logo"],
    fee: json["fee"],
    platform: json["platform"],
    howToUseUrl: json["howToUseUrl"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    deletedAt: json["deletedAt"],
  );
}
