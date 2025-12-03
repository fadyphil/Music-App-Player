import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/features/music_player/domain/repos/audio_player_repository.dart';
import 'music_player_event.dart';
import 'music_player_state.dart';

class MusicPlayerBloc extends Bloc<MusicPlayerEvent, MusicPlayerState> {
  final AudioPlayerRepository _audioRepository;

  StreamSubscription? _positionSubscription;
  StreamSubscription? _durationSubscription;
  StreamSubscription? _playerStateSubscription;
  StreamSubscription? _completionSubscription;

  MusicPlayerBloc(this._audioRepository) : super(const MusicPlayerState()) {
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

    _completionSubscription = _audioRepository.playerCompleteStream.listen((_) {
      add(const MusicPlayerEvent.songFinished());
    });

    // 2. Handle Events using .map()
    // We register one generic handler, then map inside it.
    on<MusicPlayerEvent>((event, emit) async {
      await event.map(
        initMusicQueue: (e) async {
          final song = e.songs[e.currentIndex];
          emit(
            state.copyWith(
              queue: e.songs,
              currentIndex: e.currentIndex,
              currentSong: song,
              isPlaying: true,
            ),
          );
          await _audioRepository.playSong(song.path);
        },
        playSong: (e) async {
          // Update state immediately for UI responsiveness
          emit(state.copyWith(currentSong: e.song, isPlaying: true));
          await _audioRepository.playSong(e.song.path);
        },
        playNextSong: (_) async {
          if (state.queue.isEmpty) return;
          if (state.currentIndex < state.queue.length - 1) {
            final nextIndex = state.currentIndex + 1;
            final nextSong = state.queue[nextIndex];
            emit(
              state.copyWith(
                currentIndex: nextIndex,
                currentSong: nextSong,
                isPlaying: true,
              ),
            );
            await _audioRepository.playSong(nextSong.path);
          }
        },
        playPreviousSong: (_) async {
          if (state.position.inSeconds > 3) {
            await _audioRepository.seek(Duration.zero);
          } else {
            if (state.currentIndex > 0) {
              final prevIndex = state.currentIndex - 1;
              final prevSong = state.queue[prevIndex];
              emit(
                state.copyWith(
                  currentIndex: prevIndex,
                  currentSong: prevSong,
                  isPlaying: true,
                ),
              );
              await _audioRepository.playSong(prevSong.path);
            }
          }
        },
        songFinished: (_) async {
          add(const MusicPlayerEvent.playNextSong());
        },
        pause: (_) async {
          await _audioRepository.pause();
        },
        resume: (_) async {
          await _audioRepository.resume();
        },
        seek: (e) async {
          // Optimistic update
          emit(state.copyWith(position: e.position));
          await _audioRepository.seek(e.position);
        },
        updatePosition: (e) async {
          // These are synchronous state updates, no async work needed
          emit(state.copyWith(position: e.position));
        },
        updateDuration: (e) async {
          emit(state.copyWith(duration: e.duration));
        },
        updatePlayerState: (e) async {
          emit(state.copyWith(isPlaying: e.isPlaying));
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
    return super.close();
  }
}
