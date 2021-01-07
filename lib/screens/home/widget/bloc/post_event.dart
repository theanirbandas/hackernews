part of 'post_bloc.dart';

@immutable
abstract class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object> get props => [];
}

class LoadPost extends PostEvent {

  final String id;

  LoadPost(this.id);

  @override
  List<Object> get props => [id];
}
