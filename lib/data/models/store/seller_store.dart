class SellerStoreModel {
  SellerStoreModel({
    this.code,
    this.message,
    this.body,
  });

  int? code;
  String? message;
  ResultSingleStore? body;

  factory SellerStoreModel.fromJson(Map<String, dynamic> json) =>
  SellerStoreModel(
    code: json["code"],
    message:json["message"],
    body: json["body"] == null 
    ? ResultSingleStore(
        address: "",
        city: "",
        classId: "",
        description: "",
        email: "",
        id: "",
        name: "",
        open: false,
        owner: "",
        phone: "",
        picture: Picture(),
        postalCode: "",
        province: "",
        status: 0,
        subDistrict: "",
        supportedCouriers: [],
        village: "",
        location: [],
      )
    : ResultSingleStore.fromJson(json["body"]),
  );
}

class ResultSingleStore {
  ResultSingleStore({
    this.id,
    this.owner,
    this.name,
    this.description,
    this.open,
    this.picture,
    this.status,
    this.province,
    this.city,
    this.subDistrict,
    this.village,
    this.email,
    this.phone,
    this.postalCode,
    this.address,
    this.location,
    this.supportedCouriers,
    this.classId,
  });

  String? id;
  String? owner;
  String? name;
  String? description;
  bool? open;
  Picture? picture;
  int? status;
  String? province;
  String? city;
  String? subDistrict;
  String? village;
  String? email;
  String? phone;
  String? postalCode;
  String? address;
  List<double>? location;
  List<SupportedCourier>? supportedCouriers;
  String? classId;

  factory ResultSingleStore.fromJson(Map<String, dynamic> json) =>
  ResultSingleStore(
    id: json["id"],
    owner: json["owner"],
    name: json["name"],
    description: json["description"],
    open: json["open"],
    picture: Picture.fromJson(json["picture"]),
    status: json["status"],
    province: json["province"],
    city: json["city"],
    subDistrict: json["subdistrict"],
    village: json["village"],
    postalCode: json["postalCode"],
    address: json["address"],
    email: json["email"],
    phone: json["phone"],
    location: json["location"] == null ? [] : List<double>.from(json["location"].map((x) => x)),
    supportedCouriers: json["supportedCouriers"] == null ? [] : List<SupportedCourier>.from(json["supportedCouriers"].map((x) => SupportedCourier.fromJson(x))),
    classId: json["classId"],
  );
}

class Picture {
  Picture({
    this.originalName,
    this.fileLength,
    this.path,
    this.contentType,
  });

  String? originalName;
  int? fileLength;
  String? path;
  String? contentType;

  factory Picture.fromJson(Map<String, dynamic> json) => Picture(
    originalName: json["originalName"],
    fileLength: json["fileLength"],
    path: json["path"],
    contentType: json["contentType"],
  );
}

class SupportedCourier {
  SupportedCourier({
    this.id,
    this.name,
    this.image,
    this.checkPriceSupported,
    this.checkResiSupported,
    this.classId,
  });

  String? id;
  String? name;
  String? image;
  bool? checkPriceSupported;
  bool? checkResiSupported;
  String? classId;

  factory SupportedCourier.fromJson(Map<String, dynamic> json) =>
    SupportedCourier(
      id: json["id"],
      name: json["name"],
      image: json["image"],
      checkPriceSupported: json["checkPriceSupported"],
      checkResiSupported: json["checkResiSupported"],
      classId: json["classId"],
    );
}
