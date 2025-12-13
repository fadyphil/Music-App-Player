import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/analytics_enums.dart';
import '../../domain/entities/analytics_stats.dart';
import '../../domain/entities/play_log.dart';
import '../../domain/repositories/analytics_repository.dart';
import '../datasources/analytics_local_datasource.dart';
import '../failures/analytics_failure.dart';

class AnalyticsRepositoryImpl implements AnalyticsRepository {
  final AnalyticsLocalDataSource dataSource;

  AnalyticsRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, void>> logEvent(PlayLog log) async {
    try {
      await dataSource.logEvent(log);
      return const Right(null);
    } catch (e) {
      return Left(AnalyticsFailure('Failed to log playback event: $e'));
    }
  }

  @override
  Future<Either<Failure, ListeningStats>> getGeneralStats(TimeFrame timeFrame) async {
    try {
      final result = await dataSource.getGeneralStats(timeFrame);
      return Right(result);
    } catch (e) {
      return Left(AnalyticsFailure('Failed to fetch general stats: $e'));
    }
  }

  @override
  Future<Either<Failure, List<TopItem>>> getTopAlbums(TimeFrame timeFrame, {int limit = 10}) async {
    try {
      final result = await dataSource.getTopAlbums(timeFrame, limit);
      return Right(result);
    } catch (e) {
      return Left(AnalyticsFailure('Failed to fetch top albums: $e'));
    }
  }

  @override
  Future<Either<Failure, List<TopItem>>> getTopArtists(TimeFrame timeFrame, {int limit = 10}) async {
    try {
      final result = await dataSource.getTopArtists(timeFrame, limit);
      return Right(result);
    } catch (e) {
      return Left(AnalyticsFailure('Failed to fetch top artists: $e'));
    }
  }

  @override
  Future<Either<Failure, List<TopItem>>> getTopGenres(TimeFrame timeFrame, {int limit = 10}) async {
    try {
      final result = await dataSource.getTopGenres(timeFrame, limit);
      return Right(result);
    } catch (e) {
      return Left(AnalyticsFailure('Failed to fetch top genres: $e'));
    }
  }

  @override
  Future<Either<Failure, List<TopItem>>> getTopSongs(TimeFrame timeFrame, {int limit = 10}) async {
    try {
      final result = await dataSource.getTopSongs(timeFrame, limit);
      return Right(result);
    } catch (e) {
      return Left(AnalyticsFailure('Failed to fetch top songs: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> logOnboardingComplete() async {
    // Fire and forget, or actually log to DB if we had a generic event table.
    // For now, we'll just print or assume the DataSource handles it if we add it there.
    // Since strict adherence is required, I'll add it to DataSource first.
    try {
      await dataSource.logOnboardingComplete();
      return const Right(null);
    } catch (e) {
      return Left(AnalyticsFailure('Failed to log onboarding complete: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> clearData() async {
    try {
      await dataSource.clearAllData();
      return const Right(null);
    } catch (e) {
      return Left(AnalyticsFailure('Failed to clear analytics data: $e'));
    }
  }
}