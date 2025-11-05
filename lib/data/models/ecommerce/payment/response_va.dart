class ResponseMidtransVa {
  int status;
  bool error;
  String message;
  ResponseMidtransVaData data;

  ResponseMidtransVa({
    required this.status,
    required this.error,
    required this.message,
    required this.data,
  });

  factory ResponseMidtransVa.fromJson(Map<String, dynamic> json) => ResponseMidtransVa(
    status: json["status"],
    error: json["error"],
    message: json["message"],
    data: ResponseMidtransVaData.fromJson(json["data"]),
  );
}

class ResponseMidtransVaData {
  String message;
  PurpleData data;

  ResponseMidtransVaData({
    required this.message,
    required this.data,
  });

  factory ResponseMidtransVaData.fromJson(Map<String, dynamic> json) => ResponseMidtransVaData(
    message: json["message"],
    data: PurpleData.fromJson(json["data"]),
  );
}

class PurpleData {
  String orderId;
  int grossAmount;
  int totalAmount;
  int channelId;
  String transactionStatus;
  String transactionId;
  DateTime expire;
  String app;
  FluffyData data;
  Channel channel;
  String callbackUrl;

  PurpleData({
    required this.orderId,
    required this.grossAmount,
    required this.totalAmount,
    required this.channelId,
    required this.transactionStatus,
    required this.transactionId,
    required this.expire,
    required this.app,
    required this.data,
    required this.channel,
    required this.callbackUrl,
  });

  factory PurpleData.fromJson(Map<String, dynamic> json) => PurpleData(
    orderId: json["orderId"],
    grossAmount: json["grossAmount"],
    totalAmount: json["totalAmount"],
    channelId: json["ChannelId"],
    transactionStatus: json["transactionStatus"],
    transactionId: json["transactionId"],
    expire: DateTime.parse(json["expire"]),
    app: json["app"],
    data: FluffyData.fromJson(json["data"]),
    channel: Channel.fromJson(json["channel"]),
    callbackUrl: json["callbackUrl"],
  );
}

class Channel {
  int id;
  String paymentType;
  String name;
  String nameCode;
  dynamic logo;
  dynamic fee;
  String platform;
  dynamic howToUseUrl;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;

  Channel({
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

  factory Channel.fromJson(Map<String, dynamic> json) => Channel(
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

class FluffyData {
  String? bank;
  String? billKey;
  String? vaNumber;
  String? paymentType;
  String? billerCode;

  FluffyData({
    required this.bank,
    required this.billKey,
    required this.vaNumber,
    required this.paymentType,
    required this.billerCode,
  });

  factory FluffyData.fromJson(Map<String, dynamic> json) => FluffyData(
    bank: json["bank"],
    billKey: json["billKey"],
    vaNumber: json["vaNumber"],
    paymentType: json["paymentType"],
    billerCode: json["billerCode"],
  );
}
