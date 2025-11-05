class SosModel {
  late int _id;
  late String _name;
  late String _icon;
  late String _desc;
  late String _type;

  SosModel({
    int? id,
    String? name,
    String? slug,
    String? icon,
    String? desc,
    String? type
  }) {
    this._id = id!;
    this._name = name!;
    this._icon = icon!;
    this._desc = desc!;
    this._type = type!;
  }

  int get id => _id;
  String get name => _name;
  String get icon => _icon;
  String get desc => _desc;
  String get type => _type; 

  SosModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _icon = json['icon'];
    _desc = json["desc"];
    _type = json["type"];
  }
}
