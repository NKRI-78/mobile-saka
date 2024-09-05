class SubdistrictModel {
  int status;
  bool error;
  String message;
  List<SubdistrictData> data;

  SubdistrictModel({
    required this.status,
    required this.error,
    required this.message,
    required this.data,
  });

  factory SubdistrictModel.fromJson(Map<String, dynamic> json) => SubdistrictModel(
    status: json["status"],
    error: json["error"],
    message: json["message"],
    data: List<SubdistrictData>.from(json["data"].map((x) => SubdistrictData.fromJson(x))),
  );
}

class SubdistrictData {
  String subdistrictName;
  int zipCode;

  SubdistrictData({
    required this.subdistrictName,
    required this.zipCode,
  });

  factory SubdistrictData.fromJson(Map<String, dynamic> json) => SubdistrictData(
    subdistrictName: json["subdistrict_name"],
    zipCode: json["zip_code"],
  );
}
