import 'package:just_audio/just_audio.dart';
import 'package:music_player/features/music_player/domain/repos/audio_player_repository.dart';

class AudioPlayerRepositoryImpl implements AudioPlayerRepository {
  final AudioPlayer _audioPlayer;

  AudioPlayerRepositoryImpl(this._audioPlayer);

  @override
  Stream<bool> get isPlayingStream =>
      _audioPlayer.playerStateStream.map((state) => state.playing);

  @override
  Stream<Duration> get positionStream => _audioPlayer.positionStream;

  @override
  Stream<Duration> get durationStream =>
      _audioPlayer.durationStream.map((duration) => duration ?? Duration.zero);

  @override
  Future<void> playSong(String path) async {
    try {
      // 1. Load the file
      await _audioPlayer.setFilePath(path);
      // 2. Start playing
      await _audioPlayer.play();
    } catch (e) {
      throw Exception("Error playing audio: $e");
    }
  }

  @override
  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  @override
  Future<void> resume() async {
    await _audioPlayer.play();
  }

  @override
  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  @override
  Future<void> stop() async {
    await _audioPlayer.stop();
  }

  @override
  Stream<void> get playerCompleteStream => _audioPlayer.playerStateStream
      .where((state) => state.processingState == ProcessingState.completed)
      .map((_) {});
}
