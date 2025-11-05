class InquiryPLNPrabayarModel {
  int code;
  dynamic error;
  String message;
  InquiryPLNPrabayarData data;

  InquiryPLNPrabayarModel({
    required this.code,
    this.error,
    required this.message,
    required this.data,
  });

  factory InquiryPLNPrabayarModel.fromJson(Map<String, dynamic> json) => InquiryPLNPrabayarModel(
    code: json["code"],
    error: json["error"],
    message: json["message"],
    data: InquiryPLNPrabayarData.fromJson(json["body"]),
  );
}

class InquiryPLNPrabayarData {
  String? kodeProduk;
  String? waktu;
  String? idpel1;
  String? idpel2;
  String? idpel3;
  String? namaPelanggan;
  String? periode;
  String? nominal;
  String? admin;
  String? uid;
  String? pin;
  String? ref1;
  String? ref2;
  String? ref3;
  String? status;
  String? ket;
  String? saldoTerpotong;
  String? sisaSaldo;
  String? urlStruk;

  InquiryPLNPrabayarData({
    this.kodeProduk,
    this.waktu,
    this.idpel1,
    this.idpel2,
    this.idpel3,
    this.namaPelanggan,
    this.periode,
    this.nominal,
    this.admin,
    this.uid,
    this.pin,
    this.ref1,
    this.ref2,
    this.ref3,
    this.status,
    this.ket,
    this.saldoTerpotong,
    this.sisaSaldo,
    this.urlStruk,
  });

  factory InquiryPLNPrabayarData.fromJson(Map<String, dynamic> json) => InquiryPLNPrabayarData(
    kodeProduk: json["kode_produk"],
    waktu: json["waktu"],
    idpel1: json["idpel1"],
    idpel2: json["idpel2"],
    idpel3: json["idpel3"],
    namaPelanggan: json["nama_pelanggan"],
    periode: json["periode"],
    nominal: json["nominal"],
    admin: json["admin"],
    uid: json["uid"],
    pin: json["pin"],
    ref1: json["ref1"],
    ref2: json["ref2"],
    ref3: json["ref3"],
    status: json["status"],
    ket: json["ket"],
    saldoTerpotong: json["saldo_terpotong"],
    sisaSaldo: json["sisa_saldo"],
    urlStruk: json["url_struk"],
  );
}
