import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hackernews/models/story.dart';
import 'package:hackernews/res/strings.dart';
import 'package:hackernews/screens/history/bloc/history_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class History extends StatefulWidget {
  History({Key key}) : super(key: key);

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {

  final HistoryBloc _bloc = HistoryBloc();

  @override
  void initState() { 
    super.initState();
    
    // Triggering bloc to load all history
    WidgetsBinding.instance.addPostFrameCallback((_) => _bloc.add(LoadAllHistory()));
  }

  @override
  void dispose() { 
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.historyTitle),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: BlocBuilder<HistoryBloc, HistoryState>(
            cubit: _bloc,
            builder: (context, state) => state is HistoryLoaded ? _historyList(state.stories) : Center(
              child: CircularProgressIndicator(),
            )
          ),
        )
      ),
    );
  }

  /// It will return history listview if [stories] is 
  /// not empty, otherwise it will return a center text
  /// label
  Widget _historyList(List<Story> stories) {
    return stories.isEmpty ? Center(
      child: Text(Strings.noHistory),
    ) : ListView.separated(
      padding: const EdgeInsets.all(5.0),
      itemCount: stories.length,
      separatorBuilder: (context, i) => Divider(color: Colors.blueGrey),
      itemBuilder: (context, i) => GestureDetector(
        onTap: () => launch(stories[i].url),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            stories[i].title ?? stories[i].text,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ), 
    );
  }
}