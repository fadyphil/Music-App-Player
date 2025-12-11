import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/theme/app_theme.dart';
import 'package:music_player/core/usecases/usecase.dart';
import 'package:music_player/features/home/presentation/pages/home_page.dart';
import 'package:music_player/core/di/init_dependencies.dart';
import 'package:music_player/features/analytics/domain/services/music_analytics_service.dart';
import 'package:music_player/features/music_player/presentation/bloc/music_player_bloc.dart';
import 'package:music_player/features/onboarding/domain/usecases/check_if_user_is_first_timer.dart';
import 'package:music_player/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart'; // Import this

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await initDependencies();
  serviceLocator<MusicAnalyticsService>().init();
  
  final isFirstRunResult = await serviceLocator<CheckIfUserIsFirstTimer>()(NoParams());
  final isFirstRun = isFirstRunResult.fold(
    (l) => true, // Default to true on error
    (r) => r,
  );

  runApp(MyApp(isFirstRun: isFirstRun));
}

class MyApp extends StatefulWidget {
  final bool isFirstRun;
  const MyApp({super.key, required this.isFirstRun});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => serviceLocator<MusicPlayerBloc>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Spotify el 8alaba',
        theme: AppTheme.darkThemeMode,
        home: widget.isFirstRun ? const OnboardingPage() : const HomePage(),
      ),
    );
  }
}
