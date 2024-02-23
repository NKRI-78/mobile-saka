class Category {
  late int _id;
  late String _name;
  late String _slug;
  late String _icon;
  late String _parentId;
  late String _position;
  late String _createdAt;
  late String _updatedAt;

  Category({
    int? id,
    String? name,
    String? slug,
    String? icon,
    String? parentId,
    String? position,
    String? createdAt,
    String? updatedAt,
  }) {
    this._id = id!;
    this._name = name!;
    this._slug = slug!;
    this._icon = icon!;
    this._parentId = parentId!;
    this._position = position!;
    this._createdAt = createdAt!;
    this._updatedAt = updatedAt!;
  }

  int get id => _id;
  String get name => _name;
  String get slug => _slug;
  String get icon => _icon;
  String get parentId => _parentId;
  String get position => _position;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;

  Category.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _slug = json['slug'];
    _icon = json['icon'];
    _parentId = json['parent_id'];
    _position = json['position'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }
}
