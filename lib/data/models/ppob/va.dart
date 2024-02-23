class VAModel {
  VAModel({
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
  List<VAData>? body;
  dynamic error;

  factory VAModel.fromJson(Map<String, dynamic> json) => VAModel(
    code: json["code"],
    message: json["message"],
    count: json["count"],
    first: json["first"],
    body: List<VAData>.from(json["body"].map((x) => VAData.fromJson(x))),
    error: json["error"],
  );

}

class VAData {
  VAData({
    this.channel,
    this.classId,
    this.guide,
    this.isDirect,
    this.name,
    this.paymentCode,
    this.paymentDescription,
    this.paymentGateway,
    this.paymentLogo,
    this.paymentName,
    this.paymentUrl,
    this.paymentUrlV2,
    this.totalAdminFee,
  });

  String? channel;
  String? classId;
  String? guide;
  bool? isDirect;
  String? name;
  String? paymentCode;
  String? paymentDescription;
  String? paymentGateway;
  String? paymentLogo;
  String? paymentName;
  String? paymentUrl;
  String? paymentUrlV2;
  dynamic totalAdminFee;

  factory VAData.fromJson(Map<String, dynamic> json) => VAData(
    channel: json["channel"],
    classId: json["classId"],
    guide: json["guide"],
    isDirect: json["is_direct"],
    name: json["name"],
    paymentCode: json["payment_code"],
    paymentDescription: json["payment_description"],
    paymentGateway: json["payment_gateway"],
    paymentLogo: json["payment_logo"],
    paymentName: json["payment_name"],
    paymentUrl: json["payment_url"],
    paymentUrlV2: json["payment_url_v2"],
    totalAdminFee: json["total_admin_fee"] ?? "",
  );
}
