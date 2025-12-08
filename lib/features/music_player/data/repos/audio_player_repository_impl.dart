import 'package:audio_service/audio_service.dart';
import 'package:music_player/features/background-notification-feature/data/datasources/audio_handler.dart';
import 'package:music_player/features/music_player/domain/repos/audio_player_repository.dart';

class AudioPlayerRepositoryImpl implements AudioPlayerRepository {
  // Inject the abstract AudioHandler, but we cast it to our implementation to access custom methods
  final AudioHandler _audioHandler;

  AudioPlayerRepositoryImpl(this._audioHandler);

  @override
  Future<void> playSong(
    String path,
    String title,
    String artist,
    String songId,
    String albumId,
  ) async {
    // We cast to access our custom 'playSong' method
    final player = _audioHandler as MusicPlayerHandler;

    await player.playSong(
      uri: path,
      title: title,
      artist: artist,
      id: songId,
      artUri: "content://media/external/audio/albumart/$albumId",
    );
  }

  @override
  Future<void> pause() => _audioHandler.pause();

  @override
  Future<void> resume() => _audioHandler.play();

  @override
  Future<void> seek(Duration position) => _audioHandler.seek(position);

  // STREAMS: Bridge audio_service streams to your domain

  @override
  Stream<bool> get isPlayingStream =>
      _audioHandler.playbackState.map((state) => state.playing).distinct();

  @override
  Stream<Duration> get positionStream => AudioService.position; // Special static stream

  @override
  Stream<Duration> get durationStream =>
      _audioHandler.mediaItem.map((item) => item?.duration ?? Duration.zero);

  @override
  Stream<void> get playerCompleteStream => _audioHandler.playbackState
      .where(
        (state) =>
            state.processingState == AudioProcessingState.completed &&
            !state.playing,
      )
      .map((event) => null)
      .distinct();

  @override
  Future<void> stop() {
    return _audioHandler.customAction('stop');
  }
}
