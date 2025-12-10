import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/features/analytics/domain/entities/play_log.dart';
import 'package:music_player/features/analytics/domain/usecases/log_playback.dart';
import 'package:music_player/features/music_player/domain/repos/audio_player_repository.dart';
import 'music_player_event.dart';
import 'music_player_state.dart';

class MusicPlayerBloc extends Bloc<MusicPlayerEvent, MusicPlayerState> {
  final AudioPlayerRepository _audioRepository;
  final LogPlayback _logPlayback;

  StreamSubscription? _positionSubscription;
  StreamSubscription? _durationSubscription;
  StreamSubscription? _playerStateSubscription;
  StreamSubscription? _completionSubscription;
  StreamSubscription? _currentSongSubscription;
  StreamSubscription? _shuffleSubscription;
  StreamSubscription? _loopSubscription;

  MusicPlayerBloc(this._audioRepository, this._logPlayback)
    : super(const MusicPlayerState()) {
    // 1. Setup Listeners
    _positionSubscription = _audioRepository.positionStream.listen((pos) {
      add(MusicPlayerEvent.updatePosition(pos));
    });

    _durationSubscription = _audioRepository.durationStream.listen((dur) {
      add(MusicPlayerEvent.updateDuration(dur));
    });

    _playerStateSubscription = _audioRepository.isPlayingStream.listen((
      isPlaying,
    ) {
      add(MusicPlayerEvent.updatePlayerState(isPlaying));
    });

    _shuffleSubscription = _audioRepository.isShuffleModeEnabledStream.listen((
      enabled,
    ) {
      add(MusicPlayerEvent.updateShuffleState(enabled));
    });

    _loopSubscription = _audioRepository.loopModeStream.listen((mode) {
      add(MusicPlayerEvent.updateLoopState(mode));
    });

    // Listen to the Operating System / Audio Service for the current song
    _currentSongSubscription = _audioRepository.currentSongStream.listen((
      song,
    ) {
      if (song != null) {
        add(MusicPlayerEvent.updateCurrentSong(song));
      }
    });

    _completionSubscription = _audioRepository.playerCompleteStream.listen((_) {
      add(const MusicPlayerEvent.songFinished());
    });

    // 2. Handle Events
    on<MusicPlayerEvent>((event, emit) async {
      await event.map(
        initMusicQueue: (e) async {
          // Optimistic update
          emit(
            state.copyWith(
              queue: e.songs,
              currentIndex: e.currentIndex,
              currentSong: e.songs[e.currentIndex],
              isPlaying: true,
            ),
          );
          // Delegate to Handler
          await _audioRepository.setQueue(e.songs, e.currentIndex);
        },
        playSong: (e) async {
          // Play Single Song (Legacy/Specific use case)
          emit(state.copyWith(currentSong: e.song, isPlaying: true));
          await _audioRepository.playSong(
            e.song.path,
            e.song.title,
            e.song.artist,
            e.song.id.toString(),
            e.song.album,
          );
        },
        playNextSong: (_) async {
          // Delegate to Handler
          await _audioRepository.skipToNext();
        },
        playPreviousSong: (_) async {
          // Delegate to Handler
          await _audioRepository.skipToPrevious();
        },
        songFinished: (_) async {
          // The player handles song transitions automatically.
          // This event now only signifies the END of the entire playlist.
          emit(state.copyWith(isPlaying: false, isPlaylistEnd: true));
        },
        pause: (_) async {
          await _audioRepository.pause();
        },
        resume: (_) async {
          await _audioRepository.resume();
        },
        toggleShuffle: (_) async {
          final newValue = !state.isShuffling;
          // Optimistic update
          emit(state.copyWith(isShuffling: newValue));
          await _audioRepository.setShuffleMode(newValue);
        },
        cycleLoopMode: (_) async {
          final nextMode = (state.loopMode + 1) % 3;
          // Optimistic update
          emit(state.copyWith(loopMode: nextMode));
          await _audioRepository.setRepeatMode(nextMode);
        },
        seek: (e) async {
          emit(state.copyWith(position: e.position));
          await _audioRepository.seek(e.position);
        },
        updatePosition: (e) async {
          emit(state.copyWith(position: e.position));
        },
        updateDuration: (e) async {
          emit(state.copyWith(duration: e.duration));
        },
        updatePlayerState: (e) async {
          emit(state.copyWith(isPlaying: e.isPlaying));
        },
        updateShuffleState: (e) async {
          emit(state.copyWith(isShuffling: e.isShuffleModeEnabled));
        },
        updateLoopState: (e) async {
          emit(state.copyWith(loopMode: e.loopMode));
        },
        updateCurrentSong: (e) async {
          // --- ANALYTICS LOGGING ---
          if (state.currentSong != null) {
            final oldSong = state.currentSong!;
            final secondsListened = state.position.inSeconds;

            // Only log if listened for more than 10 seconds
            if (secondsListened > 10) {
              final now = DateTime.now();
              final hour = now.hour;
              String timeOfDay = 'night';
              if (hour >= 5 && hour < 12) {
                timeOfDay = 'morning';
              } else if (hour >= 12 && hour < 18) {
                timeOfDay = 'afternoon';
              }

              final log = PlayLog(
                songId: oldSong.id,
                songTitle: oldSong.title,
                artist: oldSong.artist,
                album: oldSong.album,
                genre: 'Unknown', // Genre not available in current SongEntity
                timestamp: now,
                durationListenedSeconds: secondsListened,
                isCompleted:
                    secondsListened >= (state.duration.inSeconds * 0.9),
                sessionTimeOfDay: timeOfDay,
              );

              // Fire and forget
              _logPlayback(log);
            }
          }
          // -------------------------

          // Try to match the incoming song (from OS) with our full-detail queue
          final index = state.queue.indexWhere((s) => s.id == e.song.id);
          final fullSong = index != -1 ? state.queue[index] : e.song;

          emit(
            state.copyWith(
              currentSong: fullSong,
              currentIndex: index != -1 ? index : state.currentIndex,
            ),
          );
        },
      );
    });
  }

  @override
  Future<void> close() {
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();
    _playerStateSubscription?.cancel();
    _completionSubscription?.cancel();
    _currentSongSubscription?.cancel();
    _shuffleSubscription?.cancel();
    _loopSubscription?.cancel();
    return super.close();
  }
}
