class AddressModel {
  AddressModel({
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
  List<AddressList>? body;
  dynamic error;

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
    code: json["code"],
    message: json["message"],
    count: json["count"],
    first: json["first"],
    body: json["body"] == null ? [] : List<AddressList>.from(json["body"].map((x) => AddressList.fromJson(x))),
    error: json["error"],
  );
}

class AddressList {
  AddressList({
    this.id,
    this.phoneNumber,
    this.address,
    this.postalCode,
    this.province,
    this.city,
    this.village,
    this.subdistrict,
    this.defaultLocation,
    this.location,
    this.name,
    this.classId,
  });

  String? id;
  String? phoneNumber;
  String? address;
  String? postalCode;
  String? province;
  String? city;
  String? village;
  String? subdistrict;
  bool? defaultLocation;
  List<double>? location;
  String? name;
  String? classId;

  factory AddressList.fromJson(Map<String, dynamic> json) => AddressList(
    id: json["id"],
    phoneNumber: json["phoneNumber"],
    address: json["address"],
    postalCode: json["postalCode"],
    province: json["province"],
    city: json["city"],
    village: json["village"],
    subdistrict: json["subdistrict"],
    defaultLocation: json["defaultLocation"],
    location: json["location"] == null ? [] : List<double>.from(json["location"].map((x) => x.toDouble())),
    name: json["name"],
    classId:json["classId"],
  );
}
