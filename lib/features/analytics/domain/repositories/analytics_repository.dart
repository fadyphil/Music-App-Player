import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failure.dart';
import '../entities/analytics_enums.dart';
import '../entities/analytics_stats.dart';
import '../entities/play_log.dart';

abstract interface class AnalyticsRepository {
  /// Logs a single playback event to the local database.
  Future<Either<Failure, void>> logEvent(PlayLog log);

  /// Retrieves the top [limit] songs for the given [timeFrame].
  Future<Either<Failure, List<TopItem>>> getTopSongs(TimeFrame timeFrame, {int limit = 10});

  /// Retrieves the top [limit] artists for the given [timeFrame].
  Future<Either<Failure, List<TopItem>>> getTopArtists(TimeFrame timeFrame, {int limit = 10});

  /// Retrieves the top [limit] albums for the given [timeFrame].
  Future<Either<Failure, List<TopItem>>> getTopAlbums(TimeFrame timeFrame, {int limit = 10});
  
   /// Retrieves the top [limit] genres for the given [timeFrame].
  Future<Either<Failure, List<TopItem>>> getTopGenres(TimeFrame timeFrame, {int limit = 10});

  /// Retrieves general statistics (total time, count, time of day dist) for [timeFrame].
  Future<Either<Failure, ListeningStats>> getGeneralStats(TimeFrame timeFrame);
}
