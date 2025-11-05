class ResponseMidtransEmoney {
  int status;
  bool error;
  String message;
  ResponseMidtransEmoneyData data;

  ResponseMidtransEmoney({
    required this.status,
    required this.error,
    required this.message,
    required this.data,
  });

  factory ResponseMidtransEmoney.fromJson(Map<String, dynamic> json) => ResponseMidtransEmoney(
    status: json["status"],
    error: json["error"],
    message: json["message"],
    data: ResponseMidtransEmoneyData.fromJson(json["data"]),
  );
}

class ResponseMidtransEmoneyData {
  String message;
  PurpleData data;

  ResponseMidtransEmoneyData({
    required this.message,
    required this.data,
  });

  factory ResponseMidtransEmoneyData.fromJson(Map<String, dynamic> json) => ResponseMidtransEmoneyData(
    message: json["message"],
    data: PurpleData.fromJson(json["data"]),
  );
}

class PurpleData {
  FluffyData data;
  int id;
  String orderId;
  int grossAmount;
  int totalAmount;
  int channelId;
  String transactionStatus;
  String transactionId;
  String app;
  String callbackUrl;
  DateTime updatedAt;
  DateTime createdAt;
  Channel channel;

  PurpleData({
    required this.data,
    required this.id,
    required this.orderId,
    required this.grossAmount,
    required this.totalAmount,
    required this.channelId,
    required this.transactionStatus,
    required this.transactionId,
    required this.app,
    required this.callbackUrl,
    required this.updatedAt,
    required this.createdAt,
    required this.channel,
  });

  factory PurpleData.fromJson(Map<String, dynamic> json) => PurpleData(
    data: FluffyData.fromJson(json["data"]),
    id: json["id"],
    orderId: json["orderId"],
    grossAmount: json["grossAmount"],
    totalAmount: json["totalAmount"],
    channelId: json["ChannelId"],
    transactionStatus: json["transactionStatus"],
    transactionId: json["transactionId"],
    app: json["app"],
    callbackUrl: json["callbackUrl"],
    updatedAt: DateTime.parse(json["updatedAt"]),
    createdAt: DateTime.parse(json["createdAt"]),
    channel: Channel.fromJson(json["channel"]),
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
  List<Action> actions;
  String paymentType;

  FluffyData({
    required this.actions,
    required this.paymentType,
  });

  factory FluffyData.fromJson(Map<String, dynamic> json) => FluffyData(
    actions: List<Action>.from(json["actions"].map((x) => Action.fromJson(x))),
    paymentType: json["paymentType"],
  );
}

class Action {
  String name;
  String method;
  String url;

  Action({
    required this.name,
    required this.method,
    required this.url,
  });

  factory Action.fromJson(Map<String, dynamic> json) => Action(
    name: json["name"],
    method: json["method"],
    url: json["url"],
  );
}
