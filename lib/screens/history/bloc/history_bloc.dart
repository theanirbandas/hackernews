import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hackernews/database/database_client.dart';
import 'package:hackernews/models/story.dart';
import 'package:meta/meta.dart';

part 'history_event.dart';
part 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  HistoryBloc() : super(HistoryInitial());

  @override
  Stream<HistoryState> mapEventToState(HistoryEvent event,) async* {
    if(event is LoadAllHistory) {
      yield HistoryLoading();
      // Loading all history from Database
      List<Story> stories = await DatabaseClient.provider.getAllHistory();
      yield HistoryLoaded(stories);
    }
  }
}
