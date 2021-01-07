import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hackernews/models/story.dart';
import 'package:hackernews/screens/home/widget/bloc/post_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timeago/timeago.dart' as timeago;

class Post extends StatefulWidget {

  final int storyId;
  final Story story;
  final void Function(Story) onLoaded;
  final void Function(Story) onPostClick;

  Post({
    Key key,
    this.storyId,
    this.story,
    this.onLoaded,
    this.onPostClick
  }) : super(key: key);

  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {

  final PostBloc _bloc = PostBloc();
  Story _story;

  /// It will execute the callback function
  void _loadPostListener(BuildContext context, PostState state) {
    if(state is PostLoaded) {
      widget.onLoaded.call(state.story);
      _story = state.story;
    }
  }

  @override
  void initState() { 
    super.initState();

    _story = widget.story;
    if(_story == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _bloc.add(LoadPost(widget.storyId.toString())));
    }
  }

  @override
  void dispose() { 
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(5.0),
      elevation: 3.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0)
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: _story != null ? _postView(_story) : BlocConsumer<PostBloc, PostState>(
          cubit: _bloc,
          listener: _loadPostListener,
          builder: (context, state) => state is PostLoaded ? _postView(state.story) : _postLoadingView(),
        )
      ),
    );
  }

  Widget _postView(Story story) {
    return Container(
      child: GestureDetector(
        onTap: () => widget.onPostClick?.call(story),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  story.type.toUpperCase(),
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey
                  ),
                ),
                const SizedBox(width: 5.0),
                Text(
                  '•',
                  style: TextStyle(
                    color: Colors.blueGrey
                  ),
                ),
                const SizedBox(width: 5.0),
                Text(
                  'Posted by ${story.by}',
                  style: TextStyle(
                    color: Colors.blueGrey
                  ),
                ),
                const SizedBox(width: 5.0),
                Flexible(
                  child: Text(
                    timeago.format(DateTime.fromMillisecondsSinceEpoch(story.time * 1000)),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.blueGrey
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5.0),
            Text(
              story.title,
              style: TextStyle(
                color: Colors.blueGrey[800],
                fontSize: 16.0,
                fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox(height: 5.0),
            story.text != null ? Text(
              story.text,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ) : SizedBox(),
            const SizedBox(height: 5.0),
            Row(
              children: [
                if(story.descendants != null)
                  ...[
                    Text(
                      'Comments: ${story.descendants}',
                    ),
                    const SizedBox(width: 5.0),
                    const Text('•'),
                    const SizedBox(width: 5.0),
                  ],
                Text(
                  'Score: ${story.score}',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // It will return the shimmer effect
  Widget _postLoadingView() {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Shimmer.fromColors(
            child: Container(height: 20.0, width: double.infinity, color: Colors.white), 
            baseColor: Colors.grey[200],
            highlightColor: Colors.white
          ),
          const SizedBox(height: 10.0),
          Shimmer.fromColors(
            child: Container(height: 20.0, width: double.infinity, color: Colors.white), 
            baseColor: Colors.grey[200],
            highlightColor: Colors.white
          ),
          const SizedBox(height: 10.0),
          Shimmer.fromColors(
            child: Container(height: 20.0, width: double.infinity, color: Colors.white), 
            baseColor: Colors.grey[200],
            highlightColor: Colors.white
          ),
        ],
      ),
    );
  }
}