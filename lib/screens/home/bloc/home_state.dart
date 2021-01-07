part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();
  
  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class LoadingStories extends HomeState {}

class StoriesLoaded extends HomeState {

  final List<int> stories;

  StoriesLoaded(this.stories);

  @override
  List<Object> get props => [stories];
}

class FailedLoadingStories extends HomeState {

  final String message;

  FailedLoadingStories(this.message);

  @override
  List<Object> get props => [message];
}

class HistoryCountLoaded extends HomeState {

  final int numOfHistory;

  HistoryCountLoaded(this.numOfHistory);

  @override
  List<Object> get props => [numOfHistory];
}
