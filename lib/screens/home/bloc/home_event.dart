part of 'home_bloc.dart';

@immutable
abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class LoadTopStories extends HomeEvent {}

class LoadHistoryCount extends HomeEvent {}

class AddToHistory extends HomeEvent {

  final Story story;

  AddToHistory(this.story);

  @override
  List<Object> get props => [story];
}
