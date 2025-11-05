class RegionModel {
  RegionModel({
    this.code,
    this.message,
    this.count,
    this.first,
    this.body,
  });

  int? code;
  String? message;
  int? count;
  bool? first;
  List<RegionData>? body;

  factory RegionModel.fromJson(Map<String, dynamic> json) => RegionModel(
    code: json["code"],
    message: json["message"],
    count: json["count"],
    first: json["first"],
    body: json["body"] == null ? [] : List<RegionData>.from(json["body"].map((x) => RegionData.fromJson(x))),
  );
}

class RegionData {
  RegionData({
    this.id,
    this.status,
    this.created,
    this.name,
    this.classId,
  });

  String? id;
  int? status;
  String? created;
  String? name;
  String? classId;

  factory RegionData.fromJson(Map<String, dynamic> json) => RegionData(
    id: json["id"],
    status: json["status"],
    created: json["created"],
    name: json["name"],
    classId: json["classId"],
  );
}
