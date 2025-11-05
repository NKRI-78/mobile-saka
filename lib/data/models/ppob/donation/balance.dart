class BalanceDonationModel {
  BalanceDonationModel({
    this.code,
    this.message,
    this.body,
    this.error,
  });

  int? code;
  String? message;
  BalanceDonationData? body;
  dynamic error;

  factory BalanceDonationModel.fromJson(Map<String, dynamic> json) => BalanceDonationModel(
    code: json["code"],
    message: json["message"],
    body: BalanceDonationData.fromJson(json["body"]),
    error: json["error"],
  );
}

class BalanceDonationData {
  BalanceDonationData({
    this.total,
    this.lastDonation,
    this.classId,
  });

  dynamic total;
  String? lastDonation;
  String? classId;

  factory BalanceDonationData.fromJson(Map<String, dynamic> json) => BalanceDonationData(
    total: json["total"] ?? "",
    lastDonation: json["lastDonation"],
    classId: json["classId"],
  );
}
