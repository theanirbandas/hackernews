import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hackernews/models/story.dart';
import 'package:hackernews/res/strings.dart';
import 'package:hackernews/screens/history/history.dart';
import 'package:hackernews/screens/home/bloc/home_bloc.dart';
import 'package:hackernews/screens/home/widget/post.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final HomeBloc _bloc = HomeBloc();

  List<int> _storyIds = [];
  List<Story> _stories = [];

  int _numOfHistory = 0;

  /// It will store the loaded stories otherwise it will show a
  /// snackbar
  void _loadTopStoriesListener(BuildContext context, HomeState state) {
    if(state is StoriesLoaded) {
      _storyIds = state.stories;
      _stories = List(state.stories.length);
    }
    else if(state is FailedLoadingStories) {
      Scaffold.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(state.message)
      ));
    }
  }

  /// It will store the loaded number of history
  void _historyCountListener(BuildContext context, HomeState state) {
    if(state is HistoryCountLoaded) {
      _numOfHistory = state.numOfHistory;
    }
  }

  /// It will store the loaded post
  void _onLoadPost(Story story) {
    int pos = _storyIds.indexOf(story.id);
    _stories[pos] = story;
  }

  /// It will trigger bloc to add the clicked story
  /// in database & open the post in browser
  void _onPostClick(Story story) {
    _bloc.add(AddToHistory(story));
    _bloc.add(LoadHistoryCount());
    launch(story.url);
  }

  @override
  void initState() { 
    super.initState();

    // Triggering bloc to load top stories & history count
    WidgetsBinding.instance.addPostFrameCallback((_) { 
      _bloc.add(LoadTopStories());
      _bloc.add(LoadHistoryCount());
    });
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
        title: Text(Strings.appTitle),
        actions: [
          FlatButton.icon(
            icon: Icon(
              Icons.history,
              color: Colors.white
            ), 
            label: BlocConsumer<HomeBloc, HomeState>(
              cubit: _bloc,
              buildWhen: (prev, current) => current is HistoryCountLoaded,
              listenWhen: (prev, current) => current is HistoryCountLoaded,
              listener: _historyCountListener,
              builder: (context, state) => Text(
                state is HistoryCountLoaded ? state.numOfHistory.toString() : _numOfHistory.toString(),
                style: TextStyle(color: Colors.white),
              ),
            ), 
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => History()))
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: BlocConsumer<HomeBloc, HomeState>(
            cubit: _bloc,
            listener: _loadTopStoriesListener,
            listenWhen: (prev, current) => 
              current is StoriesLoaded ||
              current is LoadingStories ||
              current is FailedLoadingStories,
            buildWhen: (prev, current) => 
              current is StoriesLoaded ||
              current is LoadingStories ||
              current is FailedLoadingStories,
            builder: (context, state) {
              if(state is StoriesLoaded)
                return _storyList(state.stories);
              else if(state is LoadingStories)
                return Center(child: CircularProgressIndicator());
              else if(_storyIds != null && _storyIds.isNotEmpty)
                return _storyList(_storyIds);
              else
                return Center(child: Text(Strings.appTitle));
            },
          ),
        )
      ),
    );
  }

  /// It will return story listview
  Widget _storyList(List<int> storyIds) {
    return ListView.builder(
      itemCount: storyIds.length,
      itemBuilder: (context, i) => Post(
        storyId: storyIds[i],
        story: _stories[i],
        onLoaded: _onLoadPost,
        onPostClick: _onPostClick,
      )
    );
  }
}