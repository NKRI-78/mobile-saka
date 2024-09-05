class CityModel {
  int status;
  bool error;
  String message;
  List<CityData> data;

  CityModel({
    required this.status,
    required this.error,
    required this.message,
    required this.data,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) => CityModel(
    status: json["status"],
    error: json["error"],
    message: json["message"],
    data: List<CityData>.from(json["data"].map((x) => CityData.fromJson(x))),
  );
}

class CityData {
  String cityName;

  CityData({
    required this.cityName,
  });

  factory CityData.fromJson(Map<String, dynamic> json) => CityData(
    cityName: json["city_name"],
  );
}
