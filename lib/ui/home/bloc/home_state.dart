part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class Loading extends HomeState {
  @override
  List<Object> get props => null;
}

class Success extends HomeState {
  final dynamic data;
  final List<ParentModel> parentModels;
  final dynamic doaa;
  final File file;

  Success({this.data, this.parentModels, this.file, this.doaa});

  @override
  List<Object> get props => null;
}

class SuccessDoaa extends HomeState {
  final List<Model> models;

  SuccessDoaa({this.models});

  @override
  List<Object> get props => null;
}

class Failed extends HomeState {
  final String msg;

  Failed({this.msg});

  @override
  List<Object> get props => null;
}

class PdfSuccess extends HomeState {
  final File file;

  PdfSuccess({this.file});

  @override
  List<Object> get props => null;
}

class PdfFailed extends HomeState {
  final String msg;

  PdfFailed({this.msg});

  @override
  List<Object> get props => null;
}
