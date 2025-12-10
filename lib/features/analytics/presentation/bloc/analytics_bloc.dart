import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/analytics_enums.dart';
import '../../domain/entities/analytics_stats.dart';
import '../../domain/entities/play_log.dart';
import '../../domain/usecases/get_general_stats.dart';
import '../../domain/usecases/get_top_items.dart';
import '../../domain/usecases/log_playback.dart';

part 'analytics_event.dart';
part 'analytics_state.dart';
part 'analytics_bloc.freezed.dart';

class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  final LogPlayback _logPlayback;
  final GetTopSongs _getTopSongs;
  final GetTopArtists _getTopArtists;
  final GetTopAlbums _getTopAlbums;
  final GetTopGenres _getTopGenres;
  final GetGeneralStats _getGeneralStats;

  AnalyticsBloc({
    required LogPlayback logPlayback,
    required GetTopSongs getTopSongs,
    required GetTopArtists getTopArtists,
    required GetTopAlbums getTopAlbums,
    required GetTopGenres getTopGenres,
    required GetGeneralStats getGeneralStats,
  })  : _logPlayback = logPlayback,
        _getTopSongs = getTopSongs,
        _getTopArtists = getTopArtists,
        _getTopAlbums = getTopAlbums,
        _getTopGenres = getTopGenres,
        _getGeneralStats = getGeneralStats,
        super(const AnalyticsState.initial()) {
    on<_LogPlaybackEvent>(_onLogPlayback);
    on<_LoadAnalyticsData>(_onLoadAnalyticsData);
  }

  Future<void> _onLogPlayback(
    _LogPlaybackEvent event,
    Emitter<AnalyticsState> emit,
  ) async {
    final res = await _logPlayback(event.log);
    res.fold(
      (l) => null, // Logging failure is silent (fire & forget)
      (r) {
        // Optionally refresh stats if the dashboard is active
        // emit(state); // Or trigger a refresh
      },
    );
  }

  Future<void> _onLoadAnalyticsData(
    _LoadAnalyticsData event,
    Emitter<AnalyticsState> emit,
  ) async {
    emit(const AnalyticsState.loading());

    final timeFrame = event.timeFrame;
    final limit = 10;
    final params = GetTopSongsParams(timeFrame, limit: limit);

    // Run all queries in parallel
    final results = await Future.wait([
      _getTopSongs(params),
      _getTopArtists(params),
      _getTopAlbums(params),
      _getTopGenres(params),
      _getGeneralStats(timeFrame),
    ]);

    // Unpack results
    final songsRes = results[0] as dynamic; // Typed via Either
    final artistsRes = results[1] as dynamic;
    final albumsRes = results[2] as dynamic;
    final genresRes = results[3] as dynamic;
    final statsRes = results[4] as dynamic;

    // Check for failures
    // Simple approach: If any fail, show error.
    // Robust approach: Show empty for failed parts.
    // I will use a simple failure check for MVP.

    List<TopItem> songs = [];
    List<TopItem> artists = [];
    List<TopItem> albums = [];
    List<TopItem> genres = [];
    ListeningStats? stats;
    String? error;

    songsRes.fold((l) => error = l.message, (r) => songs = r);
    artistsRes.fold((l) => error = l.message, (r) => artists = r);
    albumsRes.fold((l) => error = l.message, (r) => albums = r);
    genresRes.fold((l) => error = l.message, (r) => genres = r);
    statsRes.fold((l) => error = l.message, (r) => stats = r);

    if (error != null) {
      emit(AnalyticsState.failure(error!));
    } else {
      emit(AnalyticsState.loaded(
        topSongs: songs,
        topArtists: artists,
        topAlbums: albums,
        topGenres: genres,
        stats: stats!,
        selectedTimeFrame: timeFrame,
      ));
    }
  }
}
