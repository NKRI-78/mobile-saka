class ProvinceModel {
  int status;
  bool error;
  String message;
  List<ProvinceData> data;

  ProvinceModel({
    required this.status,
    required this.error,
    required this.message,
    required this.data,
  });

  factory ProvinceModel.fromJson(Map<String, dynamic> json) => ProvinceModel(
    status: json["status"],
    error: json["error"],
    message: json["message"],
    data: List<ProvinceData>.from(json["data"].map((x) => ProvinceData.fromJson(x))),
  );
}

class ProvinceData {
  String provinceName;

  ProvinceData({
      required this.provinceName,
  });

  factory ProvinceData.fromJson(Map<String, dynamic> json) => ProvinceData(
    provinceName: json["province_name"],
  );
}
