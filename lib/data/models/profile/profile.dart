class ProfileModel {
  ProfileModel({
    this.data,
    this.code,
    this.message,
  });

  ProfileData? data;
  int? code;
  String? message;

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
    data: ProfileData.fromJson(json["body"]),
    code: json["code"],
    message: json["message"],
  );
}

class ProfileData {
  ProfileData({
    this.id,
    this.userId,
    this.noMember,
    this.address,
    this.fullname,
    this.gender,
    this.shortBio,
    this.profilePic,
    this.status,
    this.idMember,
    this.province,
    this.city,
    this.lanud,
    this.created,
    this.updated,
  });

  int? id;
  String? userId;
  String? noMember;
  String? address;
  String? fullname;
  String? gender;
  String? shortBio;
  String? profilePic;
  bool? status;
  String? idMember;
  String? province;
  String? codeProvince;
  String? city;
  String? codeCity;
  String? lanud;
  String? codeLanud;
  DateTime? created;
  DateTime? updated;

  factory ProfileData.fromJson(Map<String, dynamic> json) => ProfileData(
    id: json["id"],
    userId: json["user_id"],
    noMember: json["no_member"],
    address: json["address"],
    fullname: json["fullname"],
    gender: json["gender"],
    shortBio: json["short_bio"],
    profilePic: json["profile_pic"],
    status: json["status"],
    idMember: json["id_member"],
    province: json["province"],
    city: json["city"],
    lanud: json["lanud"],
    created: DateTime.parse(json["created"]),
    updated: DateTime.parse(json["updated"]),
  );
}



