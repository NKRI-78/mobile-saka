class WalletDenomModel {
  final int? code;
  dynamic error;
  final String? message;
  final WalletDenomBody? body;

  WalletDenomModel({
    this.code,
    this.error,
    this.message,
    this.body,
  });

  factory WalletDenomModel.fromJson(Map<String, dynamic> json) =>
    WalletDenomModel(
      code: json["code"],
      error: json["error"],
      message: json["message"],
      body: json["body"] == null
      ? null
      : WalletDenomBody.fromJson(json["body"]),
    );
}

class WalletDenomBody {
  final List<WalletDenomData>? data;

  const WalletDenomBody({
    this.data,
  });

  factory WalletDenomBody.fromJson(Map<String, dynamic> json) =>
    WalletDenomBody(
      data: json["data"] == null
      ? []
      : List<WalletDenomData>.from(
      json["data"]!.map((x) => WalletDenomData.fromJson(x))),
    );
}

class WalletDenomData {
  final String? id;
  final int? denom;

  const WalletDenomData({
    this.id,
    this.denom,
  });

  factory WalletDenomData.fromJson(Map<String, dynamic> json) =>
    WalletDenomData(
      id: json["id"],
      denom: json["denom"],
    );
}