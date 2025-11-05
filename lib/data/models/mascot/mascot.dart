class MascotModel {
  MascotModel({
    this.data,
    this.code,
    this.message,
  });

  MascotData? data;
  int? code;
  String? message;

  factory MascotModel.fromJson(Map<String, dynamic> json) => MascotModel(
    data: MascotData.fromJson(json["body"]),
    code: json["code"],
    message: json["message"],
  );
}

class MascotData {
  MascotData({
    this.show,
  });

  int? show;

  factory MascotData.fromJson(Map<String, dynamic> json) => MascotData(
    show: json["show"],
  );
}
