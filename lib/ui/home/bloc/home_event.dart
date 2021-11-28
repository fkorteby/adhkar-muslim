part of 'home_bloc.dart';

abstract class HomeEvent {
  const HomeEvent();
}

class GetData extends HomeEvent {
  final BuildContext context;

  GetData({@required this.context});
}

class GetFavoriteItems extends HomeEvent {
  final BuildContext context;
  final List<ParentModel> parentModels;

  GetFavoriteItems(this.context, this.parentModels);
}

class InsertNewItem extends HomeEvent {
  final BuildContext context;
  final Model model;
  final List<ParentModel> parentModels;

  InsertNewItem(this.context, this.model, this.parentModels);
}

class DeleteItem extends HomeEvent {
  final BuildContext context;
  final Model model;
  final List<ParentModel> parentModels;

  DeleteItem(this.context, this.model, this.parentModels);
}
