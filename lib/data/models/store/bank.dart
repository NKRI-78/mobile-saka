class BankModel {
  BankModel({
    this.data,
  });

  List<BankData>? data;

  factory BankModel.fromJson(Map<String, dynamic> json) => BankModel(
    data: json["data"] == null ? [] : List<BankData>.from(json["data"].map((x) => BankData.fromJson(x))),
  );

}

class BankData {
  BankData({
    this.channel,
    this.name,
    this.guide,
    this.paymentCode,
    this.paymentName,
    this.paymentDescription,
    this.paymentLogo,
    this.paymentUrl,
    this.paymentUrlV2,
    this.totalAdminFee,
    this.isDirect,
    this.status,
    this.updatedAt,
    this.createdAt,
  });

  String? channel;
  String? name;
  String? guide;
  dynamic paymentCode;
  dynamic paymentName;
  dynamic paymentDescription;
  String? paymentLogo;
  String? paymentUrl;
  String? paymentUrlV2;
  String? totalAdminFee;
  bool? isDirect;
  int? status;
  DateTime? updatedAt;
  DateTime? createdAt;

  factory BankData.fromJson(Map<String, dynamic> json) => BankData(
    channel: json["channel"],
    name:json["name"],
    guide: json["guide"],
    paymentCode: json["payment_code"],
    paymentName: json["payment_name"],
    paymentDescription: json["payment_description"],
    paymentLogo: json["payment_logo"],
    paymentUrl: json["payment_url"],
    paymentUrlV2: json["payment_url_v2"],
    totalAdminFee: json["total_admin_fee"],
    isDirect: json["is_direct"],
    status: json["status"],
    updatedAt: DateTime.parse(json["updated_at"]),
    createdAt: DateTime.parse(json["created_at"]),
  );
}
