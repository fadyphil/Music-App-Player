import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/theme/app_theme.dart';
import 'package:music_player/features/local%20music/presentation/pages/song_list_page.dart';
import 'package:music_player/core/di/init_dependencies.dart';
import 'package:music_player/features/music_player/presentation/bloc/music_player_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart'; // Import this

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await initDependencies();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

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
        home: const SongListPage(),
      ),
    );
  }
}
