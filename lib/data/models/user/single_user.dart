class SingleUserModel {
  SingleUserModel({
    this.body,
    this.code,
    this.message,
  });

  SingleUserData? body;
  int? code;
  String? message;

  factory SingleUserModel.fromJson(Map<String, dynamic> json) => SingleUserModel(
    body: SingleUserData.fromJson(json["body"]),
    code: json["code"],
    message: json["message"],
  );
}

class SingleUserData {

  SingleUserData({
    this.userId,
    this.emailAddress,
    this.phoneNumber,
    this.role,
    this.userName,
    this.userType,
    this.status,
    this.address,
    this.fullname,
    this.gender,
    this.idCardNumber,
    this.shortBio,
    this.profilePic,
  });

  String? userId;
  String? emailAddress;
  String? phoneNumber;
  String? role;
  String? userName;
  String? userType;
  String? status;
  String? address;
  String? fullname;
  String? gender;
  String? idCardNumber;
  String? shortBio;
  String? profilePic;

  factory SingleUserData.fromJson(Map<String, dynamic> json) => SingleUserData(
    userId: json["user_id"],
    emailAddress: json["email_address"],
    phoneNumber: json["phone_number"],
    role: json["role"],
    userName: json["user_name"],
    userType: json["user_type"],
    status: json["status"],
    address: json["address"],
    fullname: json["fullname"],
    gender: json["gender"],
    idCardNumber: json["id_card_number"],
    shortBio: json["short_bio"],
    profilePic: json["profile_pic"],
  );  
}
