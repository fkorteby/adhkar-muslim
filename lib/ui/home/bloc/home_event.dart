part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class GetData extends HomeEvent {
  final BuildContext context;
  GetData({@required this.context});
  @override
  List<Object> get props => null;
}

class GetPdf extends HomeEvent {
  final BuildContext context;
  GetPdf({@required this.context});
  @override
  List<Object> get props => null;
}
