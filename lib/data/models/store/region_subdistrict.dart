class RegionSubdistrictModel {
  RegionSubdistrictModel({
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
  List<RegionSubdistrictList>? body;
  dynamic error;

  factory RegionSubdistrictModel.fromJson(Map<String, dynamic> json) =>
    RegionSubdistrictModel(
      code: json["code"],
      message: json["message"],
      count: json["count"],
      first: json["first"],
      body: json["body"] == null ? []: List<RegionSubdistrictList>.from(json["body"].map((x) => RegionSubdistrictList.fromJson(x))),
      error: json["error"],
    );
}

class RegionSubdistrictList {
  RegionSubdistrictList({
    this.id,
    this.name,
    this.city,
    this.classId,
    this.province,
  });

  String? id;
  String? name;
  RegionSubdistrictList? city;
  String? classId;
  RegionSubdistrictList? province;

  factory RegionSubdistrictList.fromJson(Map<String, dynamic> json) =>
  RegionSubdistrictList(
    id: json["id"],
    name: json["name"],
    city: json["city"] == null ? null : RegionSubdistrictList.fromJson(json["city"]),
    classId: json["classId"],
    province: json["province"] == null ? null : RegionSubdistrictList.fromJson(json["province"]),
  );
}
