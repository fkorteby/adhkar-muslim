import 'package:adhkar_flutter/models/model.dart';

class ParentModel {
  final int id;
  final String name;
  bool isExpand;
  List<Model> models;

  ParentModel({this.id, this.name, this.models, this.isExpand = false});
}
