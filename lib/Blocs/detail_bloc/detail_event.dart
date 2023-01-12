part of 'detail_bloc.dart';

abstract class DetailEvent extends Equatable {
  const DetailEvent();

  @override
  List<Object> get props => [];
}

class CurrentProductIdChanged extends DetailEvent {
  final int newId;

  const CurrentProductIdChanged(this.newId);

  @override
  List<Object> get props => [newId];
}
