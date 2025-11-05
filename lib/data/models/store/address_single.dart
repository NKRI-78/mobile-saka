import 'package:saka/data/models/store/region.dart';

class AddressSingleModel {
  AddressSingleModel({
    this.code,
    this.message,
    this.data,
    this.error,
  });

  int? code;
  String? message;
  RegionData? data;
  dynamic error;

  factory AddressSingleModel.fromJson(Map<String, dynamic> json) => AddressSingleModel(
    code: json["code"],
    message: json["message"],
    data: RegionData.fromJson(json["body"]),
    error: json["error"],
  );
}

class AddressSingleList {
  AddressSingleList({
    this.id,
    this.phoneNumber,
    this.address,
    this.postalCode,
    this.province,
    this.city,
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
    String? subdistrict;
    bool? defaultLocation;
    List<double>? location;
    String? name;
    String? classId;

  factory AddressSingleList.fromJson(Map<String, dynamic> json) => AddressSingleList(
    id: json["id"],
    phoneNumber: json["phoneNumber"],
    address: json["address"],
    postalCode: json["postalCode"],
    province: json["province"],
    city: json["city"],
    subdistrict: json["subdistrict"],
    defaultLocation: json["defaultLocation"],
    location: json["location"] == null ? [] : List<double>.from(json["location"].map((x) => x.toDouble())),
    name: json["name"],
    classId: json["classId"],
  );
}
