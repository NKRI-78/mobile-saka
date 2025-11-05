class CourierListModel {
  int status;
  bool error;
  String message;
  List<CourierData> data;

  CourierListModel({
    required this.status,
    required this.error,
    required this.message,
    required this.data,
  });

  factory CourierListModel.fromJson(Map<String, dynamic> json) => CourierListModel(
    status: json["status"],
    error: json["error"],
    message: json["message"],
    data: List<CourierData>.from(json["data"].map((x) => CourierData.fromJson(x))),
  );
}

class CourierData {
  String code;
  String name;
  List<CourierCost> costs;

  CourierData({
    required this.code,
    required this.name,
    required this.costs,
  });

  factory CourierData.fromJson(Map<String, dynamic> json) => CourierData(
    code: json["code"],
    name: json["name"],
    costs: List<CourierCost>.from(json["costs"].map((x) => CourierCost.fromJson(x))),
  );
}

class CourierCost {
  String service;
  String description;
  List<CostCost> cost;

  CourierCost({
    required this.service,
    required this.description,
    required this.cost,
  });

  factory CourierCost.fromJson(Map<String, dynamic> json) => CourierCost(
    service: json["service"],
    description: json["description"],
    cost: List<CostCost>.from(json["cost"].map((x) => CostCost.fromJson(x))),
  );
}

class CostCost {
  int value;
  String etd;
  String note;

  CostCost({
    required this.value,
    required this.etd,
    required this.note,
  });

  factory CostCost.fromJson(Map<String, dynamic> json) => CostCost(
    value: json["value"],
    etd: json["etd"],
    note: json["note"],
  );
}
