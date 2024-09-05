class DistrictModel {
  int status;
  bool error;
  String message;
  List<DistrictData> data;

  DistrictModel({
    required this.status,
    required this.error,
    required this.message,
    required this.data,
  });

  factory DistrictModel.fromJson(Map<String, dynamic> json) => DistrictModel(
    status: json["status"],
    error: json["error"],
    message: json["message"],
    data: List<DistrictData>.from(json["data"].map((x) => DistrictData.fromJson(x))),
  );
}

class DistrictData {
  String districtName;

  DistrictData({
    required this.districtName,
  });

  factory DistrictData.fromJson(Map<String, dynamic> json) => DistrictData(
    districtName: json["district_name"],
  );
}
