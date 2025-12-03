import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:music_player/features/local%20music/domain/entities/song_entity.dart';

part 'music_player_state.freezed.dart';

@freezed
abstract class MusicPlayerState with _$MusicPlayerState {
  const factory MusicPlayerState({
    @Default(false) bool isPlaying,
    @Default(Duration.zero) Duration position,
    @Default(Duration.zero) Duration duration,
    // We keep track of the current song path to highlight it in the list
    SongEntity? currentSong,
    @Default([]) List<SongEntity> queue,
    @Default(0) int currentIndex,
    @Default(false) bool isShuffling,
    @Default(false) bool isLooping,
    @Default(false) bool isPlaylistEnd,
    @Default(false) bool isLoading,
    @Default(false) bool isPlayerReady,
    @Default(false) bool isSeeking,
    @Default(false) bool isPlayingFromQueue,
    @Default(false) bool isPlayingFromPlaylist,
  }) = _MusicPlayerState;
}
