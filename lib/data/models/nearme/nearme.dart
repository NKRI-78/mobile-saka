class MembernearModel {
  int status;
  bool error;
  String message;
  List<MembernearData> data;

  MembernearModel({
    required this.status,
    required this.error,
    required this.message,
    required this.data,
  });

  factory MembernearModel.fromJson(Map<String, dynamic> json) => MembernearModel(
    status: json["status"],
    error: json["error"],
    message: json["message"],
    data: List<MembernearData>.from(json["data"].map((x) => MembernearData.fromJson(x))),
  );
}

class MembernearData {
  User user;
  String lat;
  String lng;
  String distance;

  MembernearData({
    required this.user,
    required this.lat,
    required this.lng,
    required this.distance,
  });

  factory MembernearData.fromJson(Map<String, dynamic> json) => MembernearData(
    user: User.fromJson(json["user"]),
    lat: json["lat"],
    lng: json["lng"],
    distance: json["distance"],
  );
}

class User {
  String avatar;
  String name;
  String email;
  String phone;

  User({
    required this.avatar,
    required this.name,
    required this.email,
    required this.phone,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    avatar: json["avatar"],
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
  );
}
