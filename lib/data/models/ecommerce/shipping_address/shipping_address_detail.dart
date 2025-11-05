
class ShippingAddressModelDetail {
  int status;
  bool error;
  String message;
  ShippingAddressDetailData data;

  ShippingAddressModelDetail({
    required this.status,
    required this.error,
    required this.message,
    required this.data,
  });

  factory ShippingAddressModelDetail.fromJson(Map<String, dynamic> json) => ShippingAddressModelDetail(
    status: json["status"],
    error: json["error"],
    message: json["message"],
    data: ShippingAddressDetailData.fromJson(json["data"]),
  );
}

class ShippingAddressDetailData {
  String? id;
  String? name;
  String? address;
  String? province;
  String? city;
  String? district;
  String? subdistrict;
  String? postalCode;
  bool? defaultLocation;

  ShippingAddressDetailData({
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

  factory ShippingAddressDetailData.fromJson(Map<String, dynamic> json) => ShippingAddressDetailData(
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
