import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../domain/entities/analytics_enums.dart';
import '../../domain/entities/analytics_stats.dart';
import '../../domain/entities/play_log.dart';

abstract interface class AnalyticsLocalDataSource {
  Future<void> initDb();
  Future<void> logEvent(PlayLog log);
  Future<List<TopItem>> getTopSongs(TimeFrame timeFrame, int limit);
  Future<List<TopItem>> getTopArtists(TimeFrame timeFrame, int limit);
  Future<List<TopItem>> getTopAlbums(TimeFrame timeFrame, int limit);
  Future<List<TopItem>> getTopGenres(TimeFrame timeFrame, int limit);
  Future<ListeningStats> getGeneralStats(TimeFrame timeFrame);
}

class AnalyticsLocalDataSourceImpl implements AnalyticsLocalDataSource {
  static Database? _database;
  static const String _tableName = 'playback_logs';

  @override
  Future<void> initDb() async {
    if (_database != null) return;

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'music_analytics.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            song_id INTEGER,
            title TEXT,
            artist TEXT,
            album TEXT,
            genre TEXT,
            timestamp INTEGER,
            duration_listened INTEGER,
            is_completed INTEGER,
            time_of_day TEXT
          )
        ''');
        await db.execute('CREATE INDEX idx_timestamp ON $_tableName (timestamp)');
      },
    );
  }

  Future<Database> get db async {
    if (_database == null) await initDb();
    return _database!;
  }

  @override
  Future<void> logEvent(PlayLog log) async {
    final database = await db;
    // Freezed toJson returns timestamp as string/int depending on config?
    // By default DateTime -> String (ISO8601).
    // SQLite expects INTEGER (Epoch) or TEXT.
    // I defined columns as INTEGER.
    // I need to ensure toJson handles this, OR manually map.
    // Manual map is safer for SQLite specifics.
    
    await database.insert(_tableName, {
      'song_id': log.songId,
      'title': log.songTitle,
      'artist': log.artist,
      'album': log.album,
      'genre': log.genre,
      'timestamp': log.timestamp.millisecondsSinceEpoch,
      'duration_listened': log.durationListenedSeconds,
      'is_completed': log.isCompleted ? 1 : 0,
      'time_of_day': log.sessionTimeOfDay,
    });
  }

  int _getTimestampThreshold(TimeFrame timeFrame) {
    final now = DateTime.now();
    switch (timeFrame) {
      case TimeFrame.day:
        return now.subtract(const Duration(days: 1)).millisecondsSinceEpoch;
      case TimeFrame.week:
        return now.subtract(const Duration(days: 7)).millisecondsSinceEpoch;
      case TimeFrame.month:
        return now.subtract(const Duration(days: 30)).millisecondsSinceEpoch;
      case TimeFrame.year:
        return now.subtract(const Duration(days: 365)).millisecondsSinceEpoch;
      case TimeFrame.all:
        return 0;
    }
  }

  @override
  Future<List<TopItem>> getTopSongs(TimeFrame timeFrame, int limit) async {
    final database = await db;
    final threshold = _getTimestampThreshold(timeFrame);

    final result = await database.rawQuery('''
      SELECT 
        CAST(song_id AS TEXT) as id, 
        title as label, 
        artist as sub_label, 
        COUNT(*) as value 
      FROM $_tableName 
      WHERE timestamp > ? 
      GROUP BY song_id 
      ORDER BY value DESC 
      LIMIT ?
    ''', [threshold, limit]);

    return result.map((e) => TopItem.fromJson(e).copyWith(type: 'song')).toList();
  }

  @override
  Future<List<TopItem>> getTopArtists(TimeFrame timeFrame, int limit) async {
    final database = await db;
    final threshold = _getTimestampThreshold(timeFrame);

    final result = await database.rawQuery('''
      SELECT 
        artist as id,
        artist as label, 
        COUNT(*) as value 
      FROM $_tableName 
      WHERE timestamp > ? 
      GROUP BY artist 
      ORDER BY value DESC 
      LIMIT ?
    ''', [threshold, limit]);

    return result.map((e) => TopItem.fromJson(e).copyWith(type: 'artist')).toList();
  }

  @override
  Future<List<TopItem>> getTopAlbums(TimeFrame timeFrame, int limit) async {
    final database = await db;
    final threshold = _getTimestampThreshold(timeFrame);

    final result = await database.rawQuery('''
      SELECT 
        album as id,
        album as label, 
        artist as sub_label,
        COUNT(*) as value 
      FROM $_tableName 
      WHERE timestamp > ? 
      GROUP BY album 
      ORDER BY value DESC 
      LIMIT ?
    ''', [threshold, limit]);

    return result.map((e) => TopItem.fromJson(e).copyWith(type: 'album')).toList();
  }

  @override
  Future<List<TopItem>> getTopGenres(TimeFrame timeFrame, int limit) async {
    final database = await db;
    final threshold = _getTimestampThreshold(timeFrame);

    final result = await database.rawQuery('''
      SELECT 
        genre as id,
        genre as label, 
        COUNT(*) as value 
      FROM $_tableName 
      WHERE timestamp > ? 
      GROUP BY genre 
      ORDER BY value DESC 
      LIMIT ?
    ''', [threshold, limit]);

    return result.map((e) => TopItem.fromJson(e).copyWith(type: 'genre')).toList();
  }

  @override
  Future<ListeningStats> getGeneralStats(TimeFrame timeFrame) async {
    final database = await db;
    final threshold = _getTimestampThreshold(timeFrame);

    // 1. Total Time (Seconds) and Count
    final generalData = await database.rawQuery('''
      SELECT 
        COALESCE(SUM(duration_listened), 0) as total_duration, 
        COUNT(*) as total_count 
      FROM $_tableName 
      WHERE timestamp > ?
    ''', [threshold]);

    // 2. Time of Day Distribution
    final timeDistribution = await database.rawQuery('''
      SELECT 
        time_of_day, 
        COUNT(*) as count 
      FROM $_tableName 
      WHERE timestamp > ? 
      GROUP BY time_of_day
    ''', [threshold]);

    Map<String, int> distributionMap = {};
    for (var row in timeDistribution) {
      if (row['time_of_day'] != null) {
        distributionMap[row['time_of_day'] as String] = row['count'] as int;
      }
    }
    
    final row = generalData.first;
    // Note: total_duration from SQL is Seconds, UI expects Minutes
    final totalSeconds = row['total_duration'] as int? ?? 0;

    return ListeningStats(
      totalMinutes: totalSeconds ~/ 60,
      totalSongsPlayed: row['total_count'] as int? ?? 0,
      timeOfDayDistribution: distributionMap,
    );
  }
}