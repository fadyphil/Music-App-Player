import 'package:audio_service/audio_service.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/features/analytics/data/datasources/analytics_local_datasource.dart';
import 'package:music_player/features/analytics/data/repositories/analytics_repository_impl.dart';
import 'package:music_player/features/analytics/domain/repositories/analytics_repository.dart';
import 'package:music_player/features/analytics/domain/usecases/get_general_stats.dart';
import 'package:music_player/features/analytics/domain/usecases/get_top_items.dart';
import 'package:music_player/features/analytics/domain/usecases/get_all_song_play_counts.dart';
import 'package:music_player/features/analytics/domain/usecases/log_playback.dart';
import 'package:music_player/features/analytics/domain/usecases/clear_analytics.dart';
import 'package:music_player/features/analytics/domain/services/music_analytics_service.dart';
import 'package:music_player/features/analytics/presentation/bloc/analytics_bloc.dart';
import 'package:music_player/features/background-notification-feature/data/datasources/audio_handler.dart';
import 'package:music_player/features/local%20music/data/datasource/local_music_datasource.dart';
import 'package:music_player/features/local%20music/data/repositories/music_repository_impl.dart';
import 'package:music_player/features/local%20music/domain/repositories/music_repository.dart';
import 'package:music_player/features/local%20music/domain/use%20cases/get_local_songs_use_case.dart';
import 'package:music_player/features/local%20music/presentation/managers/local_music_bloc.dart';
import 'package:music_player/features/music_player/data/repos/audio_player_repository_impl.dart';
import 'package:music_player/features/music_player/domain/repos/audio_player_repository.dart';
import 'package:music_player/features/music_player/presentation/bloc/music_player_bloc.dart';
import 'package:music_player/features/onboarding/data/datasources/onboarding_local_data_source.dart';
import 'package:music_player/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:music_player/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:music_player/features/onboarding/domain/usecases/cache_first_timer.dart';
import 'package:music_player/features/onboarding/domain/usecases/check_if_user_is_first_timer.dart';
import 'package:music_player/features/onboarding/domain/usecases/log_onboarding_complete.dart';
import 'package:music_player/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:music_player/features/onboarding/presentation/cubit/user_registration_cubit.dart';
import 'package:music_player/features/home/presentation/cubit/home_cubit.dart';
import 'package:music_player/features/profile/data/datasources/profile_local_datasource.dart';
import 'package:music_player/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:music_player/features/profile/domain/repositories/profile_repository.dart';
import 'package:music_player/features/profile/domain/usecases/get_user_profile.dart';
import 'package:music_player/features/profile/domain/usecases/update_user_profile.dart';
import 'package:music_player/features/profile/domain/usecases/clear_cache.dart';
import 'package:music_player/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Create the global instance
final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  await serviceLocator.reset();
  // =========================================================
  // 1. External (Third Party Libraries)
  // =========================================================
  final sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton(() => sharedPreferences);

  serviceLocator.registerLazySingleton(() => OnAudioQuery());
  serviceLocator.registerLazySingleton(() => AudioPlayer());
  final audioHandler = await AudioService.init(
    builder: () => MusicPlayerHandler(player: serviceLocator()),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.example.music_player.channel.audio',
      androidNotificationChannelName: 'Music Playback',
      androidNotificationOngoing: true,
    ),
  );

  serviceLocator.registerSingleton<AudioHandler>(audioHandler);

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
  serviceLocator.registerFactory(() => LocalMusicBloc(
        serviceLocator(),
        serviceLocator(),
      ));

  // =========================================================
  // FEATURE: MUSIC PLAYER
  // =========================================================
  // 2. Repository
  serviceLocator.registerLazySingleton<AudioPlayerRepository>(
    () => AudioPlayerRepositoryImpl(serviceLocator<AudioHandler>()),
  );

  serviceLocator.registerLazySingleton(() => MusicPlayerBloc(
        serviceLocator(),
      ));

  // =========================================================
  // FEATURE: ANALYTICS
  // =========================================================
  serviceLocator.registerLazySingleton<AnalyticsLocalDataSource>(
    () => AnalyticsLocalDataSourceImpl(),
  );

  serviceLocator.registerLazySingleton<AnalyticsRepository>(
    () => AnalyticsRepositoryImpl(serviceLocator()),
  );

  serviceLocator.registerLazySingleton(() => LogPlayback(serviceLocator()));
  serviceLocator.registerLazySingleton(() => GetAllSongPlayCounts(serviceLocator()));
  serviceLocator.registerLazySingleton(() => GetTopSongs(serviceLocator()));
  serviceLocator.registerLazySingleton(() => GetTopArtists(serviceLocator()));
  serviceLocator.registerLazySingleton(() => GetTopAlbums(serviceLocator()));
  serviceLocator.registerLazySingleton(() => GetTopGenres(serviceLocator()));
  serviceLocator.registerLazySingleton(() => GetGeneralStats(serviceLocator()));
  serviceLocator.registerLazySingleton(() => ClearAnalytics(serviceLocator()));
  
  serviceLocator.registerLazySingleton(
    () => MusicAnalyticsService(serviceLocator(), serviceLocator()),
  );

  serviceLocator.registerFactory(
    () => AnalyticsBloc(
      logPlayback: serviceLocator(),
      getTopSongs: serviceLocator(),
      getTopArtists: serviceLocator(),
      getTopAlbums: serviceLocator(),
      getTopGenres: serviceLocator(),
      getGeneralStats: serviceLocator(),
    ),
  );

  // =========================================================
  // FEATURE: ONBOARDING
  // =========================================================
  serviceLocator.registerLazySingleton<OnboardingLocalDataSource>(
    () => OnboardingLocalDataSourceImpl(serviceLocator()),
  );
  serviceLocator.registerLazySingleton<OnboardingRepository>(
    () => OnboardingRepositoryImpl(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(() => CacheFirstTimer(serviceLocator()));
  serviceLocator.registerLazySingleton(
      () => CheckIfUserIsFirstTimer(serviceLocator()));
  serviceLocator.registerLazySingleton(
      () => LogOnboardingComplete(serviceLocator()));

  serviceLocator.registerFactory(
    () => OnboardingCubit(cacheFirstTimer: serviceLocator()),
  );
  serviceLocator.registerFactory(
    () => UserRegistrationCubit(
      updateUserProfile: serviceLocator(),
      logOnboardingComplete: serviceLocator(),
      cacheFirstTimer: serviceLocator(),
    ),
  );

  // =========================================================
  // FEATURE: HOME
  // =========================================================
  serviceLocator.registerFactory(() => HomeCubit());

  // =========================================================
  // FEATURE: PROFILE
  // =========================================================
  serviceLocator.registerLazySingleton<ProfileLocalDataSource>(
    () => ProfileLocalDataSourceImpl(serviceLocator()),
  );
  serviceLocator.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(() => GetUserProfile(serviceLocator()));
  serviceLocator.registerLazySingleton(() => UpdateUserProfile(serviceLocator()));
  serviceLocator.registerLazySingleton(() => ClearCache(serviceLocator()));

  serviceLocator.registerFactory(
    () => ProfileBloc(
      getUserProfile: serviceLocator(),
      updateUserProfile: serviceLocator(),
      clearCache: serviceLocator(),
      clearAnalytics: serviceLocator(),
    ),
  );
}