import 'package:music_player/features/local%20music/domain/entities/song_entity.dart';

abstract class AudioPlayerRepository {
  // Actions
  Future<void> setQueue(List<SongEntity> songs, int initialIndex);
  
  // Legacy / Single Song
  Future<void> playSong(
    String path,
    String title,
    String artist,
    String songId,
    String albumId,
  );
  
  Future<void> pause();
  Future<void> resume();
  Future<void> seek(Duration position);
  Future<void> stop();
  Future<void> skipToNext();
  Future<void> skipToPrevious();
  
  Future<void> setShuffleMode(bool enabled);
  Future<void> setRepeatMode(int mode); // 0: Off, 1: All, 2: One
  // Actually, UI usually cycles: Off -> All -> One -> Off
  Future<void> cycleRepeatMode();

  // Data Streams (The UI listens to these to update the slider/buttons)
  Stream<bool> get isPlayingStream;
  Stream<bool> get isShuffleModeEnabledStream;
  Stream<int> get loopModeStream; // 0: off, 1: all, 2: one
  Stream<Duration> get positionStream;
  Stream<Duration> get durationStream;
  Stream<void> get playerCompleteStream; // Listen to queue end or song end?
  Stream<SongEntity?> get currentSongStream; // New: Listen to current song updates from OS
}