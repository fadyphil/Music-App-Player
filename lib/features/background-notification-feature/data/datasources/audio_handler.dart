import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

// This class isolates the "Background Service" logic from the rest of the app.
// It is the Single Source of Truth for the OS.
class MusicPlayerHandler extends BaseAudioHandler
    with QueueHandler, SeekHandler {
  final AudioPlayer _player = AudioPlayer();

  MusicPlayerHandler() {
    _initPlayerListeners();
  }

  // 1. Initialize Listeners: Sync just_audio events -> audio_service State
  void _initPlayerListeners() {
    // Broadcast the current song details to the Lock Screen / Notification
    _player.sequenceStateStream.listen((sequenceState) {
      // if (sequenceState == null) return;
      final currentItem = sequenceState.currentSource;
      if (currentItem != null) {
        final tag = currentItem.tag as MediaItem;
        mediaItem.add(tag);
      }
    });

    // Broadcast the Play/Pause/Loading state to the OS
    _player.playbackEventStream.listen((event) {
      final playing = _player.playing;
      playbackState.add(
        playbackState.value.copyWith(
          controls: [
            MediaControl.skipToPrevious,
            if (playing) MediaControl.pause else MediaControl.play,
            MediaControl.skipToNext,
          ],
          systemActions: const {
            MediaAction.seek,
            MediaAction.seekForward,
            MediaAction.seekBackward,
          },
          androidCompactActionIndices: const [0, 1, 2],
          processingState: const {
            ProcessingState.idle: AudioProcessingState.idle,
            ProcessingState.loading: AudioProcessingState.loading,
            ProcessingState.buffering: AudioProcessingState.buffering,
            ProcessingState.ready: AudioProcessingState.ready,
            ProcessingState.completed: AudioProcessingState.completed,
          }[_player.processingState]!,
          playing: playing,
          updatePosition: _player.position,
          bufferedPosition: _player.bufferedPosition,
          speed: _player.speed,
          queueIndex: event.currentIndex,
        ),
      );
    });
  }

  // 2. Playback Methods (Called by your UI/Repository)

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> stop() => _player.stop();

  // 3. Custom Method to Load a Song (Used by your Repository)
  Future<void> playSong({
    required String uri,
    required String title,
    required String artist,
    required String id,
    required String artUri,
  }) async {
    // Create the MediaItem (Metadata for the OS)
    final item = MediaItem(
      id: id,
      album: "Local Music",
      title: title,
      artist: artist,
      artUri: Uri.parse(artUri),
      extras: {'url': uri}, // Store the path in extras
    );

    // Tell audio_service this is the current item
    mediaItem.add(item);

    // Tell just_audio to load this file
    // Note: We attach the MediaItem as a 'tag' so we can retrieve it later
    try {
      await _player.setAudioSource(AudioSource.file(uri, tag: item));
      await _player.play();
    } catch (e) {
      print("Error loading audio source: $e");
    }
  }
}
