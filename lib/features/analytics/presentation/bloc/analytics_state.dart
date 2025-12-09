part of 'analytics_bloc.dart';

@freezed
class AnalyticsState with _$AnalyticsState {
  const factory AnalyticsState.initial() = _Initial;
  const factory AnalyticsState.loading() = _Loading;
  const factory AnalyticsState.loaded({
    required List<TopItem> topSongs,
    required List<TopItem> topArtists,
    required List<TopItem> topAlbums,
    required List<TopItem> topGenres,
    required ListeningStats stats,
    required TimeFrame selectedTimeFrame,
  }) = _Loaded;
  const factory AnalyticsState.failure(String message) = _Failure;
}
