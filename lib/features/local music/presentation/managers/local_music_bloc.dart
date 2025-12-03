import 'package:music_player/core/usecases/usecase.dart';
import 'package:music_player/features/local%20music/domain/use%20cases/get_local_songs_use_case.dart';
import 'package:music_player/features/local%20music/presentation/managers/local_music_event.dart';
import 'package:music_player/features/local%20music/presentation/managers/local_music_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocalMusicBloc extends Bloc<LocalMusicEvent, LocalMusicState> {
  final GetLocalSongsUseCase _getLocalSongsUseCase;
  LocalMusicBloc(this._getLocalSongsUseCase)
    : super(const LocalMusicState.initial()) {
    on<LocalMusicEvent>((event, emit) async {
      await event.map(
        getLocalSongs: (_) async {
          emit(const LocalMusicState.loading());
          final result = await _getLocalSongsUseCase(NoParams());
          result.fold(
            (failure) => emit(LocalMusicState.failure(failure)),
            (songs) => emit(LocalMusicState.loaded(songs)),
          );
        },
      );
    });
  }
}
