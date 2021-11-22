class Model {
  int id;
  String name;
  int page;
  bool isFavorite;

  Model({this.id, this.name, this.page, this.isFavorite = false});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'name': name,
      'page': page,
    };
    return map;
  }

  Model.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    page = map['page'];
  }
}
