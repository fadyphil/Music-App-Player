import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

// This class isolates the "Background Service" logic from the rest of the app.
// It is the Single Source of Truth for the OS.
class MusicPlayerHandler extends BaseAudioHandler
    with QueueHandler, SeekHandler {
  final AudioPlayer _player;
  
  // The playlist that just_audio will play sequentially
  final ConcatenatingAudioSource _playlist = ConcatenatingAudioSource(children: []);

  MusicPlayerHandler({AudioPlayer? player}) : _player = player ?? AudioPlayer() {
    _initPlayerListeners();
    // We set the source immediately, even if empty, so the player is ready
    _player.setAudioSource(_playlist);
  }

  // 1. Initialize Listeners: Sync just_audio events -> audio_service State
  void _initPlayerListeners() {
    // Broadcast the current song details to the Lock Screen / Notification
    _player.sequenceStateStream.listen((sequenceState) {
      if (sequenceState == null) return;
      
      // Update Current Media Item
      final currentItem = sequenceState.currentSource;
      if (currentItem != null) {
        final tag = currentItem.tag as MediaItem;
        mediaItem.add(tag);
      }
      
      // Update Queue (Optional: if we modify queue dynamically)
      final sequence = sequenceState.sequence;
      if (sequence.isNotEmpty) {
        final items = sequence.map((source) => source.tag as MediaItem).toList();
        queue.add(items);
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
          processingState: {
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

    // CRITICAL: just_audio's playbackEventStream doesn't fire continuously.
    // We need to bridge the position stream to AudioService so the seek bar works in UI.
    // However, AudioService calculates position based on 'updatePosition' + 'speed' * (now - updateTime).
    // So we just need to ensure we emit a state whenever Play/Pause/Seek happens.
    // _player.playbackEventStream handles this for us. 
    // BUT, we might need to be explicit about the 'playing' state.
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

  @override
  Future<void> skipToNext() => _player.seekToNext();

  @override
  Future<void> skipToPrevious() => _player.seekToPrevious();

  @override
  Future<void> setShuffleMode(AudioServiceShuffleMode shuffleMode) async {
    final enabled = shuffleMode == AudioServiceShuffleMode.all;
    if (enabled) {
      await _player.shuffle();
    }
    await _player.setShuffleModeEnabled(enabled);
  }

  @override
  Future<void> setRepeatMode(AudioServiceRepeatMode repeatMode) async {
    final loopMode = {
      AudioServiceRepeatMode.none: LoopMode.off,
      AudioServiceRepeatMode.one: LoopMode.one,
      AudioServiceRepeatMode.all: LoopMode.all,
      AudioServiceRepeatMode.group: LoopMode.all,
    }[repeatMode]!;
    await _player.setLoopMode(loopMode);
  }

  // 3. Custom Queue Management (The "True Background" Logic)
  
  /// Replaces the entire queue and starts playing from [initialIndex]
  Future<void> setQueueItems({
    required List<MediaItem> items,
    required int initialIndex,
  }) async {
    try {
      // 1. Convert MediaItems to AudioSources
      final audioSources = items.map((item) {
        return AudioSource.file(
          item.extras!['url'] as String,
          tag: item, // Crucial: Attach metadata to the source
        );
      }).toList();

      // 2. Clear and Rebuild Playlist
      // We explicitly clear to avoid "concatenating" to old queues
      await _playlist.clear(); 
      await _playlist.addAll(audioSources);

      // 3. Set the player to this playlist and jump to index
      // Note: We already set _playlist in constructor, but calling setAudioSource again 
      // ensures state reset if needed, or we can just seek.
      // However, just_audio recommends initializing source once if possible.
      // Since we modified _playlist (which is the source), we might just need to seek.
      // But dealing with race conditions on 'clear' + 'add' while playing can be tricky.
      // Safe approach:
      await _player.setAudioSource(_playlist, initialIndex: initialIndex);
      
      // 4. Play
      await _player.play();
      
      // 5. Update AudioService Queue (For UI to see)
      queue.add(items);
      mediaItem.add(items[initialIndex]);
      
    } catch (e) {
      print("Error setting queue: $e");
      // TODO: Add robust error handling (e.g., broadcasting error state)
    }
  }

  // Legacy/Single Song Fallback (Optional)
  Future<void> playSong({
    required String uri,
    required String title,
    required String artist,
    required String id,
    required String artUri,
  }) async {
    final item = MediaItem(
      id: id,
      album: "Local Music",
      title: title,
      artist: artist,
      artUri: Uri.parse(artUri),
      extras: {'url': uri},
    );
    await setQueueItems(items: [item], initialIndex: 0);
  }
}