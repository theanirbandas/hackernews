import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hackernews/models/story.dart';
import 'package:hackernews/network/network_client.dart';
import 'package:meta/meta.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  
  PostBloc() : super(PostInitial());

  @override
  Stream<PostState> mapEventToState(PostEvent event) async* {
    if(event is LoadPost) {
      yield PostLoading();

      try {
        // Loading story from API
        Story story = await NetworkClient.provider.loadStory(event.id);
        yield PostLoaded(story);
      } on Exception {
        yield PostLoadFailed();
      }
    }
  }
}
