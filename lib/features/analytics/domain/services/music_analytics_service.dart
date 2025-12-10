import 'dart:async';

import 'package:music_player/features/analytics/domain/entities/play_log.dart';
import 'package:music_player/features/analytics/domain/usecases/log_playback.dart';
import 'package:music_player/features/local%20music/domain/entities/song_entity.dart';
import 'package:music_player/features/music_player/domain/repos/audio_player_repository.dart';

class MusicAnalyticsService {
  final AudioPlayerRepository _audioRepository;
  final LogPlayback _logPlayback;

  StreamSubscription? _playerStateSubscription;
  StreamSubscription? _currentSongSubscription;
  StreamSubscription? _durationSubscription;

  SongEntity? _currentSong;
  Duration _currentSongDuration = Duration.zero;
  DateTime? _playStartTime;
  int _accumulatedMilliseconds = 0;
  bool _isPlaying = false;

  MusicAnalyticsService(this._audioRepository, this._logPlayback);

  void init() {
    _playerStateSubscription =
        _audioRepository.isPlayingStream.listen(_onPlayerStateChanged);
    _currentSongSubscription =
        _audioRepository.currentSongStream.listen(_onSongChanged);
    _durationSubscription =
        _audioRepository.durationStream.listen(_onDurationChanged);
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
    if (_currentSong != null) {
      // Log the previous song
      _finalizeAndLog(_currentSong!, _currentSongDuration);
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

  Future<void> _finalizeAndLog(SongEntity song, Duration duration) async {
    // Capture any ongoing session
    if (_isPlaying && _playStartTime != null) {
      final now = DateTime.now();
      _accumulatedMilliseconds +=
          now.difference(_playStartTime!).inMilliseconds;
      // Note: We don't reset _playStartTime here because the calling method (_onSongChanged)
      // will handle the reset/re-initialization logic.
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

      final log = PlayLog(
        songId: song.id,
        songTitle: song.title,
        artist: song.artist,
        album: song.album,
        genre: 'Unknown',
        timestamp: now,
        durationListenedSeconds: listenedSeconds,
        isCompleted:
            songDurationSeconds > 0 &&
            listenedSeconds >= (songDurationSeconds * 0.9),
        sessionTimeOfDay: timeOfDay,
      );

      await _logPlayback(log);
    }
  }

  void dispose() {
    _playerStateSubscription?.cancel();
    _currentSongSubscription?.cancel();
    _durationSubscription?.cancel();
  }
}
