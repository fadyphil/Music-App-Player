import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/features/local%20music/data/datasource/local_music_datasource.dart';
import 'package:music_player/features/local%20music/data/repositories/music_repository_impl.dart';
import 'package:music_player/features/local%20music/domain/repositories/music_repository.dart';
import 'package:music_player/features/local%20music/domain/use%20cases/get_local_songs_use_case.dart';
import 'package:music_player/features/local%20music/presentation/managers/local_music_bloc.dart';
import 'package:music_player/features/music_player/data/repos/audio_player_repository_impl.dart';
import 'package:music_player/features/music_player/domain/repos/audio_player_repository.dart';
import 'package:music_player/features/music_player/presentation/bloc/music_player_bloc.dart';
import 'package:on_audio_query/on_audio_query.dart';

// Import your features

// Create the global instance
final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  await serviceLocator.reset();
  // =========================================================
  // 1. External (Third Party Libraries)
  // =========================================================
  serviceLocator.registerLazySingleton(() => OnAudioQuery());

  // =========================================================
  // 2. Data Layer
  // =========================================================

  // Data Source: We inject OnAudioQuery into it
  serviceLocator.registerLazySingleton<LocalMusicDatasource>(
    () => LocalMusicDatasourceImpl(serviceLocator()),
  );

  // Repository: We inject the DataSource into it
  serviceLocator.registerLazySingleton<MusicRepository>(
    () => MusicRepositoryImpl(serviceLocator()),
  );

  // =========================================================
  // 3. Domain Layer
  // =========================================================

  // Use Case: We inject the Repository into it
  serviceLocator.registerLazySingleton(
    () => GetLocalSongsUseCase(serviceLocator()),
  );

  // =========================================================
  // 4. Presentation Layer (Bloc)
  // =========================================================
  serviceLocator.registerFactory(() => LocalMusicBloc(serviceLocator()));

  // =========================================================
  // FEATURE: MUSIC PLAYER
  // =========================================================

  // 1. External: The actual player engine
  serviceLocator.registerLazySingleton(() => AudioPlayer());

  // 2. Repository
  serviceLocator.registerLazySingleton<AudioPlayerRepository>(
    () => AudioPlayerRepositoryImpl(serviceLocator()),
  );

  serviceLocator.registerLazySingleton(() => MusicPlayerBloc(serviceLocator()));
}
