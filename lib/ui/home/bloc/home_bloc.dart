import 'dart:convert';

import 'package:adhkar_flutter/db/db_helper.dart';
import 'package:adhkar_flutter/models/model.dart';
import 'package:adhkar_flutter/models/parent_model.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial());

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is GetData) {
      yield Loading();
      var data = await getDataFromAsset(event.context);
      if (data != null)
        yield Success(parentModels: populateList(data));
      else
        yield Failed(msg: 'Failed');
    }

    if (event is GetFavoriteItems) {
      Map<String, dynamic> map = await refreshList(event.parentModels);
      yield GetFavoriteItemsSuccess(
          map.values.toList()[0], map.values.toList()[1]);
    }

    if (event is InsertNewItem) {
      Map<String, dynamic> map =
          await insertModel(event.model, event.parentModels);
      if (map != null)
        yield InsertSuccess(map.values.toList()[0]);
      else
        yield Failed(msg: 'Failed');
    }
    if (event is DeleteItem) {
      Map map = await deleteModel(event.model, event.parentModels);
      if (map != null)
        yield DeleteSuccess(map.values.toList()[0]);
      else
        yield Failed(msg: 'Failed');
    }
  }
}

Future<dynamic> getDataFromAsset(BuildContext context) async {
  String data =
      await DefaultAssetBundle.of(context).loadString("assets/data.json");
  var jsn = json.decode(data);
  return jsn["data"];
}

List<ParentModel> populateList(data) {
  List<Model> models = [];
  List<ParentModel> parentModels = [];
  for (var item in data) {
    if (models.isNotEmpty) models = [];
    for (var i in item['sous_chp']) {
      models.add(
        Model(name: i['name'], page: i['page'], isFavorite: false),
      );
    }
    parentModels
        .add(ParentModel(id: item['id'], name: item['name'], models: models));
  }
  return parentModels;
}

// Insert item to database
Future<Map<String, dynamic>> insertModel(
    Model model, List<ParentModel> parentModels) async {
  if (model.id == null) {
    await DbHelper.instance.save(model);
    return await refreshList(parentModels);
  }
  return null;
}

// delete item from database
Future<Map<String, dynamic>> deleteModel(
    Model model, List<ParentModel> parentModels) async {
  await DbHelper.instance.delete(model.id);
  return await refreshList(parentModels);
}

Future<Map<String, dynamic>> refreshList(List<ParentModel> parentModels) async {
  List<Model> cachedModels = [];
  var isExist = false;
  // get all favorites item from the database
  cachedModels = await DbHelper.instance.getAllFavoritesModels();
  if (cachedModels.isNotEmpty) {
    for (ParentModel pModel in parentModels) {
      for (Model model in pModel.models) {
        isExist = false;
        for (Model fModel in cachedModels) {
          if (model.name == fModel.name && model.page == fModel.page) {
            isExist = true;
            model.isFavorite = true;
            model.id = fModel.id;
            break;
          }
        }
        if (!isExist) {
          model.isFavorite = false;
          model.id = null;
        }
      }
    }
  } else {
    for (ParentModel pModel in parentModels) {
      for (Model model in pModel.models) {
        model.id = null;
        model.isFavorite = false;
      }
    }
  }
  return {'parentModels': parentModels, 'favoriteModels': cachedModels};
}
