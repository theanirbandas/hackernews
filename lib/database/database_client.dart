import 'dart:async';
import 'dart:developer';

import 'package:hackernews/models/story.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseClient {

  Database _database;

  DatabaseClient._();

  static final DatabaseClient provider = DatabaseClient._();

  Future<Database> get database async {
    if(_database != null) return _database;

    String dbPath = await getDatabasesPath();
    String path = join(dbPath, 'hackernews.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
    return _database;
  }

  /// This method will create the history table in database
  FutureOr<void> _onCreate(Database db, int version) async {
    log('Creating database', name: 'Database');

    String query = '''
    CREATE TABLE history(
      `history_id` INTEGER PRIMARY KEY AUTOINCREMENT, 
      `id` INTEGER, 
      `by` TEXT, 
      `score` INTEGER,
      `time` INTEGER,
      `descendants` INTEGER,
      `title` TEXT,
      `text` TEXT,
      `type` TEXT,
      `url` TEXT
    )
    ''';

    // Creating the table
    await db.execute(query);
    log('Database created', name: 'Database');
  }

  /// This method will return the number of entries
  /// in history table
  Future<int> countHistory() async {
    Database db = await database;

    List<Map<String, dynamic>> data = await db.query(
      'history',
      columns: ['COUNT(history_id) AS num_of_history']
    );

    return data[0]['num_of_history'];
  }

  /// This method will add an entry in history table
  Future<void> addHistory(Story story) async {
    Database db = await database;

    await db.insert('history', story.toMap());
  }

  /// This method will return all entries stored in
  /// the history table
  Future<List<Story>> getAllHistory() async {
    Database db = await database;

    List<Map<String, dynamic>> data = await db.query('history', orderBy: 'history_id DESC');

    List<Story> stories = data.map((e) => Story.fromMap(e)).toList();
    return stories;
  }
}