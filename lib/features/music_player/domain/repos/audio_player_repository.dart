abstract class AudioPlayerRepository {
  // Actions
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

  // Data Streams (The UI listens to these to update the slider/buttons)
  Stream<bool> get isPlayingStream;
  Stream<Duration> get positionStream;
  Stream<Duration> get durationStream;
  Stream<void> get playerCompleteStream;
}
