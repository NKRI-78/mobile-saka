class ShippingAddressModel {
  int status;
  bool error;
  String message;
  List<ShippingAddressData> data;

  ShippingAddressModel({
    required this.status,
    required this.error,
    required this.message,
    required this.data,
  });

  factory ShippingAddressModel.fromJson(Map<String, dynamic> json) => ShippingAddressModel(
    status: json["status"],
    error: json["error"],
    message: json["message"],
    data: List<ShippingAddressData>.from(json["data"].map((x) => ShippingAddressData.fromJson(x))),
  );
}

class ShippingAddressData {
  String id;
  String name;
  String address;
  String province;
  String city;
  String subdistrict;
  String postalCode;
  bool defaultLocation;

  ShippingAddressData({
    required this.id,
    required this.name,
    required this.address,
    required this.province,
    required this.city,
    required this.subdistrict,
    required this.postalCode,
    required this.defaultLocation,
  });

  factory ShippingAddressData.fromJson(Map<String, dynamic> json) => ShippingAddressData(
    id: json["id"],
    name: json["name"],
    address: json["address"],
    province: json["province"],
    city: json["city"],
    subdistrict: json["subdistrict"],
    postalCode: json["postal_code"],
    defaultLocation: json["default_location"],
  );
}
