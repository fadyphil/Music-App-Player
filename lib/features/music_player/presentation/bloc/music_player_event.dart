import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:music_player/features/local%20music/domain/entities/song_entity.dart';

part 'music_player_event.freezed.dart';

@freezed
class MusicPlayerEvent with _$MusicPlayerEvent {
  const factory MusicPlayerEvent.initMusicQueue({
    required List<SongEntity> songs,
    required int currentIndex,
  }) = _InitMusicQueue;

  // User Actions
  const factory MusicPlayerEvent.playSong({required SongEntity song}) =
      _PlaySong;
  const factory MusicPlayerEvent.pause() = _Pause;
  const factory MusicPlayerEvent.resume() = _Resume;
  const factory MusicPlayerEvent.seek(Duration position) = _Seek;
  const factory MusicPlayerEvent.playPreviousSong() = _PreviousSong;
  const factory MusicPlayerEvent.playNextSong() = _NextSong;

  // Internal System Events (Triggered by Streams)
  const factory MusicPlayerEvent.updatePosition(Duration position) =
      _UpdatePosition;
  const factory MusicPlayerEvent.updateDuration(Duration duration) =
      _UpdateDuration;
  const factory MusicPlayerEvent.updatePlayerState(bool isPlaying) =
      _UpdatePlayerState;

  const factory MusicPlayerEvent.songFinished() = _SongFinished;
}
