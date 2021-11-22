import 'dart:convert';
import 'dart:io';

import 'package:adhkar_flutter/models/model.dart';
import 'package:adhkar_flutter/models/parent_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial());

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is GetData) {
      yield Loading();
      var file = await getFileFromAssets(asset: 'assets/adhkar.pdf');
      if (file != null) {
        var data = await getData(event.context);
        if (data != null) {
          List<Model> models = [];
          List<ParentModel> parentModels = [];
          for (var item in data) {
            if (models.isNotEmpty) models = [];
            for (var i in item['sous_chp']) {
              models.add(
                Model(name: i['name'], page: i['page'], isFavorite: false),
              );
            }
            parentModels.add(ParentModel(
                id: item['id'], name: item['name'], models: models));
          }
          yield Success(
            parentModels: parentModels,
            file: file,
          );
        } else
          yield Failed(msg: 'Err');
      } else
        yield Failed(msg: 'Err');
    }

    if (event is GetPdf) {
      yield Loading();
      var file = await getFileFromAssets(asset: 'assets/adhkar.pdf');
      if (file != null) {
        yield PdfSuccess(file: file);
      } else
        yield PdfFailed(msg: 'Err');
    }
  }
}

Future<File> getFileFromAssets({asset}) async {
  try {
    var data = await rootBundle.load(asset);
    var bytes = data.buffer.asUint8List();
    var dir = await getApplicationDocumentsDirectory();
    File file = File('${dir.path}/adhkar.pdf');

    File assetFile = await file.writeAsBytes(bytes);
    return assetFile;
  } catch (ex) {
    throw Exception(ex.toString());
  }
}

Future<dynamic> getData(BuildContext context) async {
  String data =
      await DefaultAssetBundle.of(context).loadString("assets/data.json");
  var jsn = json.decode(data);
  return jsn["data"];
}
