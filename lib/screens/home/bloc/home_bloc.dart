import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hackernews/database/database_client.dart';
import 'package:hackernews/models/story.dart';
import 'package:hackernews/network/network_client.dart';
import 'package:hackernews/res/strings.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {

  HomeBloc() : super(HomeInitial());

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if(event is LoadTopStories) {
      yield* _mapLoadTopStories();
    }
    else if(event is LoadHistoryCount) {
      yield* _mapLoadHistoryCount();
    }
    else if(event is AddToHistory) {
      // Adding history in the database
      await DatabaseClient.provider.addHistory(event.story);
    }
  }

  Stream<HomeState> _mapLoadTopStories() async* {
    yield LoadingStories();

    try {
      // Loading top stories from API
      List stories = await NetworkClient.provider.loadTopStories();
      yield StoriesLoaded(List<int>.from(stories));
    } on Exception {
      yield FailedLoadingStories(Strings.storiesLoadingError);
    }
  }

  Stream<HomeState> _mapLoadHistoryCount() async* {
    // Getting number of history from database
    int count = await DatabaseClient.provider.countHistory();
    yield HistoryCountLoaded(count);
  }
}
