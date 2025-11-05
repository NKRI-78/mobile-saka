
class TrackingModel {
  int status;
  bool error;
  String message;
  TrackingData data;

  TrackingModel({
    required this.status,
    required this.error,
    required this.message,
    required this.data,
  });

  factory TrackingModel.fromJson(Map<String, dynamic> json) => TrackingModel(
    status: json["status"],
    error: json["error"],
    message: json["message"],
    data: TrackingData.fromJson(json["data"]),
  );
}

class TrackingData {
  String? podStatus;
  List<TrackingDetailData>? details;
  List<TrackingHistory>? histories;

  TrackingData({
    this.podStatus,
    this.details,
    this.histories,
  });

  factory TrackingData.fromJson(Map<String, dynamic> json) => TrackingData(
    podStatus: json["pod_status"],
    details: List<TrackingDetailData>.from(json["details"].map((x) => TrackingDetailData.fromJson(x))),
    histories: List<TrackingHistory>.from(json["histories"].map((x) => TrackingHistory.fromJson(x))),
  );
}

class TrackingDetailData {
  String cnoteNo;
  DateTime cnoteDate;
  String cnoteWeight;
  String cnoteOrigin;
  String cnoteShipperName;
  String cnoteShipperAddr1;
  String cnoteShipperAddr2;
  String cnoteShipperAddr3;
  String cnoteShipperCity;
  String cnoteReceiverName;
  String cnoteReceiverAddr1;
  String cnoteReceiverAddr2;
  String cnoteReceiverAddr3;
  String cnoteReceiverCity;

  TrackingDetailData({
    required this.cnoteNo,
    required this.cnoteDate,
    required this.cnoteWeight,
    required this.cnoteOrigin,
    required this.cnoteShipperName,
    required this.cnoteShipperAddr1,
    required this.cnoteShipperAddr2,
    required this.cnoteShipperAddr3,
    required this.cnoteShipperCity,
    required this.cnoteReceiverName,
    required this.cnoteReceiverAddr1,
    required this.cnoteReceiverAddr2,
    required this.cnoteReceiverAddr3,
    required this.cnoteReceiverCity,
  });

  factory TrackingDetailData.fromJson(Map<String, dynamic> json) => TrackingDetailData(
    cnoteNo: json["cnote_no"],
    cnoteDate: DateTime.parse(json["cnote_date"]),
    cnoteWeight: json["cnote_weight"],
    cnoteOrigin: json["cnote_origin"],
    cnoteShipperName: json["cnote_shipper_name"],
    cnoteShipperAddr1: json["cnote_shipper_addr1"],
    cnoteShipperAddr2: json["cnote_shipper_addr2"],
    cnoteShipperAddr3: json["cnote_shipper_addr3"],
    cnoteShipperCity: json["cnote_shipper_city"],
    cnoteReceiverName: json["cnote_receiver_name"],
    cnoteReceiverAddr1: json["cnote_receiver_addr1"],
    cnoteReceiverAddr2: json["cnote_receiver_addr2"],
    cnoteReceiverAddr3: json["cnote_receiver_addr3"],
    cnoteReceiverCity: json["cnote_receiver_city"],
  );
}

class TrackingHistory {
  String date;
  String desc;
  String code;

  TrackingHistory({
    required this.date,
    required this.desc,
    required this.code,
  });

  factory TrackingHistory.fromJson(Map<String, dynamic> json) => TrackingHistory(
    date: json["date"],
    desc: json["desc"],
    code: json["code"],
  );
}
