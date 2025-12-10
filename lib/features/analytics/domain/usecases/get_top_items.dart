import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/analytics_enums.dart';
import '../entities/analytics_stats.dart';
import '../repositories/analytics_repository.dart';

class GetTopSongsParams {
  final TimeFrame timeFrame;
  final int limit;

  GetTopSongsParams(this.timeFrame, {this.limit = 10});
}

class GetTopSongs implements UseCase<List<TopItem>, GetTopSongsParams> {
  final AnalyticsRepository repository;

  GetTopSongs(this.repository);

  @override
  Future<Either<Failure, List<TopItem>>> call(GetTopSongsParams params) async {
    return await repository.getTopSongs(params.timeFrame, limit: params.limit);
  }
}

class GetTopArtists implements UseCase<List<TopItem>, GetTopSongsParams> {
  final AnalyticsRepository repository;

  GetTopArtists(this.repository);

  @override
  Future<Either<Failure, List<TopItem>>> call(GetTopSongsParams params) async {
    return await repository.getTopArtists(params.timeFrame, limit: params.limit);
  }
}

class GetTopAlbums implements UseCase<List<TopItem>, GetTopSongsParams> {
  final AnalyticsRepository repository;

  GetTopAlbums(this.repository);

  @override
  Future<Either<Failure, List<TopItem>>> call(GetTopSongsParams params) async {
    return await repository.getTopAlbums(params.timeFrame, limit: params.limit);
  }
}

class GetTopGenres implements UseCase<List<TopItem>, GetTopSongsParams> {
  final AnalyticsRepository repository;

  GetTopGenres(this.repository);

  @override
  Future<Either<Failure, List<TopItem>>> call(GetTopSongsParams params) async {
    return await repository.getTopGenres(params.timeFrame, limit: params.limit);
  }
}
