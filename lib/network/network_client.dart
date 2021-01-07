import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hackernews/models/story.dart';

class NetworkClient {

  Dio _dio;
	static const String _baseUrl = 'https://hacker-news.firebaseio.com/v0/';

	NetworkClient._();

	static final NetworkClient provider = NetworkClient._();

	Future<Dio> get dio async {
		if(_dio != null) return _dio;

		BaseOptions options = await _getOptions();
		_dio = Dio(options);
		return _dio;
	}

  /// It will return base options for DIO
	Future<BaseOptions> _getOptions() async {
		BaseOptions options = BaseOptions(
			baseUrl: _baseUrl,
			connectTimeout: 30000,			//30 Seconds
			receiveTimeout: 60000,			//60 Seconds
			contentType: 'application/json',
			followRedirects: false,
		);

		return options;
	}

  /// This method will load top stories from
  /// HackerNews API
  Future<List> loadTopStories() async {
    Dio http = await dio;

    Response response = await http.get('topstories.json');
    if(response.statusCode == HttpStatus.ok)
      return response.data;
    else
      throw Exception('Error in getting stories');
  }

  /// This method will load an individual story from the
  /// Hackernews API
  Future<Story> loadStory(String storyId) async {
    Dio http = await dio;

    Response response = await http.get('item/$storyId.json');
    if(response.statusCode == HttpStatus.ok)
      return Story.fromMap(response.data);
    else
      throw Exception('Error in getting post');
  }
}