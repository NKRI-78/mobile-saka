class UserModel {
  UserModel({
    this.data,
    this.code,
    this.message,
  });

  ResultUser? data;
  int? code;
  String? message;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    data: ResultUser.fromJson(json["body"]),
    code: json["code"],
    message: json["message"],
  );
}

class ResultUser {
  ResultUser({
    this.token,
    this.refreshToken,
    this.user,
  });

  String? token;
  String? refreshToken;
  UserData? user;

  factory ResultUser.fromJson(Map<String, dynamic> json) => ResultUser(
    token: json["token"],
    refreshToken: json["refresh_token"],
    user: UserData.fromJson(json["user"]),
  );
}

class UserData {
  UserData({
    this.created,
    this.emailActivated,
    this.emailAddress,
    this.password,
    this.passwordNew,
    this.passwordConfirm,
    this.phoneActivated,
    this.phoneNumber,
    this.role,
    this.idCardNumber,
    this.noKtp,
    this.noMember,
    this.address,
    this.companyName,
    this.status,
    this.userId,
    this.username,
    this.fullname,
    this.userType,
    this.bloodType,
    this.lanudType,
    this.lanudCode,
    this.sportType,
    this.province,
    this.codeProvince,
    this.city,
    this.codeCity
  });

  DateTime? created;
  bool? emailActivated;
  bool? phoneActivated;
  String? emailAddress;
  String? password;
  String? passwordNew;
  String? passwordConfirm;
  String? address;
  String? companyName;
  String? idCardNumber;
  String? noKtp;
  String? noMember;
  String? phoneNumber;
  String? role;
  String? status;
  String? userId;
  String? username;
  String? fullname;
  String? userType;
  String? bloodType;
  String? lanudType;
  String? lanudCode;
  String? sportType;
  String? province;
  String? codeProvince;
  String? city;
  String? codeCity;

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    created: DateTime.parse(json["created"]),
    emailActivated: json["email_activated"],
    emailAddress: json["email_address"],
    fullname: json["fullname"],
    phoneActivated: json["phone_activated"],
    phoneNumber: json["phone_number"],
    role: json["role"],
    status: json["status"],
    userId: json["user_id"],
    username: json["user_name"],
    userType: json["user_type"],
  );
}
