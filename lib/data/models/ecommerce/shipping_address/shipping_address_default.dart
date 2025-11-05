class ShippingAddressModelDefault {
  int status;
  bool error;
  String message;
  List<ShippingAddressDataDefault> data;

  ShippingAddressModelDefault({
    required this.status,
    required this.error,
    required this.message,
    required this.data,
  });

  factory ShippingAddressModelDefault.fromJson(Map<String, dynamic> json) => ShippingAddressModelDefault(
    status: json["status"],
    error: json["error"],
    message: json["message"],
    data: List<ShippingAddressDataDefault>.from(json["data"].map((x) => ShippingAddressDataDefault.fromJson(x))),
  );
}

class ShippingAddressDataDefault {
  String? id;
  String? name;
  String? address;
  String? province;
  String? city;
  String? district;
  String? subdistrict;
  String? postalCode;
  bool? defaultLocation;

  ShippingAddressDataDefault({
    this.id,
    this.name,
    this.address,
    this.province,
    this.city,
    this.district,
    this.subdistrict,
    this.postalCode,
    this.defaultLocation,
  });

  factory ShippingAddressDataDefault.fromJson(Map<String, dynamic> json) => ShippingAddressDataDefault(
    id: json["id"],
    name: json["name"],
    address: json["address"],
    province: json["province"],
    city: json["city"],
    district: json["district"],
    subdistrict: json["subdistrict"],
    postalCode: json["postal_code"],
    defaultLocation: json["default_location"],
  );
}
