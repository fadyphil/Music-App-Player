import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:music_player/core/error/failure.dart';
import 'package:music_player/features/local%20music/domain/entities/song_entity.dart';
part 'local_music_state.freezed.dart';

@freezed
class LocalMusicState with _$LocalMusicState {
  const factory LocalMusicState.initial() = _Initial;
  const factory LocalMusicState.loading() = _Loading;
  const factory LocalMusicState.loaded(
    List<SongEntity> songs, {
    @Default({}) Map<int, int> playCounts,
  }) = _Loaded;
  const factory LocalMusicState.failure(Failure failure) = _Error;
}
