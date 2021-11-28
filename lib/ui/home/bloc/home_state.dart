part of 'home_bloc.dart';

abstract class HomeState {
  const HomeState();
}

class HomeInitial extends HomeState {}

class Loading extends HomeState {}

class Success extends HomeState {
  final List<ParentModel> parentModels;

  Success({
    this.parentModels,
  });
}

class Failed extends HomeState {
  final String msg;

  Failed({this.msg});
}

class GetFavoriteItemsSuccess extends HomeState {
  final List<Model> favoriteItems;
  final List<ParentModel> parentModel;

  GetFavoriteItemsSuccess(this.parentModel, this.favoriteItems);
}

class InsertSuccess extends HomeState {
  final List<ParentModel> parentModel;

  InsertSuccess(this.parentModel);
}

class DeleteSuccess extends HomeState {
  final List<ParentModel> parentModel;

  DeleteSuccess(this.parentModel);
}
