part of 'post_bloc.dart';

@immutable
abstract class PostState extends Equatable {
  const PostState();
  
  @override
  List<Object> get props => [];
}

class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostLoaded extends PostState {

  final Story story;

  PostLoaded(this.story);

  @override
  List<Object> get props => [story];
}

class PostLoadFailed extends PostState {}