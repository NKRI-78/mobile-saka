class MembernearModel {
  List<MembernearData> body;
  int code;
  String message;

  MembernearModel({
    required this.body,
    required this.code,
    required this.message,
  });

  factory MembernearModel.fromJson(Map<String, dynamic> json) => MembernearModel(
    body: List<MembernearData>.from(json["body"].map((x) => MembernearData.fromJson(x))),
    code: json["code"],
    message: json["message"],
  );
}

class MembernearData {
  String avatarUrl;
  String distance;
  String fullname;
  String lastseenDay;
  String lastseenHour;
  String lastseenMinute;
  String phoneNumber;
  String userId;

  MembernearData({
    required this.avatarUrl,
    required this.distance,
    required this.fullname,
    required this.lastseenDay,
    required this.lastseenHour,
    required this.lastseenMinute,
    required this.phoneNumber,
    required this.userId,
  });

  factory MembernearData.fromJson(Map<String, dynamic> json) => MembernearData(
    avatarUrl: json["avatar_url"],
    distance: json["distance"],
    fullname: json["fullname"],
    lastseenDay: json["lastseen_day"],
    lastseenHour: json["lastseen_hour"],
    lastseenMinute: json["lastseen_minute"],
    phoneNumber: json["phone_number"],
    userId: json["user_id"],
  );
  
}
