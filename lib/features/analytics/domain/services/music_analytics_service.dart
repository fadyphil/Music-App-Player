import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:music_player/features/analytics/domain/entities/play_log.dart';
import 'package:music_player/features/analytics/domain/usecases/log_playback.dart';
import 'package:music_player/features/local%20music/domain/entities/song_entity.dart';
import 'package:music_player/features/music_player/domain/repos/audio_player_repository.dart';

class MusicAnalyticsService with WidgetsBindingObserver {
  final AudioPlayerRepository _audioRepository;
  final LogPlayback _logPlayback;

  StreamSubscription? _playerStateSubscription;
  StreamSubscription? _currentSongSubscription;
  StreamSubscription? _durationSubscription;
  StreamSubscription? _completionSubscription;

  SongEntity? _currentSong;
  Duration _currentSongDuration = Duration.zero;
  DateTime? _playStartTime;
  int _accumulatedMilliseconds = 0;
  bool _isPlaying = false;

  MusicAnalyticsService(this._audioRepository, this._logPlayback);

  void init() {
    WidgetsBinding.instance.addObserver(this);
    _playerStateSubscription =
        _audioRepository.isPlayingStream.listen(_onPlayerStateChanged);
    _currentSongSubscription =
        _audioRepository.currentSongStream.listen(_onSongChanged);
    _durationSubscription =
        _audioRepository.durationStream.listen(_onDurationChanged);
    _completionSubscription =
        _audioRepository.playerCompleteStream.listen((_) => _onSongCompleted());
  }

  void _onPlayerStateChanged(bool isPlaying) {
    final now = DateTime.now();
    if (isPlaying && !_isPlaying) {
      // Resumed/Started
      _playStartTime = now;
    } else if (!isPlaying && _isPlaying) {
      // Paused/Stopped
      if (_playStartTime != null) {
        _accumulatedMilliseconds +=
            now.difference(_playStartTime!).inMilliseconds;
        _playStartTime = null;
      }
    }
    _isPlaying = isPlaying;
  }

  void _onSongChanged(SongEntity? newSong) {
    // Ignore duplicate updates (e.g. metadata refresh)
    if (_currentSong?.id == newSong?.id) return;

    if (_currentSong != null) {
      // Log the previous song if we have accumulated time
      if (_accumulatedMilliseconds > 0 || _playStartTime != null) {
        _finalizeAndLog(_currentSong!, _currentSongDuration);
      }
    }

    // Reset for new song
    _currentSong = newSong;
    // Initial duration from metadata (assuming ms)
    _currentSongDuration =
        newSong != null
            ? Duration(milliseconds: newSong.duration.toInt())
            : Duration.zero;

    _accumulatedMilliseconds = 0;
    _playStartTime = _isPlaying ? DateTime.now() : null;
  }

  void _onDurationChanged(Duration duration) {
    // The decoder often provides a more accurate duration than metadata
    if (duration != Duration.zero) {
      _currentSongDuration = duration;
    }
  }

  void _onSongCompleted() {
    if (_currentSong != null) {
      // Force log as completed
      _finalizeAndLog(
        _currentSong!,
        _currentSongDuration,
        forceIsCompleted: true,
      );
      // Reset accumulator to prevent double logging if song changes later
      _accumulatedMilliseconds = 0;
      _playStartTime = null;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      // Ensure we capture any playing time before the app potentially dies
      if (_isPlaying) {
        _onPlayerStateChanged(false); // Force pause logic to accumulate time
        _isPlaying = true; // Restore state just in case (though we are pausing)
      }
      
      if (_currentSong != null && _accumulatedMilliseconds > 0) {
        _finalizeAndLog(_currentSong!, _currentSongDuration);
        _accumulatedMilliseconds = 0; // Prevent double counting if resumed
      }
    }
  }

  Future<void> _finalizeAndLog(
    SongEntity song,
    Duration duration, {
    bool forceIsCompleted = false,
  }) async {
    // Capture any ongoing session
    if (_isPlaying && _playStartTime != null) {
      final now = DateTime.now();
      _accumulatedMilliseconds +=
          now.difference(_playStartTime!).inMilliseconds;
      // Don't reset _playStartTime here; rely on caller
    }

    final listenedSeconds = (_accumulatedMilliseconds / 1000).round();
    final songDurationSeconds = duration.inSeconds;

    // Filter: Log if listened for > 5 seconds
    if (listenedSeconds > 5) {
      final now = DateTime.now();
      String timeOfDay = 'night';
      final hour = now.hour;
      if (hour >= 5 && hour < 12) {
        timeOfDay = 'morning';
      } else if (hour >= 12 && hour < 18) {
        timeOfDay = 'afternoon';
      }

      final isCompleted =
          forceIsCompleted ||
          (songDurationSeconds > 0 &&
              listenedSeconds >= (songDurationSeconds * 0.9));

      final log = PlayLog(
        songId: song.id,
        songTitle: song.title,
        artist: song.artist,
        album: song.album,
        genre: 'Unknown',
        timestamp: now,
        durationListenedSeconds: listenedSeconds,
        isCompleted: isCompleted,
        sessionTimeOfDay: timeOfDay,
      );

      await _logPlayback(log);
    }
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _playerStateSubscription?.cancel();
    _currentSongSubscription?.cancel();
    _durationSubscription?.cancel();
    _completionSubscription?.cancel();
  }
}
