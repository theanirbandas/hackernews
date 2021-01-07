import 'dart:convert';

class Story {

  final int id;
  final String by;
  final int score;
  final int time;
  final int descendants;
  final String title;
  final String text;
  final String type;
  final String url;
  
  Story({
    this.id,
    this.by,
    this.score,
    this.time,
    this.descendants,
    this.title,
    this.text,
    this.type,
    this.url,
  });


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'by': by,
      'score': score,
      'time': time,
      'descendants': descendants,
      'title': title,
      'text': text,
      'type': type,
      'url': url,
    };
  }

  factory Story.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return Story(
      id: map['id'],
      by: map['by'],
      score: map['score'],
      time: map['time'],
      descendants: map['descendants'],
      title: map['title'],
      text: map['text'],
      type: map['type'],
      url: map['url'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Story.fromJson(String source) => Story.fromMap(json.decode(source));
}
