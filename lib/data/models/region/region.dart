class RegionRegisterModel {
  RegionRegisterModel({
    this.provinsi,
    this.kabupatenKota,
    this.status,
    this.message,
  });

  List<Province>? provinsi;
  List<City>? kabupatenKota;
  String? status;
  String? message;

  factory RegionRegisterModel.fromJson(Map<String, dynamic> json) => RegionRegisterModel(
    provinsi: json["provinsi"] == null ? [] : List<Province>.from(json["provinsi"].map((x) => Province.fromJson(x))),
    kabupatenKota: json["kabupaten/kota"] == null ? [] : List<City>.from(json["kabupaten/kota"].map((x) => City.fromJson(x))),
    status: json["status"] == null ? null : json["status"],
    message: json["message"] == null ? null : json["message"],
  );
}

class Province {
  Province({
    this.kode,
    this.nama,
  });

  String? kode;
  String? nama;

  factory Province.fromJson(Map<String, dynamic> json) => Province(
    kode: json["kode"] == null ? null : json["kode"],
    nama: json["nama"] == null ? null : json["nama"],
  );
}

class City {
  City({
    this.kode,
    this.nama,
    this.provinsiId,
  });

  String? kode;
  String? nama;
  String? provinsiId;

  factory City.fromJson(Map<String, dynamic> json) => City(
    kode: json["kode"] == null ? null : json["kode"],
    nama: json["nama"] == null ? null : json["nama"],
    provinsiId: json["provinsiId"] == null ? null : json["provinsiId"],
  );
}
