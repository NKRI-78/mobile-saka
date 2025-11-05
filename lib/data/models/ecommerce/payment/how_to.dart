class HowToPaymentModel {
  int status;
  bool error;
  String message;
  Data data;

  HowToPaymentModel({
    required this.status,
    required this.error,
    required this.message,
    required this.data,
  });

  factory HowToPaymentModel.fromJson(Map<String, dynamic> json) => HowToPaymentModel(
    status: json["status"],
    error: json["error"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );
}

class Data {
  List<DataHowToPayment> mbank;
  List<DataHowToPayment> atm;
  List<DataHowToPayment> emoney;

  Data({
    required this.mbank,
    required this.atm,
    required this.emoney,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    mbank: List<DataHowToPayment>.from(json["mbank"].map((x) => DataHowToPayment.fromJson(x))),
    atm: List<DataHowToPayment>.from(json["atm"].map((x) => DataHowToPayment.fromJson(x))),
    emoney: List<DataHowToPayment>.from(json["emoney"].map((x) => DataHowToPayment.fromJson(x))),
  );
}

class DataHowToPayment {
  String title;
  List<Step> data;

  DataHowToPayment({
    required this.title,
    required this.data,
  });

  factory DataHowToPayment.fromJson(Map<String, dynamic> json) => DataHowToPayment(
    title: json["title"],
    data: List<Step>.from(json["data"].map((x) => Step.fromJson(x))),
  );
}

class Step {
  int step;
  String content;

  Step({
    required this.step,
    required this.content,
  });

  factory Step.fromJson(Map<String, dynamic> json) => Step(
    step: json["step"],
    content: json["content"],
  );
}
