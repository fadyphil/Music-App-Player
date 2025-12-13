import 'package:music_player/core/usecases/usecase.dart';
import 'package:music_player/features/analytics/domain/usecases/get_all_song_play_counts.dart';
import 'package:music_player/features/local%20music/domain/use%20cases/get_local_songs_use_case.dart';
import 'package:music_player/features/local%20music/presentation/managers/local_music_event.dart';
import 'package:music_player/features/local%20music/presentation/managers/local_music_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocalMusicBloc extends Bloc<LocalMusicEvent, LocalMusicState> {
  final GetLocalSongsUseCase _getLocalSongsUseCase;
  final GetAllSongPlayCounts _getAllSongPlayCountsUseCase;

  LocalMusicBloc(
    this._getLocalSongsUseCase,
    this._getAllSongPlayCountsUseCase,
  ) : super(const LocalMusicState.initial()) {
    on<LocalMusicEvent>((event, emit) async {
      await event.map(
        getLocalSongs: (_) async {
          emit(const LocalMusicState.loading());
          
          final results = await Future.wait([
            _getLocalSongsUseCase(NoParams()),
            _getAllSongPlayCountsUseCase(NoParams()),
          ]);

          final songsResult = results[0] as dynamic; // Type inference helper
          final countsResult = results[1] as dynamic;

          songsResult.fold(
            (failure) => emit(LocalMusicState.failure(failure)),
            (songs) {
              final Map<int, int> counts = countsResult.fold(
                (l) => <int, int>{}, 
                (r) => r
              );
              emit(LocalMusicState.loaded(songs, playCounts: counts));
            },
          );
        },
      );
    });
  }
}
